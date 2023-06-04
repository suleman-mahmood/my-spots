import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:myspots/services/backend.dart';
import 'package:myspots/shared/layouts/HomeLayout.dart';
import 'package:myspots/shared/loaders/CircularLoader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:myspots/services/models.dart' as model;

import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'video-player-page.dart';

class CreateReelScreen extends StatelessWidget {
  const CreateReelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firstCamera = context.read<model.AppState>().firstCamera;
    return TakeVideoScreen(camera: firstCamera);
  }
}

class TakeVideoScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakeVideoScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakeVideoScreenState createState() => TakeVideoScreenState();
}

class TakeVideoScreenState extends State<TakeVideoScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: true,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> pickVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    final videoPath = video?.path;

    if (videoPath == null) return;

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(videoPath: videoPath),
        ),
      );
    }
  }

  Future<void> startVideoRecording() async {
    await _controller.startVideoRecording();
  }

  Future<void> stopVideoRecording(BuildContext context) async {
    final path = await _controller.stopVideoRecording();

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(videoPath: path.path),
        ),
      );
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    return HomeLayout(children: [
      Expanded(
          child: Container(
        color: Colors.black,
      )),
      FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CameraPreview(_controller),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onLongPress: () async {
                          await startVideoRecording();
                          setState(() {
                            isRecording = true;
                          });
                        },
                        onLongPressUp: () {
                          setState(() {
                            isRecording = false;
                          });
                          stopVideoRecording(context);
                        },
                        child: isRecording
                            ? Icon(
                                Icons.stop,
                                size: 80,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.fiber_manual_record,
                                size: 80,
                                color: Colors.red,
                              ),
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.browse_gallery_outlined,
                          size: 80,
                          color: Colors.green,
                        ),
                        onTap: () {
                          pickVideo(context);
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const CircularLoader();
          }
        },
      ),
      Expanded(
          child: Container(
        color: Colors.black,
      )),
    ]);
  }
}
