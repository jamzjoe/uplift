import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/presentation/pages/auth_wrapper.dart';
import 'package:uplift/authentication/presentation/pages/login_screen.dart';
import 'package:uplift/home/presentation/page/home.dart';
import 'package:uplift/home/presentation/page/tab_screen/qr_reader_screen.dart';
import 'package:uplift/notifications/presentaion/page/notification_screen.dart';

final GoRouter router = GoRouter(
    // redirect: (context, state) {
    //   return "/introduction_screen";
    // },
    initialLocation: "/auth_wrapper",
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
          path: '/auth_wrapper',
          name: "auth_wrapper",
          pageBuilder: (context, state) =>
              const MaterialPage(child: AuthWrapper()),
          routes: [
            GoRoute(
              name: "login",
              path: 'login',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: LoginScreen()),
            )
          ]),
      GoRoute(
          name: 'home',
          path: '/home',
          pageBuilder: (context, state) => MaterialPage(
                child: HomeScreen(
                  user: state.extra as User,
                ),
              ),
          routes: [
            GoRoute(
              path: 'notification',
              name: 'notification',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: NotificationScreen()),
            ),
            GoRoute(
              path: 'qr_reader',
              name: 'qr_reader',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: QRReaderScreen()),
            )
          ])
    ]);
