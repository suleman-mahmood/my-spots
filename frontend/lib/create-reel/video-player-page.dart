import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myspots/create-reel/final-step.dart';
import 'package:myspots/shared/layouts/HomeLayout.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myspots/services/models.dart' as model;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;

  const VideoPlayerPage({Key? key, required this.videoPath}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  final storageRef = FirebaseStorage.instance.ref();

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) async {
        await _controller.setLooping(true);
        await _controller.play();
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveVideo(BuildContext context) async {
    context.read<model.AppState>().startLoading();

    final videoPath = await compressVideo(widget.videoPath);
    final outputThumbnailPath = await generateVideoThumbnail(videoPath);

    // Save video to gallery (optional)
    await GallerySaver.saveVideo(videoPath);

    final videosRef = storageRef.child(videoPath.split('/').last);
    final thumbnailRef = storageRef.child(outputThumbnailPath.split('/').last);

    File file = File(videoPath);
    File thumbnailFile = File(outputThumbnailPath);

    print("Displaying logs");
    print(thumbnailFile);
    print(outputThumbnailPath);

    try {
      await videosRef.putFile(file);
      await thumbnailRef.putFile(thumbnailFile);
    } on Exception catch (e) {
      print(e);
    }

    final downloadUrl = await videosRef.getDownloadURL();
    final thumbnailUrl = await thumbnailRef.getDownloadURL();

    context.read<model.AppState>().stopLoading();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FinalStepScreen(videoUrl: downloadUrl, thumbnailUrl: thumbnailUrl),
      ),
    );
  }

  Future<String> compressVideo(String videoPath) async {
    final FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
    final String outputFilePath =
        videoPath.replaceFirst(".mp4", "_compressed.mp4");

    int rc = await flutterFFmpeg
        .execute('-i $videoPath -vcodec libx265 -crf 30 $outputFilePath');
    if (rc == 0) {
      print("Video compressed successfully");

      return outputFilePath;
    } else {
      print("Failed to compress video");
      return videoPath;
    }
  }

  Future<String> generateVideoThumbnail(String videoPath) async {
    final FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
    final String thumbnailPath =
        videoPath.replaceFirst(".mp4", "_thumbnail.jpg");

    final int rc = await flutterFFmpeg.execute(
      '-i $videoPath -ss 00:00:01 -vframes 1 $thumbnailPath',
    );

    if (rc == 0) {
      return thumbnailPath;
    } else {
      return ''; // Empty string indicates failure to generate the thumbnail
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeLayout(children: [
      Expanded(
          child: Container(
        color: Colors.black,
      )),
      Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                _saveVideo(context);
              },
              child: const Icon(
                Icons.arrow_forward_outlined,
              ),
            ),
          ),
        ],
      ),
      Expanded(
          child: Container(
        color: Colors.black,
      )),
    ]);
  }
}
