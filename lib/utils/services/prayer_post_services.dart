import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrayerPostService {
  static Future<bool> postPrayerRequest(User user, String text) async {
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
