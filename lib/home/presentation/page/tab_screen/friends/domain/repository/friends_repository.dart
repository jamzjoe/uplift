import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_status.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
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
    userIDS = userIDS.toSet().toList();

    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('Users')
        .where('user_id', isNotEqualTo: userID)
        .get();

    data = response.docs
        .map((e) => UserModel.fromJson(e.data()))
        .where((user) => !userIDS.contains(user.userId))
        .toList()
        .reversed
        .toList();

    return data;
  }

  Future<List<UserModel>> searchSuggestions(String query) async {
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
    userIDS = userIDS.toSet().toList();

    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('Users')
        .where('user_id', isNotEqualTo: userID)
        .get();

    data = response.docs
        .map((e) => UserModel.fromJson(e.data()))
        .where((user) => !userIDS.contains(user.userId))
        .toList()
        .reversed
        .toList();

    return data
        .where((element) =>
            (element.searchKey != null &&
                element.searchKey!.contains(query.toLowerCase().trim())) ||
            (element.emailAddress != null &&
                element.emailAddress!
                    .toLowerCase()
                    .contains(query.toLowerCase().trim())) ||
            (element.phoneNumber != null &&
                element.phoneNumber!
                    .toLowerCase()
                    .contains(query.toLowerCase().trim())))
        .toList();
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

  // Future<List<FriendShipModel>> getFriendRequest(String currentUserID) async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> fetching = await FirebaseFirestore
  //         .instance
  //         .collection('Friendships')
  //         .where('status', isEqualTo: 'pending')
  //         .where('receiver', isEqualTo: currentUserID)
  //         .get();

  //     List<FriendShipModel> data = fetching.docs
  //         .map((e) => FriendShipModel.fromJson(e.data()))
  //         .toList()
  //         .reversed
  //         .toList();

  //     return data;
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  // Future<List<UserModel>> fetchFriendRequest() async {
  //   List<UserModel> data = [];
  //   final cuurentUserID = await AuthServices.userID();
  //   String status = 'pending';
  //   List<String> pendingReceiverIDs = [];

  //   //get all userID that you had send friend request - you are the sender and also the one that you received
  //   QuerySnapshot<Map<String, dynamic>> fetchingReceiverID =
  //       await FirebaseFirestore.instance
  //           .collection('Friendships')
  //           .where('status', isEqualTo: status)
  //           .where('receiver', isEqualTo: cuurentUserID)
  //           .get();

  //   for (var doc in fetchingReceiverID.docs) {
  //     String senderID = doc.data()['sender'];
  //     pendingReceiverIDs.add(senderID);
  //   }
  //   if (pendingReceiverIDs.isEmpty) {
  //     return [];
  //   } else {
  //     QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
  //         .instance
  //         .collection('Users')
  //         .where('user_id', whereIn: pendingReceiverIDs)
  //         .get();
  //     data = response.docs
  //         .map((e) => UserModel.fromJson(e.data()))
  //         .toList()
  //         .reversed
  //         .toList();
  //   }

  //   return data;
  // }

  Future<List<UserFriendshipModel>> fetchFriendRequest(String userID) async {
    List<UserFriendshipModel> data = [];
    String status = 'pending';

    //get all userID that you had send friend request - you are the sender and also the one that you received
    QuerySnapshot<Map<String, dynamic>> fetchingReceiverID =
        await FirebaseFirestore.instance
            .collection('Friendships')
            .where('status', isEqualTo: status)
            .where('receiver', isEqualTo: userID)
            .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allID =
        fetchingReceiverID.docs;

    List<String> userIDS = [];
    List<String> friendshipID = [];

    for (var doc in allID) {
      String receiver = doc.data()['receiver'];
      String sender = doc.data()['sender'];
      String friendID = doc.data()['friendship_id'];

      if (receiver == userID) {
        userIDS.add(sender);
        friendshipID.add(friendID);
      } else if (sender == userID) {
        userIDS.add(receiver);
        friendshipID.add(friendID);
      }
    }

    if (userIDS.isEmpty) {
      return [];
    } else {
      List<UserModel> users = [];
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('user_id', isNotEqualTo: userID)
          .get();

      for (var doc in response.docs) {
        String docID = doc.data()['user_id'];

        if (userIDS.contains(docID)) {
          users.add(UserModel.fromJson(doc.data()));
        }
      }

      final result = users.toList();

      for (var i = 0; i < result.length; i++) {
        data.add(UserFriendshipModel(
            FriendshipID(friendshipId: friendshipID[i]), result[i]));
      }
    }

    return data;
  }

  Stream<FriendshipStatus?> checkFriendsStatus(String userID) async* {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    List<UserFriendshipModel> friends =
        await fetchApprovedFriendRequest(userID);

    for (var friend in friends) {
      if (friend.userModel.userId == currentUserID) {
        yield FriendshipStatus(friend.friendshipID.friendshipId!, true);
        return;
      }
    }

    yield FriendshipStatus('', false);
  }

  Future<List<UserFriendshipModel>> fetchApprovedFriendRequest(
      String userID) async {
    String status = 'approved';

    QuerySnapshot<Map<String, dynamic>> fetchingReceiverID =
        await FirebaseFirestore.instance
            .collection('Friendships')
            .where('status', isEqualTo: status)
            .where('receiver', isEqualTo: userID)
            .get();
    QuerySnapshot<Map<String, dynamic>> fetchingSenderID =
        await FirebaseFirestore.instance
            .collection('Friendships')
            .where('status', isEqualTo: status)
            .where('sender', isEqualTo: userID)
            .get();

    List<String> userIDS = [];
    List<String> friendshipID = [];

    for (var doc in fetchingReceiverID.docs) {
      String sender = doc.data()['sender'];
      String friendID = doc.data()['friendship_id'];

      userIDS.add(sender);
      friendshipID.add(friendID);
    }

    for (var doc in fetchingSenderID.docs) {
      String receiver = doc.data()['receiver'];
      String friendID = doc.data()['friendship_id'];

      userIDS.add(receiver);
      friendshipID.add(friendID);
    }

    if (userIDS.isEmpty) {
      return [];
    }

    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('Users')
        .where('user_id', whereIn: userIDS)
        .get();

    List<UserModel> users =
        response.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
    List<UserFriendshipModel> data = [];

    for (int i = 0; i < friendshipID.length; i++) {
      String friendID = friendshipID[i];

      UserModel? user = users.firstWhere((u) => u.userId == userIDS[i]);
      data.add(UserFriendshipModel(FriendshipID(friendshipId: friendID), user));
    }

    return data;
  }

  Future<List<UserFriendshipModel>> fetchApprovedFollowingRequest(
      String userID) async {
    List<UserFriendshipModel> data = [];
    String status = 'approved';

    //get all userID that you had send friend request - you are the sender and also the one that you received
    QuerySnapshot<Map<String, dynamic>> fetchingSenderID =
        await FirebaseFirestore.instance
            .collection('Friendships')
            .where('status', isEqualTo: status)
            .where('sender', isEqualTo: userID)
            .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allID =
        fetchingSenderID.docs;

    List<String> userIDS = [];
    List<String> friendshipID = [];

    for (var doc in allID) {
      String receiver = doc.data()['receiver'];
      String sender = doc.data()['sender'];
      String friendID = doc.data()['friendship_id'];

      if (receiver == userID) {
        userIDS.add(sender);
        friendshipID.add(friendID);
      } else if (sender == userID) {
        userIDS.add(receiver);
        friendshipID.add(friendID);
      }
    }

    if (userIDS.isEmpty) {
      return [];
    } else {
      List<UserModel> users = [];
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('user_id', isNotEqualTo: userID)
          .get();

      for (var doc in response.docs) {
        String docID = doc.data()['user_id'];

        if (userIDS.contains(docID)) {
          users.add(UserModel.fromJson(doc.data()));
        }
      }

      final result = users.toList();

      for (var i = 0; i < result.length; i++) {
        data.add(UserFriendshipModel(
            FriendshipID(friendshipId: friendshipID[i]), result[i]));
      }
    }

    return data;
  }

  Future<List<UserFriendshipModel>> fetchApprovedFollowerFriendRequest(
      String userID) async {
    List<UserFriendshipModel> data = [];
    String status = 'approved';

    //get all userID that you had send friend request - you are the sender and also the one that you received
    QuerySnapshot<Map<String, dynamic>> fetchingReceiverID =
        await FirebaseFirestore.instance
            .collection('Friendships')
            .where('status', isEqualTo: status)
            .where('receiver', isEqualTo: userID)
            .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allID =
        fetchingReceiverID.docs;

    List<String> userIDS = [];
    List<String> friendshipID = [];

    for (var doc in allID) {
      String receiver = doc.data()['receiver'];
      String sender = doc.data()['sender'];
      String friendID = doc.data()['friendship_id'];

      if (receiver == userID) {
        userIDS.add(sender);
        friendshipID.add(friendID);
      } else if (sender == userID) {
        userIDS.add(receiver);
        friendshipID.add(friendID);
      }
    }

    if (userIDS.isEmpty) {
      return [];
    } else {
      List<UserModel> users = [];
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('user_id', isNotEqualTo: userID)
          .get();

      for (var doc in response.docs) {
        String docID = doc.data()['user_id'];

        if (userIDS.contains(docID)) {
          users.add(UserModel.fromJson(doc.data()));
        }
      }

      final result = users.toList();

      for (var i = 0; i < result.length; i++) {
        data.add(UserFriendshipModel(
            FriendshipID(friendshipId: friendshipID[i]), result[i]));
      }
    }

    return data;
  }

  Future<List<UserFriendshipModel>> searchApprovedFriendRequest(
      String query) async {
    List<UserFriendshipModel> data = [];
    final userID = await AuthServices.userID();
    String status = 'approved';

    //get all userID that you had send friend request - you are the sender and also the one that you received
    QuerySnapshot<Map<String, dynamic>> fetchingReceiverID =
        await FirebaseFirestore.instance
            .collection('Friendships')
            .where('status', isEqualTo: status)
            .where('receiver', isEqualTo: userID)
            .get();
    QuerySnapshot<Map<String, dynamic>> fetchingSenderID =
        await FirebaseFirestore.instance
            .collection('Friendships')
            .where('status', isEqualTo: status)
            .where('sender', isEqualTo: userID)
            .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allID =
        fetchingSenderID.docs + fetchingReceiverID.docs;

    List<String> userIDS = [];
    List<String> friendshipID = [];

    for (var doc in allID) {
      String receiver = doc.data()['receiver'];
      String sender = doc.data()['sender'];
      String friendID = doc.data()['friendship_id'];

      if (receiver == userID) {
        userIDS.add(sender);
        friendshipID.add(friendID);
      } else if (sender == userID) {
        userIDS.add(receiver);
        friendshipID.add(friendID);
      }
    }

    if (userIDS.isEmpty) {
      return [];
    } else {
      List<UserModel> users = [];
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('user_id', isNotEqualTo: userID)
          .get();

      for (var doc in response.docs) {
        String docID = doc.data()['user_id'];

        if (userIDS.contains(docID)) {
          users.add(UserModel.fromJson(doc.data()));
        }
      }

      final result = users.toList();

      for (var i = 0; i < result.length; i++) {
        data.add(UserFriendshipModel(
            FriendshipID(friendshipId: friendshipID[i]), result[i]));
      }
    }

    return data
        .where((element) =>
            (element.userModel.searchKey != null &&
                element.userModel.searchKey!
                    .contains(query.toLowerCase().trim())) ||
            (element.userModel.emailAddress != null &&
                element.userModel.emailAddress!
                    .toLowerCase()
                    .contains(query.toLowerCase().trim())) ||
            (element.userModel.phoneNumber != null &&
                element.userModel.phoneNumber!
                    .toLowerCase()
                    .contains(query.toLowerCase().trim())) ||
            element.userModel.displayName != null &&
                element.userModel.displayName!
                    .toLowerCase()
                    .contains(query.toLowerCase().trim()))
        .toList();
  }

  // Future<List<UserFriendshipModel>> searchApprovedFriendRequest(
  //     String query) async {
  //   List<UserFriendshipModel> data = [];
  //   final userID = await AuthServices.userID();
  //   String status = 'approved';

  //   //get all userID that you had send friend request - you are the sender and also the one that you received
  //   QuerySnapshot<Map<String, dynamic>> fetchingReceiverID =
  //       await FirebaseFirestore.instance
  //           .collection('Friendships')
  //           .where('status', isEqualTo: status)
  //           .where('receiver', isEqualTo: userID)
  //           .get();
  //   QuerySnapshot<Map<String, dynamic>> fetchingSenderID =
  //       await FirebaseFirestore.instance
  //           .collection('Friendships')
  //           .where('status', isEqualTo: status)
  //           .where('sender', isEqualTo: userID)
  //           .get();

  //   List<QueryDocumentSnapshot<Map<String, dynamic>>> allID =
  //       fetchingSenderID.docs + fetchingReceiverID.docs;

  //   List<String> userIDS =
  //       allID.map((e) => e.data()['receiver'].toString()).toList();
  //   userIDS.addAll(allID.map((e) => e.data()['sender'].toString()).toList());
  //   userIDS.toSet().toList();

  //   List<String> friendshipID =
  //       allID.map((e) => e.data()['friendship_id'].toString()).toList();
  //   friendshipID.toSet().toList();
  //   if (allID.isEmpty) {
  //     return [];
  //   } else {
  //     QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
  //         .instance
  //         .collection('Users')
  //         .where('user_id', isNotEqualTo: userID)
  //         .where('user_id', whereIn: userIDS)
  //         .get();
  //     final result = response.docs
  //         .map((e) => UserModel.fromJson(e.data()))
  //         .toList()
  //         .reversed
  //         .toList();

  //     for (var i = 0; i < result.length; i++) {
  //       data.add(UserFriendshipModel(
  //           FriendshipID(friendshipId: friendshipID[i]), result[i]));
  //     }
  //   }

  //   return data
  //       .where((element) =>
  //           element.userModel.searchKey!.contains(query.toLowerCase().trim()))
  //       .toList();
  // }

  // Future<List<UserModel>> searchApprovedFriendRequest(String query) async {
  //   List<UserModel> data = [];
  //   final userID = await AuthServices.userID();
  //   List<String> status = ['approved'];

  //   //get all userID that you had send friend request - you are the sender and also the one that you received
  //   QuerySnapshot<Map<String, dynamic>> fetchingReceiverID =
  //       await FirebaseFirestore.instance
  //           .collection('Friendships')
  //           .where('status', whereIn: status)
  //           .where('receiver', isEqualTo: userID)
  //           .get();
  //   QuerySnapshot<Map<String, dynamic>> fetchingSenderID =
  //       await FirebaseFirestore.instance
  //           .collection('Friendships')
  //           .where('status', whereIn: status)
  //           .where('sender', isEqualTo: userID)
  //           .get();

  //   List<QueryDocumentSnapshot<Map<String, dynamic>>> allID =
  //       fetchingSenderID.docs + fetchingReceiverID.docs;

  //   List<String> userIDS =
  //       allID.map((e) => e.data()['receiver'].toString()).toList();
  //   userIDS.addAll(allID.map((e) => e.data()['sender'].toString()).toList());
  //   userIDS.toSet().toList();
  //   if (userIDS.isEmpty) {
  //     QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
  //         .instance
  //         .collection('Users')
  //         .where('user_id', isNotEqualTo: await AuthServices.userID())
  //         .get();
  //     data = response.docs
  //         .map((e) => UserModel.fromJson(e.data()))
  //         .toList()
  //         .reversed
  //         .toList();
  //   } else {
  //     QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
  //         .instance
  //         .collection('Users')
  //         .where('user_id', isNotEqualTo: userID)
  //         .where('user_id', whereIn: userIDS)
  //         .get();
  //     data = response.docs
  //         .map((e) => UserModel.fromJson(e.data()))
  //         .toList()
  //         .reversed
  //         .toList();
  //   }

  //   return data
  //       .where((element) => element.searchKey!.contains(query.toLowerCase()))
  //       .toList();
  // }

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

  Future ignore(String friendShipID) async {
    FirebaseFirestore.instance
        .collection('Friendships')
        .doc(friendShipID)
        .update({"status": "rejected"})
        .then((value) => log("Unfriend Success"))
        .catchError((error) => log("Failed to unfriend: $error"));
  }

  String generateFriendshipId(String userId1, String userId2) {
    return '$userId1$userId2';
  }

  Future<bool> addFriend(String senderID, receiverID) async {
    try {
      String friendshipId = generateFriendshipId(
          senderID, receiverID); // Generate a unique friendship ID
      FriendShipModel input = FriendShipModel(
          sender: senderID,
          receiver: receiverID,
          status: 'pending',
          timestamp: Timestamp.now(),
          friendshipID: friendshipId);
      FirebaseFirestore.instance
          .collection('Friendships')
          .doc(friendshipId)
          .set(input.toJson())
          .then((value) => log("Request send"))
          .catchError((error) => log("Failed to add friend: $error"));
      return true;
    } catch (e) {
      return false;
    }
  }
}
