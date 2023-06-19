import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/presentation/bloc/explore_get_prayer_request/explore_get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/presentation/explore_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/feed_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/same_intention_bloc/same_intentions_suggestion_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_screen.dart';
import 'package:uplift/home/presentation/page/tabbar_material_widget.dart';
import 'package:uplift/authentication/presentation/pages/introduction/presentation/introduction_screen.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  int index = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure the state is kept alive
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state is UserIsIn) {
          FlutterNativeSplash.remove();

          BlocProvider.of<NotificationBloc>(context).add(
              FetchListOfNotification(state.userJoinedModel.userModel.userId!));
          BlocProvider.of<FriendRequestBloc>(context).add(
              FetchFriendRequestEvent(state.userJoinedModel.userModel.userId!));
          BlocProvider.of<FriendsSuggestionsBlocBloc>(context)
              .add(FetchUsersEvent(state.userJoinedModel.userModel.userId!));
          BlocProvider.of<ApprovedFriendsBloc>(context).add(
              FetchApprovedFriendRequest(
                  state.userJoinedModel.userModel.userId!));
          BlocProvider.of<SameIntentionsSuggestionBloc>(context).add(
              FetchSameIntentionEvent(state.userJoinedModel.userModel.userId!));
          BlocProvider.of<ExploreBloc>(context).add(GetExplorePrayerRequestList(
              state.userJoinedModel.userModel.userId!));
        } else if (state is UserIsOut) {
          // Handle user logged out state
          // You can navigate to a login screen or show a different UI
          setState(() {
            index = 0;
          });
        }
      },
      builder: (context, state) {
        if (state is UserIsIn) {
          final UserJoinedModel userJoinedModel = state.userJoinedModel;
          return Scaffold(
            key: _scaffoldKey,
            extendBody: true,
            body: IndexedStack(
              index: index,
              children: [
                KeepAlivePage(
                  child: FeedScreen(user: userJoinedModel),
                ),
                KeepAlivePage(
                  child: FriendsScreen(currentUser: userJoinedModel.userModel),
                ),
                KeepAlivePage(
                  child: ExploreScreen(user: userJoinedModel.userModel),
                ),
                const KeepAlivePage(child: SettingsScreen())
              ],
            ),
            bottomNavigationBar: TabBarMaterialWidget(
              index: index,
              onChangedTab: onChangedTab,
              user: userJoinedModel.userModel,
            ),
          );
        } else if (state is UserIsOut) {
          return const IntroductionScreen();
        } else if (state is Loading) {
          return const Scaffold(
            backgroundColor: primaryColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SpinKitRipple(
                      color: whiteColor,
                      size: 200,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Center(
                        child: Image(
                          image: AssetImage('assets/uplift-logo-white.png'),
                          width: 80,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Text('Error');
        }
      },
    );
  }

  void onChangedTab(int value) {
    setState(() {
      index = value;
    });
  }
}
