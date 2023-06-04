import 'package:flutter/material.dart';
import 'package:myspots/shared/layouts/HomeLayout.dart';

import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'dart:typed_data';

class CreateReelScreen extends StatelessWidget {
  CreateReelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      children: [
        Text('Create Reel'),
        FutureBuilder(
          future: availableCameras(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Expanded(child: ReelEditor(snapshot.data!));
            } else {
              return Text('Loading');
            }
          },
        )
      ],
    );
  }
}

class ReelEditor extends StatefulWidget {
  final List<CameraDescription> cameras;
  ReelEditor(this.cameras);

  @override
  _ReelEditorState createState() => _ReelEditorState();
}

class _ReelEditorState extends State<ReelEditor> {
  late CameraController _cameraController;
  List<File> _videoClips = [];
  VideoPlayerController? _videoPlayerController;
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initCameraController();
    // _initializeEmptyVideoPlayer();
  }

  Future<void> _initCameraController() async {
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<File> _createEmptyVideoFile() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagePath = '${appDir.path}/placeholder.png';
    final videoPath = '${appDir.path}/placeholder.mp4';
    final File imageFile = File(imagePath);
    final File videoFile = File(videoPath);

    if (!await imageFile.exists()) {
      // Create a black image of size 640x480
      final imageBytes = Uint8List.fromList([
        0x89,
        0x50,
        0x4e,
        0x47,
        0x0d,
        0x0a,
        0x1a,
        0x0a,
        0x00,
        0x00,
        0x00,
        0x0d,
        0x49,
        0x48,
        0x44,
        0x52,
        0x00,
        0x00,
        0x02,
        0x80,
        0x00,
        0x00,
        0x02,
        0x00,
        0x08,
        0x00,
        0x00,
        0x00,
        0x00,
        0xf4,
        0x78,
        0xd4,
        0xfa,
        0x00,
        0x00,
        0x00,
        0x09,
        0x70,
        0x48,
        0x59,
        0x73,
        0x00,
        0x00,
        0x0e,
        0xc3,
        0x00,
        0x00,
        0x0e,
        0xc3,
        0x01,
        0xc7,
        0x6f,
        0xa8,
        0x64,
        0x00,
        0x00,
        0x00,
        0x0a,
        0x49,
        0x44,
        0x41,
        0x54,
        0x78,
        0x9c,
        0x63,
        0x60,
        0x00,
        0x02,
        0x00,
        0x00,
        0x05,
        0x00,
        0x01,
        0x0d,
        0x0a,
        0x2d,
        0xb4,
        0x00,
        0x00,
        0x00,
        0x00,
        0x49,
        0x45,
        0x4e,
        0x44,
        0xae,
        0x42,
        0x60,
        0x82
      ]);

      await imageFile.writeAsBytes(imageBytes);
    }

    if (!await videoFile.exists()) {
      int resultCode = await _flutterFFmpeg.execute(
          '-loop 1 -i $imagePath -c:v libx264 -t 1 -pix_fmt yuv420p -vf scale=640:480 $videoPath');
      if (resultCode != 0) {
        print(
            'Error creating empty video file, FFmpeg error code: $resultCode');

        final completer = Completer<File>();
        completer.complete(null);
        return completer.future;
      }
    }

    return videoFile;
  }

  // Future<void> _initializeEmptyVideoPlayer() async {
  //   File emptyVideoFile = await _createEmptyVideoFile();
  //   if (emptyVideoFile != null) {
  //     _videoPlayerController
  //         ?.dispose(); // Dispose the old controller if there's one
  //     _videoPlayerController = VideoPlayerController.file(emptyVideoFile);
  //     _videoPlayerController.initialize().then((_) {
  //       setState(() {});
  //     });
  //     _videoPlayerController.setLooping(true);
  //   } else {
  //     print("Error initializing empty video player");
  //   }
  // }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  // Record video clip
  Future<void> _recordVideo() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    if (_cameraController.value.isRecordingVideo) {
      return;
    }
    await _cameraController.startVideoRecording();
    await Future.delayed(Duration(seconds: 5));
    XFile videoFile = await _cameraController.stopVideoRecording();
    setState(() {
      _videoClips.add(File(videoFile.path));
    });
  }

// Pick video from gallery
  Future<void> _pickVideo() async {
    final XFile? videoFile =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (videoFile != null) {
      setState(() {
        _videoClips.add(File(videoFile.path));
      });
    }
  }

// Merge video clips
  Future<void> _mergeVideoClips() async {
    if (_videoClips.length < 2) {
      return;
    }
    final String tempDirPath = (await getTemporaryDirectory()).path;
    final String outputFilePath = '$tempDirPath/output.mp4';

    String inputFiles = _videoClips.map((file) => "-i ${file.path}").join(" ");
    String filterComplex = "concat=n=${_videoClips.length}:v=1:a=1 [v] [a]";

    await _permissionStatus();
    int resultCode = await _flutterFFmpeg.execute(
        '$inputFiles -filter_complex "$filterComplex" -map "[v]" -map "[a]" $outputFilePath');
    if (resultCode == 0) {
      setState(() {
        _videoPlayerController =
            VideoPlayerController.file(File(outputFilePath));
        _videoPlayerController!.initialize().then((_) => setState(() {}));
        _videoPlayerController!.setLooping(true);
        _videoPlayerController!.play();
      });
    } else {
      print("Error merging video clips, FFmpeg error code: $resultCode");
    }
  }

  Future<String> _getOutputPath() async {
    final outputDirectory = await getApplicationDocumentsDirectory();
    final fileName = 'reel_${DateTime.now().millisecondsSinceEpoch}.mp4';
    return '${outputDirectory.path}/$fileName';
  }

// Export merged video
  Future<void> _exportVideo() async {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return;
    }
    final String outputPath = await _getOutputPath();
    final String inputFilePath = _videoPlayerController!.dataSource;
    int resultCode =
        await _flutterFFmpeg.execute("-i $inputFilePath -c copy $outputPath");

    if (resultCode == 0) {
      print("Video exported successfully: $outputPath");
    } else {
      print("Error exporting video, FFmpeg error code: $resultCode");
    }
  }

  Future<String> getOutputPath() async {
    final outputDirectory = await getApplicationDocumentsDirectory();
    final fileName = 'reel${DateTime.now().millisecondsSinceEpoch}.mp4';
    return '${outputDirectory.path}/$fileName';
  }

  Future<void> _permissionStatus() async {
    if (await Permission.storage.status != PermissionStatus.granted) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _videoPlayerController != null &&
                  _videoPlayerController!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController!),
                )
              : _cameraController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: CameraPreview(_cameraController),
                    )
                  : Container(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.videocam),
              onPressed: _recordVideo,
            ),
            IconButton(
              icon: Icon(Icons.video_library),
              onPressed: _pickVideo,
            ),
            IconButton(
              icon: Icon(Icons.merge_type),
              onPressed: _mergeVideoClips,
            ),
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _exportVideo,
            ),
          ],
        ),
      ],
    );
  }
}
