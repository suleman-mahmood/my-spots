import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:myspots/src/config/router/app_router.dart';
import 'package:myspots/src/presentation/views/video_player_view.dart';
import 'package:myspots/src/presentation/widgets/layouts/HomeLayout.dart';
import 'package:myspots/src/presentation/widgets/loaders/CircularLoader.dart';
import 'package:image_picker/image_picker.dart';

import 'package:myspots/src/services/models.dart' as model;

import 'package:provider/provider.dart';

class CreateReelsView extends StatelessWidget {
  const CreateReelsView({super.key});

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
      context.router.push(VideoPlayerRoute(videoPath: videoPath));
    }
  }

  Future<void> startVideoRecording() async {
    await _controller.startVideoRecording();
  }

  Future<void> stopVideoRecording(BuildContext context) async {
    final path = await _controller.stopVideoRecording();

    if (context.mounted) {
      context.router.push(VideoPlayerRoute(videoPath: path.path));
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(children: [
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
                            setState(() {
                              isRecording = true;
                            });
                            await startVideoRecording();
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
      ]),
    );
  }
}
