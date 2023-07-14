import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';

class SearchFriendRepository {
  Future<List<UserModel>> searchUser(String query) async {
    if (query.isEmpty) {
      return []; // Return an empty list if the query is empty
    }

    QuerySnapshot<Map<String, dynamic>> users = await FirebaseFirestore.instance
        .collection('Users')
        .where('display_name', isGreaterThanOrEqualTo: query)
        .where('display_name', isLessThan: '${query}z')
        .limit(5)
        .get();

    // Additional search options
    QuerySnapshot<Map<String, dynamic>> emailUsers = await FirebaseFirestore
        .instance
        .collection('Users')
        .where('email_address', isGreaterThanOrEqualTo: query)
        .where('email_address', isLessThan: '${query}z')
        .limit(5)
        .get();

    QuerySnapshot<Map<String, dynamic>> phoneUsers = await FirebaseFirestore
        .instance
        .collection('Users')
        .where('phone_number', isGreaterThanOrEqualTo: query)
        .where('phone_number', isLessThan: '${query}z')
        .limit(5)
        .get();

    Set<String> addedUserIDs = {}; // Track added user IDs
    List<UserModel> userResults = [];

    // Add user models from display_name query
    for (var doc in users.docs) {
      var userModel = UserModel.fromJson(doc.data());
      if (!addedUserIDs.contains(userModel.userId)) {
        userResults.add(userModel);
        addedUserIDs.add(userModel.userId!);
      }
    }

    // Add user models from email query
    for (var doc in emailUsers.docs) {
      var userModel = UserModel.fromJson(doc.data());
      if (!addedUserIDs.contains(userModel.userId)) {
        userResults.add(userModel);
        addedUserIDs.add(userModel.userId!);
      }
    }

    // Add user models from phone query
    for (var doc in phoneUsers.docs) {
      var userModel = UserModel.fromJson(doc.data());
      if (!addedUserIDs.contains(userModel.userId)) {
        userResults.add(userModel);
        addedUserIDs.add(userModel.userId!);
      }
    }

    // Remove yourself from the search results
    userResults.removeWhere((user) => user.userId == userID);

    return userResults;
  }
}
