import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';

class AuthServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<UserJoinedModel> signInWithGoogle() async {
    UserJoinedModel? userJoin;

    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    UserModel userModel =
        await PrayerRequestRepository().getUserRecord(userCredential.user!.uid);
    userJoin = UserJoinedModel(userModel, userCredential.user!);

    return userJoin;
  }

  static Future<UserJoinedModel> signInWithEmailAndPassword(
      String email, password) async {
    UserJoinedModel? userJoin;
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    UserModel userModel =
        await PrayerRequestRepository().getUserRecord(userCredential.user!.uid);
    userJoin = UserJoinedModel(userModel, userCredential.user!);
    return userJoin;
  }

//   Future<void> sendPushNotification(String deviceToken, String title, String body) async {
//   var message = {
//     'notification': {'title': title, 'body': body},
//     'to': deviceToken,
//   };
//   await _firebaseMessaging.sendMessage(data: message);
// }

  static Future<String> userID() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future addUser(User user, String bio) async {
    final UserModel userModel = UserModel(
        displayName: user.displayName,
        emailAddress: user.email,
        emailVerified: user.emailVerified,
        userId: user.uid,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        createdAt: Timestamp.now(),
        bio: bio,
        searchKey: user.displayName!.toLowerCase());
    final token = await FirebaseMessaging.instance.getToken();
    userModel.deviceToken = token;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .set(userModel.toJson())
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future addUserFromEmailAndPassword(User user, String bio) async {
    final UserModel userModel = UserModel(
        emailAddress: user.email,
        userId: user.uid,
        createdAt: Timestamp.now(),
        displayName: 'Uplift User #${user.uid}');
    final token = await FirebaseMessaging.instance.getToken();
    userModel.deviceToken = token;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .set(userModel.toJson())
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<UserJoinedModel> registerWithEmailAndPassword(
      String email, password) async {
    UserJoinedModel? userJoin;
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    UserModel userModel =
        await PrayerRequestRepository().getUserRecord(userCredential.user!.uid);
    userJoin = UserJoinedModel(userModel, userCredential.user!);
    return userJoin;
  }

  static signOut() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().disconnect();
  }

  String generateRandomId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    const idLength = 10;
    final idChars =
        List.generate(idLength, (index) => chars[random.nextInt(chars.length)]);
    final id = idChars.join();
    return id;
  }
}
