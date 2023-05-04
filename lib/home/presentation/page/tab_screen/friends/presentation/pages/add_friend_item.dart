import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class AddFriendItem extends StatelessWidget {
  const AddFriendItem({
    super.key,
    required this.user,
    required this.currentUser,
  });
  final UserModel user;
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          user.photoUrl == null
              ? const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/default1.jpg'),
                )
              : CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(user.photoUrl!),
                ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderText(
                        text: user.displayName ?? 'Anonymous User',
                        color: secondaryColor,
                        size: 16),
                    const SmallText(text: '1w ', color: lightColor)
                  ],
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () async {
                    try {
                      final FriendShipModel friendShipModel = FriendShipModel(
                          sender: currentUser.uid,
                          receiver: user.userId,
                          status: 'pending',
                          timestamp: Timestamp.now());
                      log(friendShipModel.toJson().toString());
                      await FriendsRepository()
                          .addFriendshipRequest(friendShipModel);
                      log(user.deviceToken!);
                      await NotificationRepository.sendPushMessage(
                          user.deviceToken!,
                          '${currentUser.displayName} sent you a friend a request.',
                          "Uplift Notification");

                      await NotificationRepository.addNotification(
                        user.userId!,
                        'Friend request',
                        '${currentUser.displayName} sent you a friend a request.',
                      );
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        color: linkColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                      child:
                          DefaultText(text: 'Sent request', color: whiteColor),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
