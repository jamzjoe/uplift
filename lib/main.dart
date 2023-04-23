import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uplift/utils/router/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Uplift Development',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
