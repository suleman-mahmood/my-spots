import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:myspots/services/backend.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:myspots/services/models.dart' as model;

class CreateReelScreen extends StatefulWidget {
  @override
  _VideoRecorderWidgetState createState() => _VideoRecorderWidgetState();
}

class _VideoRecorderWidgetState extends State<CreateReelScreen> {
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;
  String _videoPath = '';

  // Create a storage reference from our app
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    await _controller?.initialize();
  }

  Future<String> _getVideoFilePath() async {
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${directory.path}/video_$timestamp.mp4';
  }

  Future<void> _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    // final path = await _getVideoFilePath();
    await _controller!.startVideoRecording();
    setState(() {
      _isRecording = true;
      // _videoPath = path;
    });
  }

  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) {
      return;
    }

    final path = await _controller!.stopVideoRecording();

    setState(() {
      _isRecording = false;
      _videoPath = path.path;
    });

    await _saveVideo();
  }

  Future<void> _saveVideo() async {
    bool? videoSaved = await GallerySaver.saveVideo(_videoPath);
    print(videoSaved);

    File file = File(_videoPath);
    final videosRef = storageRef.child(_videoPath.split('/').last);

    try {
      await videosRef.putFile(file);
    } on Exception catch (e) {
      print(e);
    }

    final downloadUrl = await videosRef.getDownloadURL();

    // await BackendService().createReel(model.Reel(videoUrl: downloadUrl));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Reel'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildCameraPreview(),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: CameraPreview(_controller!),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record),
            iconSize: 48.0,
            color: Colors.red,
            onPressed: () {
              if (_isRecording) {
                _stopRecording();
              } else {
                _startRecording();
              }
            },
          ),
        ],
      ),
    );
  }
}
