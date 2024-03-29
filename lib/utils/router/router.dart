import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/authentication/presentation/pages/auth_wrapper.dart';
import 'package:uplift/authentication/presentation/pages/reset_password.dart';
import 'package:uplift/authentication/presentation/pages/login_screen.dart';
import 'package:uplift/authentication/presentation/pages/register_screen.dart';
import 'package:uplift/authentication/presentation/pages/forgot_password.dart';
import 'package:uplift/home/presentation/page/edit_profile/edit_profile_screen.dart';
import 'package:uplift/home/presentation/page/home.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/page/notification_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_form/post_form_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/reactors_list.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestions_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/your_friends_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/qr_code/qr_generator_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/qr_code/qr_reader_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/account_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/donate_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/privacy_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/report_problem_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/security_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/about_us_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/switch_account.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/terms_and_policies.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';
import 'package:uplift/utils/widgets/photo_view.dart';
import 'package:uplift/utils/widgets/test.dart';

final GoRouter router = GoRouter(
    // redirect: (context, state) {
    //   return "/introduction_screen";
    // },
    initialLocation: "/home",
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
          path: '/introduction_screen',
          name: "introduction_screen",
          pageBuilder: (context, state) => const MaterialPage(
              child: KeepAlivePage(
                  child: LoaderOverlay(
                      closeOnBackButton: true, child: HomeScreen()))),
          routes: [
            GoRoute(
              name: "login",
              path: 'login',
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child: const LoginScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
              ),
            ),
            GoRoute(
                path: 'forgot-password',
                name: 'forgotPassword',
                pageBuilder: (context, state) =>
                    const MaterialPage(child: ForgotPasswordScreen())),
            GoRoute(
                path: 'reset-password',
                name: 'resetPassword',
                pageBuilder: (context, state) => MaterialPage(
                        child: ResetPasswordScreen(
                      currentUser: state.extra as UserModel,
                    ))),
            GoRoute(
              name: "register",
              path: 'register',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: RegisterScreen()),
            ),
            GoRoute(
              name: "auth-wrapper",
              path: 'auth-wrapper',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: AuthWrapper()),
            )
          ]),
      GoRoute(
          name: 'home',
          path: '/home',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child: const LoaderOverlay(
                    closeOnBackButton: true, child: HomeScreen()),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
              ),
          routes: [
            GoRoute(
                path: 'test',
                name: 'test',
                pageBuilder: (context, state) {
                  return MaterialPage(
                      child: Test(
                    payloader: state.extra as String,
                  ));
                }),
            GoRoute(
                path: 'friend_suggest',
                name: 'friend_suggest',
                pageBuilder: (context, state) {
                  return MaterialPage(
                      child: FriendSuggestions(
                    currentUser: state.extra as UserModel,
                  ));
                }),
            GoRoute(
                path: 'photo_view',
                name: 'photo_view',
                pageBuilder: (context, state) {
                  return MaterialPage(
                      child: PhotoViewScreen(
                    url: state.extra as String,
                  ));
                }),
            GoRoute(
                path: 'friends-list',
                name: 'friends-list',
                pageBuilder: (context, state) {
                  return MaterialPage(
                      child: YourFriendsScreen(
                    user: state.extra as UserModel,
                  ));
                }),
            GoRoute(
                path: 'reactors-list',
                name: 'reactors-list',
                pageBuilder: (context, state) {
                  return MaterialPage(
                      child: ReactorsList(
                    userID: state.extra as List<dynamic>,
                    currentUser:
                        state.queryParametersAll['currentUser'] as UserModel,
                  ));
                }),
            GoRoute(
                path: 'update-profile',
                name: 'update-profile',
                pageBuilder: (context, state) => MaterialPage(
                    child: EditProfileScreen(
                        userJoinedModel: state.extra as UserJoinedModel))),
            GoRoute(
              path: 'notification',
              name: 'notification',
              pageBuilder: (context, state) => MaterialPage(
                  child: NotificationScreen(
                currentUser: state.extra as UserModel,
              )),
            ),
            GoRoute(
                path: 'qr_reader',
                name: 'qr_reader',
                pageBuilder: (context, state) => MaterialPage(
                        child: QRReaderScreen(
                      userJoinedModel: state.extra as UserModel,
                    )),
                routes: [
                  GoRoute(
                    path: 'qr_generator',
                    name: 'qr_generator',
                    pageBuilder: (context, state) => MaterialPage(
                        child: QRGeneratorScreen(
                      user: state.extra as UserModel,
                    )),
                  ),
                ]),
            GoRoute(
                path: 'post_field',
                name: 'post_field',
                pageBuilder: (context, state) => MaterialPage(
                        child: PostFormScreen(
                      user: state.extra as UserJoinedModel,
                    ))),
            GoRoute(
              path: 'account',
              name: 'account',
              pageBuilder: (context, state) => MaterialPage(
                  child: AccountScreen(
                currentUser: state.extra as UserModel,
              )),
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
              path: 'about-us',
              name: 'about-us',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: AboutUsScreen()),
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
