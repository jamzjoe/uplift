import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';
import 'package:uplift/utils/services/auth_services.dart';

class FriendsRepository {
  Future<List<UserModel>> fetchUsersSuggestions() async {
    List<UserModel> data = [];
    final userID = await AuthServices.userID();
    List<String> status = ['approved', 'pending'];

    //get all userID that you had send friend request - you are the sender and also the one that you received
    QuerySnapshot<Map<String, dynamic>> fetchingReceiverID =
        await FirebaseFirestore.instance
            .collection('Friendships')
            .where('status', whereIn: status)
            .where('receiver', isEqualTo: userID)
            .get();
    QuerySnapshot<Map<String, dynamic>> fetchingSenderID =
        await FirebaseFirestore.instance
            .collection('Friendships')
            .where('status', whereIn: status)
            .where('sender', isEqualTo: userID)
            .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allID =
        fetchingSenderID.docs + fetchingReceiverID.docs;

    List<String> userIDS =
        allID.map((e) => e.data()['receiver'].toString()).toList();
    userIDS.addAll(allID.map((e) => e.data()['sender'].toString()).toList());

    log(userIDS.toString());

    if (userIDS.isEmpty) {
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('user_id', isNotEqualTo: await AuthServices.userID())
          .get();
      data = response.docs
          .map((e) => UserModel.fromJson(e.data()))
          .toList()
          .reversed
          .toList();
    } else {
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('user_id', whereNotIn: userIDS)
          .get();
      data = response.docs
          .map((e) => UserModel.fromJson(e.data()))
          .toList()
          .reversed
          .toList();
    }

    return data;
  }

  // Accept a friendship request by updating the friendship document status to accepted
  Future acceptFriendshipRequest(String senderID, String receiverID) async {
    FirebaseFirestore.instance
        .collection('Friendships')
        .doc('$senderID$receiverID')
        .update({
      'status': 'approved',
    });
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

  Future<List<FriendShipModel>> getApprovedFriendRequest() async {
    final userID = await AuthServices.userID();
    List<FriendShipModel> data;
    try {
      QuerySnapshot<Map<String, dynamic>> fetchingReceiverID =
          await FirebaseFirestore.instance
              .collection('Friendships')
              .where('status', isEqualTo: 'approved')
              .where('receiver', isEqualTo: userID)
              .get();
      QuerySnapshot<Map<String, dynamic>> fetchingSenderID =
          await FirebaseFirestore.instance
              .collection('Friendships')
              .where('status', isEqualTo: 'approved')
              .where('sender', isEqualTo: userID)
              .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> allID =
          fetchingSenderID.docs + fetchingReceiverID.docs;
      log('All ID ${allID.map((e) => e.data().toString())}');
      data = allID
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
