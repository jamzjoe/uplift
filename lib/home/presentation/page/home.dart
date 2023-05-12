import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/events/event_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/feed_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_screen.dart';
import 'package:uplift/home/presentation/page/tabbar_material_widget.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.userJoinedModel});
  final UserJoinedModel userJoinedModel;

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
  Widget build(BuildContext context) {
    final User user = widget.userJoinedModel.user;
    final UserJoinedModel userJoinedModel = widget.userJoinedModel;
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is UserIsOut) {
              setState(() {
                index = 0;
              });
            }
          },
          child: PageView(
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
                currentUser: user,
              )),
              const KeepAlivePage(child: EventScreen()),
              KeepAlivePage(
                  child: SettingsScreen(
                userJoinedModel: widget.userJoinedModel,
              ))
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton(
            backgroundColor: primaryColor,
            splashColor: primaryColor,
            elevation: 2,
            shape: const CircleBorder(
                side: BorderSide(color: whiteColor), eccentricity: .5),
            child: const Icon(
              Ionicons.qr_code,
              color: whiteColor,
            ),
            onPressed: () {
              context.pushNamed('qr_generator2',
                  extra: userJoinedModel.userModel);
            }),
      ),
      bottomNavigationBar: TabBarMaterialWidget(
          index: index, onChangedTab: onChangedTab, controller: _tabController),
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
