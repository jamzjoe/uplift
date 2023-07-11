import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/tab_bar/follower_page.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/tab_bar/following_page.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/tab_bar/prayer_intention_page.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/widget/check_friend_status.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendsFeed extends StatefulWidget {
  const FriendsFeed({
    Key? key,
    required this.userModel,
    this.isSelf,
    required this.currentUser,
    required this.scrollController,
  }) : super(key: key);

  final UserModel userModel;
  final UserModel currentUser;
  final ScrollController? scrollController;
  final bool? isSelf;

  @override
  _FriendsFeedState createState() => _FriendsFeedState();
}

class _FriendsFeedState extends State<FriendsFeed>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int index = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final UserModel user = widget.userModel;
    final UserModel currentUser = widget.currentUser;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          context.pushNamed('photo_view', extra: user.photoUrl),
                      child: ProfilePhoto(
                        user: user,
                        radius: 60,
                        size: 90,
                      ),
                    ),
                    const SizedBox(height: 10),
                    HeaderText(text: user.displayName ?? '', color: darkColor),
                    SmallText(text: user.emailAddress ?? '', color: lightColor),
                    defaultSpace,
                    user.bio != null && user.bio!.isNotEmpty
                        ? SmallText(
                            textAlign: TextAlign.center,
                            text: user.bio!.isEmpty ? 'User Bio' : user.bio!,
                            color: darkColor,
                          )
                        : const SizedBox(),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: currentUser.userId != user.userId,
                      child: CheckFriendsStatusWidget(
                        user: user,
                        currentUser: currentUser,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Tabs(user: user, currentUser: currentUser),
          ],
        ),
      ),
    );
  }
}

class Tabs extends StatefulWidget {
  const Tabs({
    super.key,
    required this.user,
    required this.currentUser,
  });

  final UserModel user;
  final UserModel currentUser;

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Prayer Intentions'),
                Tab(text: 'Following'),
                Tab(text: 'Followers'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Content for Tab 1
                  PrayerIntentionPage(
                    user: widget.user,
                    currentUser: widget.currentUser,
                  ),
                  // Content for Tab 2
                  FollowingPage(
                      user: widget.user, currentUser: widget.currentUser),
                  FollowerPage(
                      user: widget.user, currentUser: widget.currentUser),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
