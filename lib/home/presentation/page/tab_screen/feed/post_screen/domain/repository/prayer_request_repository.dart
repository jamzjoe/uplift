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
      "reactions": {"users": []},
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
    bool userExist = false;
    try {
      DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Prayers')
          .doc(postID)
          .get();

      final List<dynamic> currentReactions =
          response.data()!['reactions']['users'];

      for (var reaction in currentReactions) {
        if (reaction is Map && reaction.containsKey(userID)) {
          log('User exist');
          userExist = true;
        }
      }
      if (!userExist) {
        final updatedReactions = {
          'users': [
            ...currentReactions, // Include existing user IDs
            {userID: true}, // Add new user ID
          ]
        };
        await FirebaseFirestore.instance
            .collection('Prayers')
            .doc(postID)
            .update({'reactions': updatedReactions});
      }

      log(currentReactions.toString());

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> isReacted(String postID, String userID) async {
    bool userExist = false;
    try {
      DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Prayers')
          .doc(postID)
          .get();

      final List<dynamic> currentReactions =
          response.data()!['reactions']['users'];

      for (var reaction in currentReactions) {
        if (reaction is Map && reaction.containsKey(userID)) {
          log('User exist');
          userExist = true;
        }
      }
      if (!userExist) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> unReact(String postID, String userID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Prayers')
          .doc(postID)
          .get();

      final List<dynamic> currentReactions =
          response.data()!['reactions']['users'];

      bool userExist = false;
      int userIndex = -1;

      for (var i = 0; i < currentReactions.length; i++) {
        var reaction = currentReactions[i];
        if (reaction is Map && reaction.containsKey(userID)) {
          log('User exist');
          userExist = true;
          userIndex = i;
          break;
        }
      }

      if (userExist) {
        final updatedReactions = {
          'users': List<dynamic>.from(currentReactions)..removeAt(userIndex)
        };
        await FirebaseFirestore.instance
            .collection('Prayers')
            .doc(postID)
            .update({'reactions': updatedReactions});
      }

      log(currentReactions.toString());

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deletePost(String postID, String userID) async {
    bool canDelete = false;
    String currentUserID = await AuthServices.userID();

    if (userID == currentUserID) {
      try {
        await FirebaseFirestore.instance
            .collection('Prayers')
            .doc(postID)
            .delete();
        canDelete = true;
      } catch (e) {
        canDelete = false;
      }
    }

    return canDelete;
  }
}
