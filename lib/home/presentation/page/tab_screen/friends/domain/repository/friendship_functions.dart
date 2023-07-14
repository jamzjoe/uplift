import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/payload_model.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friendship.dart';

import '../../data/model/friendship_model.dart';
import '../../data/model/new_friendship_model.dart';

class FriendshipRequest {
  Future addFriendshipRequest(FriendShipModel friendShipModel) async {
    String friendshipId = generateFriendshipId(friendShipModel.sender!,
        friendShipModel.receiver!); // Generate a unique friendship ID
    FriendShipModel input = FriendShipModel(
        sender: friendShipModel.sender!,
        receiver: friendShipModel.receiver!,
        status: 'pending',
        timestamp: Timestamp.now(),
        friendshipID: friendshipId);
    FirebaseFirestore.instance
        .collection('Friendships')
        .doc(friendshipId)
        .set(input.toJson())
        .then((value) => log("Request send"))
        .catchError((error) => log("Failed to add friend: $error"));
  }

  Future unfriend(String friendShipID) async {
    FirebaseFirestore.instance
        .collection('Friendships')
        .doc(friendShipID)
        .update({"status": "rejected"})
        .then((value) => log("Unfriend Success"))
        .catchError((error) => log("Failed to unfriend: $error"));
  }

  Future<void> ignore(String friendShipID) async {
    await FirebaseFirestore.instance
        .collection('Friendships')
        .doc(friendShipID)
        .update({"status": "rejected"})
        .then((value) => log("Unfriend Success"))
        .catchError((error) => log("Failed to unfriend: $error"));
  }

  static String generateFriendshipId(String userId1, String userId2) {
    return '$userId1$userId2';
  }

  Future<bool> addFriend(
      String senderID, receiverID, String token, String name) async {
    try {
      String friendshipId = generateFriendshipId(
          senderID, receiverID); // Generate a unique friendship ID
      FriendShipModel input = FriendShipModel(
          sender: senderID,
          receiver: receiverID,
          status: 'pending',
          timestamp: Timestamp.now(),
          friendshipID: friendshipId);
      final data = {
        "type": notificationType.add_friend.name,
        "current_user": senderID
      };
      log(friendshipId);
      FirebaseFirestore.instance
          .collection('Friendships')
          .doc(friendshipId)
          .set(input.toJson())
          .then((value) async {
        log("Request send");

        NotificationRepository.addNotification(
            receiverID, 'Friend Request', 'sent you a friend request.',
            type: 'request');
      }).catchError((error) => log("Failed to add friend: $error"));
      NotificationRepository.sendPushMessage(
          token,
          '$name sent you a friend request.',
          'Friend Request',
          notificationType.add_friend.name,
          jsonEncode(data).toString());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Accept a friendship request by updating the friendship document status to accepted
  Future<void> acceptFriendshipRequest(String senderID, String receiverID,
      UserModel currentUser, UserModel userModel, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('Friendships')
        .doc('$senderID$receiverID')
        .update({
      'status': 'approved',
    });

    final data = {
      "type": notificationType.friend_request.name,
      "current_user": currentUser.userId
    };

    await NotificationRepository.sendPushMessage(
      userModel.deviceToken!,
      '${currentUser.displayName} accepted your friend request.',
      'Uplift Notification',
      'friend-request',
      jsonEncode(data).toString(),
    );

    await NotificationRepository.addNotification(
      userModel.userId!,
      'Uplift Notification',
      ' accepted your friend request.',
      type: 'accept',
    );
  }

  Future<UserFriendshipModel?> checkFriendsStatus(String friendsID) async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    List<UserFriendshipModel> friends =
        await FriendShip.fetchAllFriendship(friendsID);

    for (var friend in friends) {
      if (friend.userModel.userId == currentUserID) {
        return friend;
      }
    }
    return null;
  }

  Future<Status?> checkStatus(String friendsID) async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Friendships')
        .where('friendship_id', whereIn: [
      '$currentUserID$friendsID',
      '$friendsID$currentUserID'
    ]).get();

    log(snapshot.docs.toString());

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          snapshot.docs.first;
      Map<String, dynamic>? data = documentSnapshot.data();
      log(data.toString());

      // Assuming 'Status' is the correct type, you can return it here
      return Status.fromJson(data!);
    }

    // Return null or handle the case when no document is found
    return null;
  }

  
}
