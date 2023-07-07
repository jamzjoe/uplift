import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_status.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/new_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/tab_bar/follower_page.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/tab_bar/following_page.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/tab_bar/prayer_intention_page.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/widget/check_friend_status.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../data/model/friendship_model.dart';

class FriendsFeed extends StatefulWidget {
  const FriendsFeed({
    Key? key,
    required this.userModel,
    this.isSelf,
    this.friendshipID,
    required this.currentUser,
    required this.scrollController,
  }) : super(key: key);

  final UserModel userModel;
  final UserModel currentUser;
  final ScrollController scrollController;
  final bool? isSelf;
  final String? friendshipID;

  @override
  _FriendsFeedState createState() => _FriendsFeedState();
}

class _FriendsFeedState extends State<FriendsFeed>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  FriendshipStatus? friendshipStatus;

  Future<NewUserFriendshipModel?> checkFriendsStatus(String userID) async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    List<NewUserFriendshipModel> friends =
        await FriendsRepository().fetchAllFriendRequest(userID);

    for (var friend in friends) {
      if (friend.userModel.userId == currentUserID) {
        return friend;
      }
    }

    return null;
  }

  Future<void> unfriend(String friendshipID) async {
    try {
      await FirebaseFirestore.instance
          .collection('Friendships')
          .doc(friendshipID)
          .update({"status": "rejected"});
      log("Unfriend Success");

      // Trigger a state change to rebuild the UI
      setState(() {
        friendshipStatus = FriendshipStatus('', false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: SmallText(text: 'Unfollow success', color: whiteColor),
        ));
      });
    } catch (error) {
      log("Failed to unfriend: $error");
    }
  }

  Future<bool> addFriend(String senderID, receiverID) async {
    try {
      String friendshipId = FriendsRepository.generateFriendshipId(
          senderID, receiverID); // Generate a unique friendship ID
      FriendShipModel input = FriendShipModel(
        sender: senderID,
        receiver: receiverID,
        status: 'pending',
        timestamp: Timestamp.now(),
        friendshipID: friendshipId,
      );
      FirebaseFirestore.instance
          .collection('Friendships')
          .doc(friendshipId)
          .set(input.toJson())
          .then((value) => log("Request send"))
          .catchError((error) => log("Failed to add friend: $error"));
      setState(() {
        friendshipStatus = FriendshipStatus(friendshipId, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: SmallText(
            text: 'Request sent, please wait for the approval.',
            color: whiteColor,
          ),
        ));
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  int index = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final UserModel user = widget.userModel;
    final UserModel currentUser = widget.currentUser;

    return Scaffold(
      body: CustomScrollView(
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
