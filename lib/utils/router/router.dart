import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/authentication/presentation/pages/auth_wrapper.dart';
import 'package:uplift/authentication/presentation/pages/forgot_password.dart';
import 'package:uplift/authentication/presentation/pages/login_screen.dart';
import 'package:uplift/authentication/presentation/pages/register_screen.dart';
import 'package:uplift/home/presentation/page/edit_profile/edit_profile_screen.dart';
import 'package:uplift/home/presentation/page/home.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/page/notification_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_form_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_request/friend_request_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/qr_code/qr_generator_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/qr_code/qr_reader_screen.dart';

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
                routes: const []),
            GoRoute(
                path: 'forgot-password',
                name: 'forgotPassword',
                pageBuilder: (context, state) =>
                    const MaterialPage(child: ForgrotPasswordScreen())),
            GoRoute(
              name: "register",
              path: 'register',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: RegisterScreen()),
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
                path: 'friend_request',
                name: 'friend_request',
                pageBuilder: (context, state) {
                  return const MaterialPage(child: FriendRequestScreen());
                }),
            GoRoute(
                path: 'edit-profile',
                name: 'edit-profile',
                pageBuilder: (context, state) {
                  final user = state.extra as UserModel;
                  return MaterialPage(child: EditProfileScreen(user: user));
                }),
            GoRoute(
              path: 'notification',
              name: 'notification',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: NotificationScreen()),
            ),
            GoRoute(
                path: 'qr_reader',
                name: 'qr_reader',
                pageBuilder: (context, state) => MaterialPage(
                        child: QRReaderScreen(
                      user: state.extra as User,
                    )),
                routes: [
                  GoRoute(
                    path: 'qr_generator2',
                    name: 'qr_generator2',
                    pageBuilder: (context, state) => MaterialPage(
                        child: QRGeneratorScreen(
                      user: state.extra as User,
                    )),
                  ),
                ]),
            GoRoute(
              path: 'qr_generator',
              name: 'qr_generator',
              pageBuilder: (context, state) => MaterialPage(
                  child: QRGeneratorScreen(
                user: state.extra as User,
              )),
            ),
            GoRoute(
              path: 'post_field',
              name: 'post_field',
              pageBuilder: (context, state) => MaterialPage(
                  child: PostFormScreen(
                user: state.extra as User,
              )),
            )
          ])
    ]);
