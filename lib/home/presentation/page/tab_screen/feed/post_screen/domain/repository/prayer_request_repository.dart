import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';

class PrayerRequestRepository {
  Future<List<PostModel>> getPrayerRequestList() async {
    FriendsRepository friendsRepository = FriendsRepository();
    final List<PostModel> listOfPost = [];
    final fetchingUserID = await friendsRepository.fetchApprovedFriendRequest();
    List<String> friendsIDs =
        fetchingUserID.map((e) => e.userModel.userId.toString()).toList();
    friendsIDs.add(await AuthServices.userID());
    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('Prayers')
        .where('user_id', whereIn: friendsIDs)
        .orderBy('date', descending: false)
        .get();
    List<PrayerRequestPostModel> data = response.docs
        .map((e) => PrayerRequestPostModel.fromJson(e.data()))
        .toList()
        .reversed
        .toList();

    for (var each in data) {
      final UserModel user =
          await PrayerRequestRepository().getUserRecord(each.userId!);
      listOfPost.add(PostModel(user, each));
    }
    return listOfPost;
  }

  Future<UserModel> getUserRecord(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> users =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();

    return UserModel.fromJson(users.data()!);
  }

  Future<bool> postPrayerRequest(User user, String text) async {
    CollectionReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.collection('Prayers');
    final postID = reference.doc().id;
    final prayerRequest = {
      "text": text,
      "user_id": user.uid,
      "date": DateTime.now(),
      "reactions": {
        "users": [
          {user.uid: true}
        ]
      },
      "post_id": postID
    };

    try {
      await reference.doc(postID).set(prayerRequest);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addReaction(String postID, String userID) async {
    try {
      final postRef =
          FirebaseFirestore.instance.collection('Prayers').doc(postID);

// Fetch the current value of the reactions field
      final postSnapshot = await postRef.get();
      final currentReactions = postSnapshot.data()?['reactions'];
      log(currentReactions);
// Update the reactions field
      final updatedReactions = {
        'users': [
          ...currentReactions['users'], // Include existing user IDs
          FieldValue.arrayUnion([
            {userID: true}
          ]), // Add new user ID
        ]
      };
      postRef.update({'reactions': updatedReactions});
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
