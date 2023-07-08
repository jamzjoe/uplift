import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/payload_model.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/new_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_approved_mutual.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_mutual_friends_model.dart';
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
  Future acceptFriendshipRequest(String senderID, String receiverID,
      UserModel currentUser, UserModel userModel) async {
    FirebaseFirestore.instance
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
        jsonEncode(data).toString());
    await NotificationRepository.addNotification(userModel.userId!,
        'Uplift Notification', ' accepted your friend request.',
        type: 'accept');
  }

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

  Future<List<List<UserFriendshipModel>>> fetchFriendsOfFriends(
      String currentUserID) async {
    List<UserFriendshipModel> myFriends =
        await fetchApprovedFriendRequest(currentUserID);

    List<List<UserFriendshipModel>> friendsOfFriends = [];

    for (var friend in myFriends) {
      List<UserFriendshipModel> theirFriends =
          await fetchApprovedFriendRequest(friend.userModel.userId!);
      List<UserFriendshipModel> mutualFriends = [];

      for (var theirFriend in theirFriends) {
        if (theirFriend.userModel.userId == friend.userModel.userId) {
          mutualFriends.add(theirFriend);
        }
      }

      friendsOfFriends.add(mutualFriends);
    }

    return friendsOfFriends;
  }

  Future<List<UserFriendshipModel>> fetchMutualFriendsWithFriend(
      String currentUserID, String friendID) async {
    List<UserFriendshipModel> myFriends =
        await fetchApprovedFriendRequest(currentUserID);

    List<UserFriendshipModel> friendFriends =
        await fetchApprovedFriendRequest(friendID);

    List<UserFriendshipModel> mutualFriends = [];

    for (var myFriend in myFriends) {
      if (friendFriends.any(
          (friend) => friend.userModel.userId == myFriend.userModel.userId)) {
        mutualFriends.add(myFriend);
      }
    }

    return mutualFriends;
  }

  Future<List<UserMutualFriendsModel>> fetchMyFriendFriends(
      String currentUserID) async {
    List<UserFriendshipModel> myFriends =
        await fetchApprovedFriendRequest(currentUserID);

    final List<UserModel> myFriendsFriends = [];
    final Set<String> userIds = {}; // To store unique user IDs

    // Get the user IDs of your own friends
    final Set<String> myFriendUserIds =
        myFriends.map((friend) => friend.userModel.userId!).toSet();

    for (var friend in myFriends) {
      final theirFriend =
          await fetchApprovedFriendRequest(friend.userModel.userId!);

      for (var each in theirFriend) {
        if (!userIds.contains(each.userModel.userId) &&
            !myFriendUserIds.contains(each.userModel.userId!) &&
            each.userModel.userId != currentUserID) {
          myFriendsFriends.add(each.userModel);
          userIds.add(each.userModel.userId!);
        }
      }
    }

    final List<UserMutualFriendsModel> mutualFriends = [];
    for (var each in myFriendsFriends) {
      final commonFriends =
          await fetchMutualFriendsWithFriend(currentUserID, each.userId!);
      mutualFriends.add(UserMutualFriendsModel(each, commonFriends));
    }

    return mutualFriends;
  }

  Future<List<UserModel>> readMutualFriends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? serializedFriends = prefs.getStringList('mutual_friends');

    if (serializedFriends == null) {
      return [];
    }

    List<UserModel> mutualFriends = serializedFriends
        .map((friendData) => UserModel.fromJson(jsonDecode(friendData)))
        .toList();

    return mutualFriends;
  }

  Future<void> saveMutualFriends(List<UserModel> mutualFriends) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List serializedFriends =
        mutualFriends.map((friend) => friend.toJson()).toList();
    await prefs.setStringList(
        'mutual_friends', serializedFriends.cast<String>());
  }

  Future<List<UserFriendshipModel>> fetchApprovedFriendRequest(
      String userID) async {
    String status = 'approved';
    List<String> userIDS = [];
    List<String> friendshipID = [];

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

    // Split userIDS into chunks of 10 (or the desired limit)
    const chunkSize = 10;
    final chunks = _splitListIntoChunks(userIDS, chunkSize);

    List<UserModel> users = [];
    for (var chunk in chunks) {
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('user_id', whereIn: chunk)
          .get();

      List<UserModel> chunkUsers =
          response.docs.map((doc) => UserModel.fromJson(doc.data())).toList();

      users.addAll(chunkUsers);
    }

    List<UserFriendshipModel> data = [];

    for (int i = 0; i < friendshipID.length; i++) {
      String friendID = friendshipID[i];

      UserModel? user = users.firstWhere((u) => u.userId == userIDS[i]);
      data.add(UserFriendshipModel(FriendshipID(friendshipId: friendID), user));
    }

    return data;
  }

  List<List<T>> _splitListIntoChunks<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  Future<List<NewUserFriendshipModel>> fetchAllFriendRequest(
      String userID) async {
    List<String> status = ['approved', 'pending'];

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

    List<String> userIDS = [];
    List<String> friendshipID = [];
    List<String> listOfStatus = [];

    for (var doc in fetchingReceiverID.docs) {
      String sender = doc.data()['sender'];
      String friendID = doc.data()['friendship_id'];
      String friendshipStatus = doc.data()['status'];

      userIDS.add(sender);
      friendshipID.add(friendID);
      listOfStatus.add(friendshipStatus);
    }

    for (var doc in fetchingSenderID.docs) {
      String receiver = doc.data()['receiver'];
      String friendID = doc.data()['friendship_id'];
      String friendshipStatus = doc.data()['status'];

      userIDS.add(receiver);
      friendshipID.add(friendID);
      listOfStatus.add(friendshipStatus);
    }

    if (userIDS.isEmpty) {
      return [];
    }

    List<UserModel> users = [];
    List<NewUserFriendshipModel> data = [];

    const batchSize = 10; // Maximum batch size for whereIn

    for (int i = 0; i < userIDS.length; i += batchSize) {
      List<String> batch = userIDS.sublist(
          i, i + batchSize > userIDS.length ? userIDS.length : i + batchSize);

      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('user_id', whereIn: batch)
          .get();

      users.addAll(
          response.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
    }

    for (int i = 0; i < friendshipID.length; i++) {
      String friendID = friendshipID[i];
      String status = listOfStatus[i];
      UserModel? user = users.firstWhere((u) => u.userId == userIDS[i]);
      data.add(NewUserFriendshipModel(
          FriendshipsID(friendshipId: friendID), user, Status(status: status)));
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

  static String generateFriendshipId(String userId1, String userId2) {
    return '$userId1$userId2';
  }

  Future<bool> addFriend(
    String senderID,
    receiverID,
  ) async {
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
          .then((value) async {
        log("Request send");
        final data = {
          "type": notificationType.friend_request.name,
          "current_user": senderID
        };

        NotificationRepository.addNotification(
            receiverID, 'Friend Request', 'sent you a friend request.',
            type: 'request');
      }).catchError((error) => log("Failed to add friend: $error"));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> fetchApprovedFriendRequestWithMutual(
      String userID) async {
    String status = 'approved';
    List<String> userIDS = [];
    List<String> friendshipID = [];

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
      return [[], []]; // Return empty lists for followers and mutual friends
    }

    // Split userIDS into chunks of 10 (or the desired limit)
    const chunkSize = 10;
    final chunks = _splitListIntoChunks(userIDS, chunkSize);

    List<UserModel> users = [];
    for (var chunk in chunks) {
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('user_id', whereIn: chunk)
          .get();

      List<UserModel> chunkUsers =
          response.docs.map((doc) => UserModel.fromJson(doc.data())).toList();

      users.addAll(chunkUsers);
    }

    List<UserFriendshipModel> data = [];
    List<UserApprovedMutualFriends> mutualFriends = [];

    for (int i = 0; i < friendshipID.length; i++) {
      String friendID = friendshipID[i];

      UserModel? user = users.firstWhere((u) => u.userId == userIDS[i]);
      data.add(UserFriendshipModel(FriendshipID(friendshipId: friendID), user));

      final commonFriends =
          await fetchMutualFriendsWithFriend(userID, userIDS[i]);
      mutualFriends.add(UserApprovedMutualFriends(
          UserFriendshipModel(FriendshipID(friendshipId: friendID), user),
          commonFriends));
    }
    return [mutualFriends]; // Return both followers and mutual friends
  }

  Future<List<UserApprovedMutualFriends>> fetchFriendRequest(
      String userID) async {
    String status = 'pending';
    List<String> userIDS = [];
    List<String> friendshipID = [];

    QuerySnapshot<Map<String, dynamic>> fetchingReceiverID =
        await FirebaseFirestore.instance
            .collection('Friendships')
            .where('status', isEqualTo: status)
            .where('receiver', isEqualTo: userID)
            .get();

    for (var doc in fetchingReceiverID.docs) {
      String sender = doc.data()['sender'];
      String friendID = doc.data()['friendship_id'];

      userIDS.add(sender);
      friendshipID.add(friendID);
    }

    if (userIDS.isEmpty) {
      return [];
    }

    // Fetch all users in a single query
    QuerySnapshot<Map<String, dynamic>> userResponse = await FirebaseFirestore
        .instance
        .collection('Users')
        .where('user_id', whereIn: userIDS)
        .get();

    List<UserModel> users =
        userResponse.docs.map((doc) => UserModel.fromJson(doc.data())).toList();

    List<UserFriendshipModel> data = [];

    for (int i = 0; i < friendshipID.length; i++) {
      String friendID = friendshipID[i];

      UserModel? user = users.firstWhere((u) => u.userId == userIDS[i]);
      data.add(UserFriendshipModel(FriendshipID(friendshipId: friendID), user));
    }

    final List<UserApprovedMutualFriends> mutualFriends =
        await Future.wait(data.map((each) async {
      final commonFriends =
          await fetchMutualFriendsWithFriend(userID, each.userModel.userId!);
      return UserApprovedMutualFriends(each, commonFriends);
    }));

    return mutualFriends
        .where(
            (element) => element.userFriendshipModel.userModel.userId != userID)
        .toList();
  }
}
