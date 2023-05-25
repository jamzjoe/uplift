import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/presentation/explore_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/feed_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

int index = 0;
TabController? _tabController;
PageController _pageController = PageController(initialPage: 0, keepPage: true);

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    hideKeyBoard();
    super.initState();
  }

  void hideKeyBoard() {
    Future.delayed(
        const Duration(seconds: 1), () => FocusScope.of(context).unfocus());
  }

  @override
  void dispose() {
    _tabController!.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state is UserIsIn) {
          BlocProvider.of<GetPrayerRequestBloc>(context)
              .add(GetPostRequestList(state.userJoinedModel.userModel.userId!));
          BlocProvider.of<NotificationBloc>(context).add(
              FetchListOfNotification(state.userJoinedModel.userModel.userId!));
          BlocProvider.of<FriendRequestBloc>(context).add(
              FetchFriendRequestEvent(state.userJoinedModel.userModel.userId!));
          BlocProvider.of<FriendsSuggestionsBlocBloc>(context)
              .add(FetchUsersEvent());
          BlocProvider.of<ApprovedFriendsBloc>(context).add(
              FetchApprovedFriendRequest(
                  state.userJoinedModel.userModel.userId!));
          // ignore: use_build_context_synchronously
          BlocProvider.of<SameIntentionsSuggestionBloc>(context).add(
              FetchSameIntentionEvent(state.userJoinedModel.userModel.userId!));
        } else {
          setState(() {
            index = 0;
          });
        }
      },
      builder: (context, state) {
        if (state is UserIsIn) {
          final UserJoinedModel userJoinedModel = state.userJoinedModel;
          final User user = state.userJoinedModel.user;
          return Scaffold(
            key: _scaffoldKey,
            extendBody: true,
            body: PageView(
              pageSnapping: true,
              allowImplicitScrolling: false,
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
              },
              children: [
                KeepAlivePage(child: FeedScreen(user: userJoinedModel)),
                KeepAlivePage(
                    child: FriendsScreen(
                  currentUser: userJoinedModel.userModel,
                )),
                KeepAlivePage(
                    child: ExploreScreen(
                  user: userJoinedModel.userModel,
                )),
                const KeepAlivePage(child: SettingsScreen())
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
              child: FloatingActionButton(
                  backgroundColor: secondaryColor,
                  splashColor: primaryColor,
                  elevation: 2,
                  shape: const CircleBorder(
                      side: BorderSide(color: whiteColor), eccentricity: .5),
                  child: const Icon(
                    Ionicons.qr_code,
                    color: whiteColor,
                    size: 20,
                  ),
                  onPressed: () {
                    context.pushNamed('qr_reader',
                        extra: userJoinedModel.userModel);
                  }),
            ),
            bottomNavigationBar: TabBarMaterialWidget(
                index: index,
                onChangedTab: onChangedTab,
                controller: _tabController,
                user: userJoinedModel.userModel),
          );
        } else if (state is UserIsOut) {
          return const IntroductionScreen();
        } else if (state is Loading) {
          return Scaffold(
            backgroundColor: whiteColor,
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/uplift-logo.png'),
                    width: 100,
                  ),
                  defaultSpace,
                  SpinKitFadingCircle(
                    color: primaryColor,
                    size: 50,
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Text('Error');
        }
      },
    );
  }

  void signOut() {
    BlocProvider.of<AuthenticationBloc>(context).add(SignOutRequested());
  }

  void onChangedTab(int value) {
    setState(() {
      index = value;
      _tabController!.animateTo(value);
      _pageController.animateToPage(value,
          duration: const Duration(microseconds: 1), curve: Curves.ease);
    });
  }
}
