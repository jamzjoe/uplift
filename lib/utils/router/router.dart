import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/presentation/pages/login_screen.dart';
import 'package:uplift/introduction/introduction.dart';

final GoRouter router = GoRouter(
    // redirect: (context, state) {
    //   return "/introduction_screen";
    // },
    initialLocation: "/introduction_screen",
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
          path: '/introduction_screen',
          name: "introduction",
          pageBuilder: (context, state) =>
              const MaterialPage(child: IntroductionScreen()),
          routes: [
            GoRoute(
              name: "auth",
              path: 'auth',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: LoginScreen()),
            )
          ]),
    ]);
