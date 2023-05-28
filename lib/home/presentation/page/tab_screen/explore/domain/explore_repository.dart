import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';

class ExploreRepository {
  Future<List<PostModel>> getAllPrayerRequestList(
      {int? limit, required String userID}) async {
    final listOfPost = <PostModel>[];

    final response = await FirebaseFirestore.instance
        .collection('Prayers')
        .orderBy('date', descending: true)
        .get();

    final data = response.docs
        .map((e) => PrayerRequestPostModel.fromJson(e.data()))
        .toList();

    for (var each in data) {
      final user = await PrayerRequestRepository().getUserRecord(each.userId!);

      if (user != null) {
        listOfPost.add(PostModel(user, each));
      }
    }

    listOfPost.sort((a, b) => b.prayerRequestPostModel.date!
        .compareTo(a.prayerRequestPostModel.date!));

    return listOfPost;
  }
}
