import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_status.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/new_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_tab_bar.dart';
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
  }) : super(key: key);

  final UserModel userModel;
  final UserModel currentUser;
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
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60),
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
                SmallText(
                  text: user.bio?.isEmpty ?? true ? 'User Bio' : user.bio ?? '',
                  color: darkColor,
                ),
                defaultSpace,
                Visibility(
                  visible: user.userId != widget.currentUser.userId,
                  child: FutureBuilder<NewUserFriendshipModel?>(
                    future: checkFriendsStatus(user.userId!),
                    builder: (BuildContext context,
                        AsyncSnapshot<NewUserFriendshipModel?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show a loading indicator while fetching the data
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Show an error message if an error occurred
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final friendshipStatus = snapshot.data;

                        if (friendshipStatus != null) {
                          // User is a friend
                          if (friendshipStatus.status.status == 'pending') {
                            return ElevatedButton.icon(
                              icon: const Icon(
                                CupertinoIcons.clock_solid,
                                color: whiteColor,
                              ),
                              label: const SmallText(
                                text: 'Request Pending',
                                color: whiteColor,
                              ),
                              onPressed: () {
                                unfriend(friendshipStatus
                                    .friendshipID.friendshipId!);
                              },
                            );
                          }
                          return ElevatedButton.icon(
                            label: const SmallText(
                              text: 'UNFOLLOW',
                              color: whiteColor,
                            ),
                            onPressed: () {
                              unfriend(
                                  friendshipStatus.friendshipID.friendshipId!);
                            },
                            icon: const Icon(
                              CupertinoIcons.add_circled_solid,
                              color: whiteColor,
                            ),
                          );
                        } else {
                          // User is not a friend
                          return Column(
                            children: [
                              SmallText(
                                  text: 'You are not friends', color: lighter),
                              ElevatedButton.icon(
                                label: const SmallText(
                                  text: 'FOLLOW',
                                  color: whiteColor,
                                ),
                                onPressed: () {
                                  addFriend(
                                      widget.currentUser.userId!, user.userId);
                                },
                                icon: const Icon(
                                  CupertinoIcons.add_circled_solid,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          );
                        }
                      }
                    },
                  ),
                ),
                defaultSpace,
              ],
            ),
            Flexible(child: FriendsTabBarView(user: user))
          ],
        ),
      ),
    );
  }
}
