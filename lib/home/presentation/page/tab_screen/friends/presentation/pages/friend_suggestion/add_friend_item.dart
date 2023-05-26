import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class AddFriendItem extends StatelessWidget {
  const AddFriendItem({
    super.key,
    required this.user,
    required this.currentUser,
    this.controller,
    required this.screenContext,
  });
  final UserModel user;
  final UserModel currentUser;
  final TextEditingController? controller;
  final BuildContext screenContext;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CustomDialog().showProfile(context, currentUser, user),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfilePhoto(
              user: user,
              radius: 15,
            ),
            const SizedBox(width: 15),
            Flexible(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderText(
                                text: user.displayName ?? 'Anonymous User',
                                color: darkColor,
                                size: 16),
                            FutureBuilder<List<UserFriendshipModel>>(
                              future: FriendsRepository()
                                  .fetchMutualFriendsWithFriend(
                                currentUser.userId!,
                                user.userId!,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  screenContext.loaderOverlay.hide();
                                  final List<UserFriendshipModel>
                                      mutualFriends = snapshot.data!;
                                  final int friendCount = mutualFriends.length;
                                  if (friendCount == 0) {
                                    return const SmallText(
                                        text: 'No mutual friend',
                                        color: darkColor);
                                  }
                                  if (friendCount <= 2) {
                                    // Display photos of all mutual friends
                                    return Row(
                                      children: [
                                        ...mutualFriends.map(
                                          (friend) => ProfilePhoto(
                                            user: friend.userModel,
                                            size: 15,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    // Display first two photos and remaining count as text
                                    final List<UserFriendshipModel>
                                        firstTwoFriends =
                                        mutualFriends.take(2).toList();
                                    final int remainingCount = friendCount - 2;
                                    final String friendsText =
                                        remainingCount == 1
                                            ? 'mutual friend'
                                            : 'mutual friends';

                                    return Row(
                                      children: [
                                        ...firstTwoFriends.map(
                                          (friend) => ProfilePhoto(
                                              user: friend.userModel,
                                              size: 15,
                                              radius: 60),
                                        ),
                                        SmallText(
                                            text:
                                                ' + $remainingCount $friendsText',
                                            color: darkColor)
                                      ],
                                    );
                                  }
                                }

                                return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade100,
                                    highlightColor: whiteColor,
                                    child: const SizedBox());
                              },
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final FriendShipModel friendShipModel =
                              FriendShipModel(
                            sender: currentUser.userId,
                            receiver: user.userId,
                            status: 'pending',
                            timestamp: Timestamp.now(),
                          );
                          try {
                            await FriendsRepository()
                                .addFriendshipRequest(friendShipModel);
                            await NotificationRepository.sendPushMessage(
                                user.deviceToken!,
                                '${currentUser.displayName} sent you a friend a request.',
                                "Uplift Notification",
                                'add-friend');

                            await NotificationRepository.addNotification(
                              user.userId!,
                              'Friend request',
                              'sent you a friend a request.',
                            );
                            controller!.clear();
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        child: Icon(CupertinoIcons.add_circled_solid,
                            color: secondaryColor.withOpacity(0.4), size: 30),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
