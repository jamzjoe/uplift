import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';

class FriendShip {
  // static Future<List<UserFriendshipModel>> fetchFriendshipsBySenderID(
  //     String currentUserID) async {
  //   QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
  //       .instance
  //       .collection('Friendships')
  //       .where('sender', isEqualTo: currentUserID)
  //       .get();
  //   List<UserFriendshipModel> userFriendships = [];

  //   List<FriendShipModel> friendshipStatus =
  //       snapshot.docs.map((e) => FriendShipModel.fromJson(e.data())).toList();
  //   for (var each in friendshipStatus) {
  //     final UserModel? user =
  //         await PrayerRequestRepository().getUserRecord(each.receiver!);
  //     userFriendships.add(UserFriendshipModel(each, user!));
  //   }
  //   return userFriendships;
  // }

  // static Future<List<UserFriendshipModel>> fetchFriendshipsByReceiverID(
  //     String currentUserID) async {
  //   QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
  //       .instance
  //       .collection('Friendships')
  //       .where('receiver', isEqualTo: currentUserID)
  //       .get();
  //   List<UserFriendshipModel> userFriendships = [];

  //   List<FriendShipModel> friendshipStatus =
  //       snapshot.docs.map((e) => FriendShipModel.fromJson(e.data())).toList();
  //   for (var each in friendshipStatus) {
  //     final UserModel? user =
  //         await PrayerRequestRepository().getUserRecord(each.receiver!);
  //     userFriendships.add(UserFriendshipModel(each, user!));
  //   }
  //   return userFriendships;
  // }

  static Future<List<UserFriendshipModel>> fetchAllFriendship(
      String currentUserID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Friendships')
        .where('sender', isEqualTo: currentUserID)
        .where('receiver', isEqualTo: currentUserID)
        .get();
    List<UserFriendshipModel> userFriendships = [];

    List<FriendShipModel> friendshipStatus =
        snapshot.docs.map((e) => FriendShipModel.fromJson(e.data())).toList();
    for (var each in friendshipStatus) {
      final UserModel? user =
          await PrayerRequestRepository().getUserRecord(each.receiver!);
      userFriendships.add(UserFriendshipModel(
          FriendshipID(friendshipId: each.friendshipID), user!));
    }
    return userFriendships;
  }
}
