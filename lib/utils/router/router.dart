import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/authentication/presentation/pages/auth_wrapper.dart';
import 'package:uplift/authentication/presentation/pages/forgot_password.dart';
import 'package:uplift/authentication/presentation/pages/login_screen.dart';
import 'package:uplift/authentication/presentation/pages/register_screen.dart';
import 'package:uplift/home/presentation/page/edit_profile/edit_profile_screen.dart';
import 'package:uplift/home/presentation/page/home.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/user_notif_model.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/page/notification_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_form_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestions_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/your_friends_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/qr_code/qr_generator_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/qr_code/qr_reader_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/account_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/donate_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/privacy_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/report_problem_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/security_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/support.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/switch_account.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/terms_and_policies.dart';

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
                  userJoinedModel: state.extra as UserJoinedModel,
                ),
              ),
          routes: [
            GoRoute(
                path: 'friend_suggest',
                name: 'friend_suggest',
                pageBuilder: (context, state) {
                  return MaterialPage(
                      child: FriendSuggestions(
                    currentUser: state.extra as User,
                  ));
                }),
            GoRoute(
                path: 'friends-list',
                name: 'friends-list',
                pageBuilder: (context, state) {
                  return MaterialPage(
                      child: YourFriendsScreen(
                    user: state.extra as User,
                  ));
                }),
            GoRoute(
                path: 'edit-profile',
                name: 'edit-profile',
                pageBuilder: (context, state) => MaterialPage(
                    child: EditProfileScreen(user: state.extra as UserModel))),
            GoRoute(
              path: 'notification',
              name: 'notification',
              pageBuilder: (context, state) => MaterialPage(
                  child: NotificationScreen(
                notifications: state.extra as List<UserNotifModel>,
              )),
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
            ),
            GoRoute(
              path: 'account',
              name: 'account',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: AccountScreen()),
            ),
            GoRoute(
              path: 'privacy',
              name: 'privacy',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: PrivacyScreen()),
            ),
            GoRoute(
              path: 'security',
              name: 'security',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: SecurityScreen()),
            ),
            GoRoute(
              path: 'donate',
              name: 'donate',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: DonateScreen()),
            ),
            GoRoute(
              path: 'report-problem',
              name: 'report-problem',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: ReportAProblemScreen()),
            ),
            GoRoute(
              path: 'support',
              name: 'support',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: SupportScreen()),
            ),
            GoRoute(
              path: 'term-policies',
              name: 'term-policies',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: TermAndPoliciesScreen()),
            ),
            GoRoute(
              path: 'switch-account',
              name: 'switch-account',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: SwitchAccountScreen()),
            ),
          ])
    ]);
