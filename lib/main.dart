import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uplift/utils/services/initialize.dart';
import 'myapp.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final Initialize _initialize = Initialize();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: whiteColor, // navigation bar color
      systemNavigationBarContrastEnforced: true));

  NotificationRepository.initialize(flutterLocalNotificationsPlugin);

  _initialize.requestPermission();
  _initialize.listenIncomingNotification();
  _initialize.registerBackgroundMessageHandler();
  runApp(const MyApp());
}
