import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/home/presentation/page/home.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/introduction/presentation/introduction_screen.dart';

import '../../../home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state is UserIsIn) {
          BlocProvider.of<GetPrayerRequestBloc>(context)
              .add(const GetPostRequestList());
          BlocProvider.of<NotificationBloc>(context)
              .add(FetchListOfNotification(state.user.uid, false));
          BlocProvider.of<FriendRequestBloc>(context)
              .add(FetchFriendRequestEvent(state.user.uid));
        }
      },
      builder: (context, state) {
        if (state is UserIsIn) {
          return HomeScreen(user: state.user);
        } else if (state is UserIsOut) {
          return const IntroductionScreen();
        } else {
          return const IntroductionScreen();
        }
      },
    );
  }
}
