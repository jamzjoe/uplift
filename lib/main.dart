import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uplift/utils/services/initialize.dart';
import 'firebase_options.dart';
import 'myapp.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Initialize initialize = Initialize();

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  NotificationRepository.initialize(flutterLocalNotificationsPlugin);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: whiteColor, // navigation bar color
      systemNavigationBarContrastEnforced: true));

  initialize.requestPermission();
  initialize.listenIncomingNotification();
  initialize.registerBackgroundMessageHandler();
  runApp(const MyApp());
}
