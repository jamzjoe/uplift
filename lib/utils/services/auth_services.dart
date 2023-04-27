import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/authentication/data/model/user_model.dart';

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

  static void addUser(User user, String bio) {
    final UserModel userModel = UserModel(
        displayName: user.displayName,
        emailAddress: user.email,
        emailVerified: user.emailVerified,
        userId: user.uid,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        createdAt: user.metadata.creationTime,
        bio: bio);
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
}
