import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';

class FriendsRepository {
  Future<List<UserModel>> fetchUsers() async {
    QuerySnapshot<Map<String, dynamic>> senderIDS = await FirebaseFirestore
        .instance
        .collection('Friendships')
        .where('sender', isEqualTo: '7FUrYc5jolT2EKUvMhDHWjrjSs43')
        .get();

    final List<String> senderID =
        senderIDS.docs.map((e) => e.data()['receiver'].toString()).toList();
    log(senderID.toString());

    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('Users')
        .where('user_id', whereNotIn: senderID)
        .get();
    List<UserModel> data = response.docs
        .map((e) => UserModel.fromJson(e.data()))
        .toList()
        .reversed
        .toList();
    return data;
  }

  Future<List<FriendShipModel>> getFriendRequest(String currentUserID) async {
    try {
      QuerySnapshot<Map<String, dynamic>> fetching = await FirebaseFirestore
          .instance
          .collection('Friendships')
          .where('status', isEqualTo: 'pending')
          .where('receiver', isEqualTo: currentUserID)
          .limit(5)
          .get();

      log(fetching.docs.map((e) => e.data().toString()).toString());

      List<FriendShipModel> data = fetching.docs
          .map((e) => FriendShipModel.fromJson(e.data()))
          .toList()
          .reversed
          .toList();

      return data;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future addFriendshipRequest(FriendShipModel friendShipModel) async {
    String friendshipId = generateFriendshipId(friendShipModel.sender!,
        friendShipModel.receiver!); // Generate a unique friendship ID
    FriendShipModel input = FriendShipModel(
        sender: friendShipModel.sender!,
        receiver: friendShipModel.receiver!,
        status: 'pending',
        timestamp: Timestamp.now());
    FirebaseFirestore.instance
        .collection('Friendships')
        .doc(friendshipId)
        .set(input.toJson())
        .then((value) => print("Request send"))
        .catchError((error) => print("Failed to add friend: $error"));
  }

  String generateFriendshipId(String userId1, String userId2) {
    return '$userId1$userId2';
  }
}
