import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/main.dart';

class AuthServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential.user;
  }

  static Future<User?> signInWithEmailAndPassword(
      String email, password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  static Future<String> userID() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<void> addUser(
      User user, String bio, String? userName, String? provider) async {
    final token = await getFCMToken();
    final UserModel userModel = UserModel(
      displayName: user.displayName,
      emailAddress: user.email,
      emailVerified: user.emailVerified,
      userId: user.uid,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      createdAt: Timestamp.now(),
      bio: bio,
      provider: provider!,
      searchKey: userName!.isEmpty
          ? user.displayName!.toLowerCase()
          : userName.toLowerCase(),
      deviceToken: token,
    );

    final userDoc =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);

    try {
      final userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        final existingBio = userSnapshot.data()?['bio'];
        await userDoc.update({'device_token': token});
        if (existingBio != null) {
          log('User bio already exists. Skipping update.');
          return; // Exit the function if bio exists
        }
      }

      await userDoc.set(userModel.toJson(), SetOptions(merge: true));
      log('User added or updated');
    } catch (error) {
      log('Failed to add or update user: $error');
    }
  }

  static Future addUserFromEmailAndPassword(
      User user, String bio, String? userName) async {
    log(userName!);
    final UserModel userModel = UserModel(
        emailAddress: user.email,
        userId: user.uid,
        createdAt: Timestamp.now(),
        searchKey: userName.toLowerCase(),
        provider: 'email_and_password',
        displayName: userName ?? 'Uplift User');
    final token = await FirebaseMessaging.instance.getToken();
    userModel.deviceToken = token;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .set(userModel.toJson())
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<User?> registerWithEmailAndPassword(
      String email, password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  static signOut() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().disconnect();
  }

  Future<UserModel> getUserRecord(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> users =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();

    return UserModel.fromJson(users.data()!);
  }

  Future<void> deleteUser(String userID) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userID).delete();
      log('User deleted successfully!');
    } catch (e) {
      log('Error deleting user: $e');
    }
  }
}
