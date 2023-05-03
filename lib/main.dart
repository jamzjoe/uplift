import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uplift/authentication/domain/repository/auth_repository.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/post_prayer_request/post_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/utils/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  NotificationSettings settings = await requestPermission();

  final fmcToken = await FirebaseMessaging.instance.getToken();
  log(fmcToken.toString());
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// Firebase local notification plugin
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title // description
      importance: Importance.high,
      playSound: true);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

//Firebase messaging
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
        message.notification!.hashCode,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
            android: AndroidNotificationDetails(
              '1',
              'Uplift',
            ),
            iOS: DarwinNotificationDetails()),
      );
      log('Message also contained a notification: ${message.notification!.title!}');
    }
  });

  runApp(const MyApp());
}

Future<NotificationSettings> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  log('User granted permission: ${settings.authorizationStatus}');

  return settings;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(AuthRepository()),
        ),
        BlocProvider<PostPrayerRequestBloc>(
            create: (context) => PostPrayerRequestBloc()),
        BlocProvider<GetPrayerRequestBloc>(
            create: (context) =>
                GetPrayerRequestBloc()..add(const GetPostRequestList())),
        BlocProvider<FriendsSuggestionsBlocBloc>(
            create: (context) =>
                FriendsSuggestionsBlocBloc()..add(FetchUsersEvent()))
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Uplift Development',
        theme: ThemeData(
          dialogTheme: const DialogTheme(surfaceTintColor: whiteColor),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor))),
          appBarTheme: const AppBarTheme(surfaceTintColor: whiteColor),
          bottomSheetTheme: const BottomSheetThemeData(
              surfaceTintColor: whiteColor,
              elevation: 2,
              shape: RoundedRectangleBorder()),
          dividerTheme:
              DividerThemeData(color: secondaryColor.withOpacity(0.2)),
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: whiteColor),
          bottomAppBarTheme:
              const BottomAppBarTheme(surfaceTintColor: whiteColor),
          colorSchemeSeed: Colors.lightBlue,
          popupMenuTheme:
              const PopupMenuThemeData(surfaceTintColor: whiteColor),
          useMaterial3: true,
        ),
      ),
    );
  }
}
