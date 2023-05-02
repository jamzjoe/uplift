import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/authentication/data/model/user_model.dart';

class FriendSuggestionRepository {
  Future<List<UserModel>> fetchUsers() async {
    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('Users')
        .orderBy('created_at', descending: false)
        .get();
    List<UserModel> data = response.docs
        .map((e) => UserModel.fromJson(e.data()))
        .toList()
        .reversed
        .toList();
    return data;
  }
}
