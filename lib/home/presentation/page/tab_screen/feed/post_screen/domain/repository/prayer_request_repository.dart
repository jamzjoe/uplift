import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';

class PrayerRequestRepository {
  Future<List<PrayerRequestPostModel>> getPrayerRequestList() async {
    QuerySnapshot<Map<String, dynamic>> response =
        await FirebaseFirestore.instance.collection('Prayers').get();
    List<PrayerRequestPostModel> data = response.docs
        .map((e) => PrayerRequestPostModel.fromJson(e.data()))
        .toList()
        .reversed
        .toList();
    return data;
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
