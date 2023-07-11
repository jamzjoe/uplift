import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/home/presentation/page/tabbar_material_widget.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';

import 'tab_screen/explore/presentation/explore_screen.dart';
import 'tab_screen/feed/feed_screen.dart';
import 'tab_screen/friends/presentation/pages/friends_screen.dart';
import 'tab_screen/settings/settings_screen.dart';

class UpliftMainScreen extends StatefulWidget {
  const UpliftMainScreen({super.key, required this.userJoinedModel});
  final UserJoinedModel userJoinedModel;
  @override
  State<UpliftMainScreen> createState() => _UpliftMainScreenState();
}

int index = 0;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _UpliftMainScreenState extends State<UpliftMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      body: IndexedStack(
        index: index,
        children: [
          KeepAlivePage(
            child: FeedScreen(user: widget.userJoinedModel),
          ),
          KeepAlivePage(
            child: FriendsScreen(currentUser: widget.userJoinedModel.userModel),
          ),
          KeepAlivePage(
            child: ExploreScreen(user: widget.userJoinedModel.userModel),
          ),
          const KeepAlivePage(child: SettingsScreen())
        ],
      ),
      bottomNavigationBar: TabBarMaterialWidget(
        index: index,
        onChangedTab: onChangedTab,
        user: widget.userJoinedModel.userModel,
      ),
    );
  }

  void onChangedTab(int value) {
    setState(() {
      index = value;
    });
  }
}
