import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/authentication/data/model/user_model.dart';

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

    return users.docs.map((e) => UserModel.fromJson(e.data())).toList();
  }
}
