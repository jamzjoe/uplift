import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uplift/utils/services/auth_services.dart';

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

  static Future<void> updateContactNo(String phoneNumber, String userID) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .update({'phone_number': phoneNumber})
        .then((value) => log('Phone number updated successfully!'))
        .catchError((error) => log('Phone number updating error: $error'));
  }

  static Future updateProfile(String displayName, emailAddress, contactNo,
      File image, bio, provider) async {
    final imageURL = await AuthRepository().uploadProfilePicture(image);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      displayName.isNotEmpty ? user.updateDisplayName(displayName) : null;
      emailAddress.isNotEmpty ? user.updateEmail(emailAddress) : null;
      contactNo.isNotEmpty
          ? AuthRepository.updateContactNo(contactNo, user.uid)
          : null;
      imageURL.isNotEmpty ? user.updatePhotoURL(imageURL) : null;
      bio.isNotEmpty ? AuthRepository.updateBio(bio, user.uid) : null;
      if (provider == 'google_sign_in') {
        await AuthServices.addUser(user, bio, "", 'google_sign_in');
      } else {
        await AuthServices.addUserFromEmailAndPassword(user, bio, displayName);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> uploadProfilePicture(File imageFile) async {
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

    // Return the image URL
    return imageUrl;
  }
}
