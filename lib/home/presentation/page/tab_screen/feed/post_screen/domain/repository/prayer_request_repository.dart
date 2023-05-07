import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';

class PrayerRequestRepository {
  Future<List<PrayerRequestPostModel>> getPrayerRequestList() async {
    FriendsRepository friendsRepository = FriendsRepository();
    final fetchingUserID = await friendsRepository.fetchApprovedFriendRequest();
    List<String> friendsIDs =
        fetchingUserID.map((e) => e.userId.toString()).toList();
    friendsIDs.add(await AuthServices.userID());
    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('Prayers')
        .where('user_id', whereIn: friendsIDs)
        .orderBy('date', descending: false)
        .limit(20)
        .get();
    List<PrayerRequestPostModel> data = response.docs
        .map((e) => PrayerRequestPostModel.fromJson(e.data()))
        .toList()
        .reversed
        .toList();
    return data;
  }

  Future<List<UserModel>> getUserRecord(String userID) async {
    QuerySnapshot<Map<String, dynamic>> users =
        await FirebaseFirestore.instance.collection('Users').get();
    final data = users.docs;
    return data.map((e) => UserModel.fromJson(e.data())).toList();
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
        "users": {user.uid: true}
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
      await FirebaseFirestore.instance
          .collection('Prayers')
          .doc(postID)
          .update({
        "reactions": {
          "users": {userID: true}
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
