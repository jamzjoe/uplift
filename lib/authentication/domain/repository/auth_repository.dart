import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get user => _firebaseAuth.authStateChanges();

  static Future<void> updateBio(String bio, String userID) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .update({'bio': bio})
        .then((value) => log('Bio updated successfully!'))
        .catchError((error) => log('Error updating bio: $error'));
  }

  static Future<void> updateName(String displayName, String userID) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .update({'display_name': displayName})
        .then((value) => log('Display name updated successfully!'))
        .catchError((error) => log('Display name: $error'));
  }

  static Future<void> updateContactNo(String phoneNumber, String userID) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .update({'phone_number': phoneNumber})
        .then((value) => log('Phone number updated successfully!'))
        .catchError((error) => log('Phone number updating error: $error'));
  }

  static Future updateProfile(
      String displayName, emailAddress, contactNo, bio, userID) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      displayName.isNotEmpty ? await user.updateDisplayName(displayName) : null;
      displayName.isNotEmpty
          ? await AuthRepository.updateName(displayName, userID)
          : null;
      // emailAddress.isNotEmpty ? user.updateEmail(emailAddress) : null;
      contactNo.isNotEmpty
          ? await AuthRepository.updateContactNo(contactNo, user.uid)
          : null;
      bio.isNotEmpty ? await AuthRepository.updateBio(bio, user.uid) : null;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> uploadProfilePicture(File imageFile, String userID) async {
    try {
      // Generate a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to the Firebase Storage location
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('profilePictures/$fileName.jpg');

      // Upload the file to Firebase Storage
      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});

      // Get the download URL of the uploaded image
      final String imageUrl = await storageSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .update({'photo_url': imageUrl})
          .then((value) => log('Profile photo uploaded successfully!'))
          .catchError((error) => log('Error updating: $error'));
      // Return the image URL
      log(imageUrl);
      return imageUrl;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }
}
