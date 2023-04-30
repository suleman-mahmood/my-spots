import 'package:flutter/material.dart';
import 'package:myspots/routes.dart';
import 'package:myspots/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //   return MultiProvider(
    //     providers: [
    //       // StreamProvider<model.User>(
    //       //   create: (_) => FirestoreService().streamUser(),
    //       //   initialData: model.User(),
    //       // ),
    //       // ChangeNotifierProvider<model.ErrorModel>(
    //       //   create: (_) => model.ErrorModel(),
    //       // ),
    //     ],
    //     child: MaterialApp(
    //       title: 'My Spots',
    //       theme: appTheme,
    //       routes: appRoutes,
    //     ),
    //   );
    // }
    return MaterialApp(
      title: 'My Spots',
      theme: appTheme,
      routes: appRoutes,
    );
  }
}
