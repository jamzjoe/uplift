import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get user => _firebaseAuth.authStateChanges();

  static Future<void> updateBio(String bio, String userID) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .update({'bio': bio})
        .then((value) => print('Bio updated successfully!'))
        .catchError((error) => print('Error updating bio: $error'));
  }
}
