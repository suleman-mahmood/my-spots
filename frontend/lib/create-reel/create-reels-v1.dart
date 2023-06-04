import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

class CreateReelScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CreateReelScreen> {
  CameraController? _controller;
  List<XFile> _videoFiles = [];
  final ImagePicker _picker = ImagePicker();
  final FlutterFFmpeg _ffmpeg = FlutterFFmpeg();

  late List<CameraDescription> cameras;
  String outputFilePath = '';

  Future<void> _initializeCamera() async {
    // initialize camera
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      // Initialize the camera controller and set it up.
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      _controller?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    }).catchError((err) {
      print('Error: $err');
    });
  }

  Future<void> _startRecording() async {
    // start recording
    if (_controller != null && !_controller!.value.isInitialized) {
      return;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${DateTime.now()}.mp4';

    try {
      await _controller?.startVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return;
    }
  }

  Future<void> _stopRecording() async {
    // stop recording and add file to _videoFiles
    if (_controller != null && !_controller!.value.isRecordingVideo) {
      return;
    }

    try {
      final pickedFile = await _controller?.stopVideoRecording();
      if (pickedFile != null) {
        setState(() {
          _videoFiles.add(pickedFile);
        });
      }
    } on CameraException catch (e) {
      print(e);
      return;
    }
  }

  Future<void> _pickVideo() async {
    // pick video from gallery and add file to _videoFiles
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      _videoFiles.add(pickedFile);
    }
  }

  Future<void> _mergeVideos() async {
    // merge videos in _videoFiles using ffmpeg
    String videoPaths = _videoFiles.map((path) => 'file $path').join('|');
    outputFilePath = 'output.mp4';
    String command = '-i "concat:$videoPaths" -c copy $outputFilePath';

    await _ffmpeg.execute(command);
    await saveVideo();
  }

  Future<void> saveVideo() async {
    bool? videoSaved = await GallerySaver.saveVideo(outputFilePath);
    print(videoSaved);
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // display camera preview
          (_controller != null && _controller!.value.isInitialized)
              ? CameraPreview(_controller!)
              : Center(child: CircularProgressIndicator()),

          // display recorded videos
          // ListView.builder(
          //   itemCount: _videoFiles.length,
          //   itemBuilder: (context, index) {
          //     VideoPlayerController videoPlayerController =
          //         VideoPlayerController.file(File(_videoFiles[index].path));
          //     videoPlayerController.initialize();
          //     return VideoPlayer(videoPlayerController);
          //   },
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller != null && !_controller!.value.isRecordingVideo) {
            _startRecording();
          } else {
            _stopRecording();
          }
        },
        child: Icon((_controller != null && _controller!.value.isRecordingVideo)
            ? Icons.stop
            : Icons.videocam),
      ),
    );
  }
}
