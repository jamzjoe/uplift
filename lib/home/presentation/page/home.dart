import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/events/event_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/feed_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/friends_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_screen.dart';
import 'package:uplift/home/presentation/page/tabbar_material_widget.dart';

import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

int index = 0;
TabController? _tabController;

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
    final User user = widget.user;
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          log(state.toString());
          if (state is UserIsOut) {
            setState(() {
              index = 0;
            });
          }
        },
        child: DefaultTabController(
          initialIndex: 1,
          length: 4,
          child: Column(
            children: [
              Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                    FeedScreen(user: user),
                    const FriendsScreen(),
                    const EventScreen(),
                    SettingsScreen(user: user)
                  ]))
              // Expanded(
              //     child: ListView.builder(
              //   itemBuilder: (context, index) => const PostItem(),
              // ))
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton(
            splashColor: primaryColor,
            elevation: 2,
            shape: const CircleBorder(
                side: BorderSide(color: primaryColor), eccentricity: .5),
            child: const Icon(
              Ionicons.qr_code,
              color: primaryColor,
            ),
            onPressed: () {
              context.pushNamed('qr_reader', extra: user);
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
    });
  }
}
