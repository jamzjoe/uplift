import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uplift/authentication/domain/repository/auth_repository.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/presentation/bloc/explore_get_prayer_request/explore_get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/post_prayer_request/post_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/same_intention_bloc/same_intentions_suggestion_bloc.dart';
import 'package:uplift/utils/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
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
  tz.initializeTimeZones();

  NotificationRepository.initialize(flutterLocalNotificationsPlugin);
  requestPermission();
  FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      NotificationRepository.showNotification(
          id: message.notification.hashCode,
          title: message.notification!.title,
          body: message.notification!.body);
    }
  }).onError((handleError) {
    log(handleError);
  });

  runApp(const MyApp());
}

Future<String?> getFCMToken() async {
  String? token;
  try {
    token = await FirebaseMessaging.instance.getToken();
  } catch (e) {
    log("Error getting FCM token: $e");
  }
  return token;
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

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  if (message.data.containsKey('event') &&
      message.data['event'] == 'token_refresh') {
    // Refresh FCM token in the background
    updateFCMTokenInBackground();
  }
}

void registerBackgroundMessageHandler() {
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
}

void updateFCMTokenInBackground() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final token = await messaging.getToken();

  // Update the token in Firestore for the current user
  // Assuming you have a 'users' collection in Firestore
  FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserID)
      .update({'device_token': token}).then((_) {
    log('FCM token updated successfully in Firestore');
  }).catchError((error) {
    log('Failed to update FCM token in Firestore: $error');
  });
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
            create: (context) => GetPrayerRequestBloc()),
        BlocProvider<FriendsSuggestionsBlocBloc>(
            create: (context) => FriendsSuggestionsBlocBloc()),
        BlocProvider<NotificationBloc>(create: (context) => NotificationBloc()),
        BlocProvider<FriendRequestBloc>(
            create: (context) => FriendRequestBloc()),
        BlocProvider<ApprovedFriendsBloc>(
            create: (context) => ApprovedFriendsBloc()),
        BlocProvider<EncourageBloc>(create: (context) => EncourageBloc()),
        BlocProvider<ExploreBloc>(create: (context) => ExploreBloc()),
        BlocProvider<SameIntentionsSuggestionBloc>(
            create: (context) => SameIntentionsSuggestionBloc())
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Uplift Development',
        theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android:
                      ZoomPageTransitionsBuilder(), // Apply this to every platforms you need.
                }),
            fontFamily: 'Varela',
            tabBarTheme: const TabBarTheme(
                indicatorColor: primaryColor, labelColor: primaryColor),
            dialogTheme: const DialogTheme(surfaceTintColor: whiteColor),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor))),
            appBarTheme: const AppBarTheme(
                surfaceTintColor: whiteColor, backgroundColor: whiteColor),
            bottomSheetTheme: const BottomSheetThemeData(
                surfaceTintColor: whiteColor,
                elevation: 2,
                shape: RoundedRectangleBorder()),
            dividerTheme: DividerThemeData(color: lighter.withOpacity(0.2)),
            scaffoldBackgroundColor: whiteColor,
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: whiteColor),
            bottomAppBarTheme:
                const BottomAppBarTheme(surfaceTintColor: whiteColor),
            colorSchemeSeed: Colors.lightBlue,
            dialogBackgroundColor: whiteColor,
            popupMenuTheme:
                const PopupMenuThemeData(surfaceTintColor: whiteColor),
            useMaterial3: true),
      ),
    );
  }
}
