import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';

import '../../data/model/post_model.dart';

class PostRepository {
  static void setPrivacy(String postID, PostPrivacy postPrivacy) async {
    final reference =
        FirebaseFirestore.instance.collection('Prayers').doc(postID);

    final existingData = await reference.get();
    final privacyValue =
        existingData.data()!.containsKey('privacy') ? postPrivacy.name : null;

    reference.update({"privacy": privacyValue});
  }

  Future<PostModel?> getEachPrayerIntention(
      String postID, String postUserID) async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('Prayers')
        .where('post_id', isEqualTo: postID)
        .get();
    final postUser = await PrayerRequestRepository().getUserRecord(postUserID);
    if (data.docs.isNotEmpty) {
      return PostModel(
          postUser!, PrayerRequestPostModel.fromJson(data.docs[0].data()));
    } else {
      return null;
    }
  }
}
