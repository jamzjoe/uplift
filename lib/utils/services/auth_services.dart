import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/utils/services/initialize.dart';

final Initialize _initialize = Initialize();

class AuthServices {
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
    User user,
    String? userName,
    String? provider,
  ) async {
    final token = await _initialize.getFCMToken();
    final userDoc =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);

    try {
      final userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        // User exists in the database, update the device token
        await userDoc.update({'device_token': token});
        log('Device token updated for existing user');
        return;
      }

      // User doesn't exist, so add them to the database
      final UserModel userModel = UserModel(
        displayName: user.displayName,
        emailAddress: user.email,
        emailVerified: user.emailVerified,
        userId: user.uid,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        createdAt: Timestamp.now(),
        provider: provider!,
        searchKey: userName!.isEmpty
            ? user.displayName!.toLowerCase()
            : userName.toLowerCase(),
        deviceToken: token,
      );

      await userDoc.set(userModel.toJson());
      log('User added to the database');
    } catch (error) {
      log('Failed to check or add user: $error');
    }
  }

  static Future<void> addUserFromEmailAndPassword(
      User user, String bio, String? userName) async {
    final UserModel userModel = UserModel(
      emailAddress: user.email,
      userId: user.uid,
      createdAt: Timestamp.now(),
      searchKey: userName?.toLowerCase() ?? '',
      provider: 'email_and_password',
      displayName: userName ?? 'Anonymous',
    );
    final token = await FirebaseMessaging.instance.getToken();
    userModel.deviceToken = token;

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .set(userModel.toJson());
      log('User added');
    } catch (error) {
      log('Failed to add user: $error');
    }
  }

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    return user;
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

  static bool isValidEmail(String email) {
    // Regular expression pattern for email validation
    const pattern =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';

    final regExp = RegExp(pattern);

    return regExp.hasMatch(email);
  }
}
