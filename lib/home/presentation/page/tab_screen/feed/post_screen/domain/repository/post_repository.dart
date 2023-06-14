import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';

class PostRepository {
  static void setPrivacy(String postID, PostPrivacy postPrivacy) async {
    final reference =
        FirebaseFirestore.instance.collection('Prayers').doc(postID);

    final existingData = await reference.get();
    final privacyValue =
        existingData.data()!.containsKey('privacy') ? postPrivacy.name : null;

    reference.update({"privacy": privacyValue});
  }
}
