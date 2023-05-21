import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/just_now.dart';
import 'package:uplift/utils/widgets/safe_photo_viewer.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class AddFriendItem extends StatelessWidget {
  const AddFriendItem({
    super.key,
    required this.user,
    required this.currentUser,
    this.controller,
  });
  final UserModel user;
  final UserModel currentUser;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          user.photoUrl == null
              ? const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/default.png'),
                )
              : SafePhotoViewer(user: user),
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
                              color: secondaryColor,
                              size: 16),
                          SmallText(
                              text:
                                  'Active ${DateFeature().formatDateTime(user.createdAt!.toDate())}',
                              color: secondaryColor),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final FriendShipModel friendShipModel = FriendShipModel(
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
    );
  }
}
