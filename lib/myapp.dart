import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/domain/repository/auth_repository.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/authentication/presentation/pages/bloc/switch_screen_cubit.dart';
import 'package:uplift/home/presentation/page/edit_profile/update_profile/update_profile_bloc.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/presentation/bloc/explore_get_prayer_request/explore_get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/loading_cubit/loading_cubit.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/post_prayer_request/post_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/same_intention_bloc/same_intentions_suggestion_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/search_friends/search_friend_bloc.dart';

import 'constant/constant.dart';
import 'utils/router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(AuthRepository()),
        ),
        BlocProvider(create: (context) => UpdateProfileBloc()),
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
            create: (context) => SameIntentionsSuggestionBloc()),
        BlocProvider(create: (context) => FetchingLoadingCubit()),
        BlocProvider(create: (context) => SearchFriendBloc())
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
