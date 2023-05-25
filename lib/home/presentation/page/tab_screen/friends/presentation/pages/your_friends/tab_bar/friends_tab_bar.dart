import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/tab_bar/follower_page.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/tab_bar/following_page.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/tab_bar/prayer_intention_page.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';

class FriendsTabBarView extends StatefulWidget {
  const FriendsTabBarView(
      {super.key, required this.user, this.isSelf, required this.currentUser});
  final UserModel user;
  final UserModel currentUser;
  final bool? isSelf;

  @override
  State<FriendsTabBarView> createState() => _FriendsTabBarViewState();
}

class _FriendsTabBarViewState extends State<FriendsTabBarView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Builder(builder: (context) {
      return Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                tabs: const [
                  Tab(
                    text: 'Prayer Intentions',
                  ),
                  Tab(
                    text: 'Followers',
                  ),
                  Tab(
                    text: 'Following',
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents scrolling between tabs
                  children: [
                    KeepAlivePage(
                        child: PrayerIntentionPage(user: user, widget: widget)),
                    FollowerPage(user: user, widget: widget),
                    FollowingPage(user: user, widget: widget),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
