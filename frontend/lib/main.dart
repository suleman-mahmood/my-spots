import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:myspots/src/config/router/app_router.dart';
import 'package:myspots/src/config/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:myspots/src/services/models.dart' as model;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(firstCamera: firstCamera));
}

class MyApp extends StatefulWidget {
  final CameraDescription firstCamera;

  const MyApp({super.key, required this.firstCamera});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Text(
            'error',
            textDirection: TextDirection.ltr,
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider<model.User>(
                  create: (_) => model.User(),
                ),
                ChangeNotifierProvider<model.AppState>(
                  create: (_) =>
                      model.AppState(firstCamera: widget.firstCamera),
                ),
              ],
              child: MaterialApp.router(
                title: 'My Spots',
                routerConfig: _appRouter.config(),
                theme: appTheme,
              ));
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator();
      },
    );
  }
}
