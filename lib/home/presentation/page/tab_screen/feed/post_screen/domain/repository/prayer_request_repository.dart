import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';

class PrayerRequestRepository {
  Future<List<PrayerRequestPostModel>> getPrayerRequestList() async {
    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('Prayers')
        .orderBy('date', descending: false)
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
    final prayerRequest = {
      "text": text,
      "user_id": user.uid,
      "date": DateTime.now(),
      "reactions": {
        "users": {user.uid: true}
      }
    };

    try {
      await FirebaseFirestore.instance
          .collection('Prayers')
          .doc()
          .set(prayerRequest);
      return true;
    } catch (e) {
      return false;
    }
  }
}
