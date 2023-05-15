import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';

class PrayerRequestRepository {
  Future<List<PostModel>> getPrayerRequestList() async {
    FriendsRepository friendsRepository = FriendsRepository();
    final List<PostModel> listOfPost = [];
    final fetchingUserID = await friendsRepository.fetchApprovedFriendRequest();
    List<String> friendsIDs =
        fetchingUserID.map((e) => e.userModel.userId.toString()).toList();
    friendsIDs.add(await AuthServices.userID());
    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('Prayers')
        .where('user_id', whereIn: friendsIDs)
        .orderBy('date', descending: false)
        .get();
    List<PrayerRequestPostModel> data = response.docs
        .map((e) => PrayerRequestPostModel.fromJson(e.data()))
        .toList()
        .reversed
        .toList();

    for (var each in data) {
      final UserModel user =
          await PrayerRequestRepository().getUserRecord(each.userId!);
      listOfPost.add(PostModel(user, each));
    }
    return listOfPost;
  }

  Future<List<PostModel>> searchPrayerRequest(String query) async {
    FriendsRepository friendsRepository = FriendsRepository();
    final List<PostModel> listOfPost = [];
    final fetchingUserID = await friendsRepository.fetchApprovedFriendRequest();
    List<String> friendsIDs =
        fetchingUserID.map((e) => e.userModel.userId.toString()).toList();
    friendsIDs.add(await AuthServices.userID());
    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('Prayers')
        .where('user_id', whereIn: friendsIDs)
        .orderBy('date', descending: false)
        .get();
    List<PrayerRequestPostModel> data = response.docs
        .map((e) => PrayerRequestPostModel.fromJson(e.data()))
        .toList()
        .reversed
        .toList();

    for (var each in data) {
      final UserModel user =
          await PrayerRequestRepository().getUserRecord(each.userId!);
      listOfPost.add(PostModel(user, each));
    }
    return listOfPost
        .where((element) => element.prayerRequestPostModel.text!
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  Future<UserModel> getUserRecord(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> users =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();

    return UserModel.fromJson(users.data()!);
  }

  Future<bool> postPrayerRequest(
      User user, String text, List<File> imageFiles, String name) async {
    CollectionReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.collection('Prayers');
    final postID = reference.doc().id;

    // Create a list to store the image URLs
    List<String> imageUrls = [];

    // Upload each image to Firebase Storage and get the download URLs
    for (int i = 0; i < imageFiles.length; i++) {
      final imageFile = imageFiles[i];
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('prayer_request_images/$postID-$i');
      final uploadTask = storageReference.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    // Create the prayerRequest object
    final prayerRequest = {
      "text": text,
      "user_id": user.uid,
      "date": DateTime.now(),
      "reactions": {"users": []},
      "post_id": postID,
      "image_url": imageUrls,
      "custom_name": name
    };

    try {
      await reference.doc(postID).set(prayerRequest);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<XFile?> imagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource
          .gallery, // set source to ImageSource.camera for taking a new photo
      imageQuality: 50, // set the image quality to 50%
    );
    return pickedFile;
  }

  Future<File> xFileToFile(XFile xFile) async {
    final filePath = xFile.path;
    return File(filePath);
  }

  Future<bool> addReaction(String postID, String userID) async {
    bool userExist = false;
    try {
      DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Prayers')
          .doc(postID)
          .get();

      final List<dynamic> currentReactions =
          response.data()!['reactions']['users'];

      for (var reaction in currentReactions) {
        if (reaction is Map && reaction.containsKey(userID)) {
          userExist = true;
        }
      }
      if (!userExist) {
        final updatedReactions = {
          'users': [
            ...currentReactions, // Include existing user IDs
            {userID: true}, // Add new user ID
          ]
        };
        await FirebaseFirestore.instance
            .collection('Prayers')
            .doc(postID)
            .update({'reactions': updatedReactions});
      }

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> isReacted(String postID, String userID) async {
    bool userExist = false;
    try {
      DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Prayers')
          .doc(postID)
          .get();

      final List<dynamic> currentReactions =
          response.data()!['reactions']['users'];

      for (var reaction in currentReactions) {
        if (reaction is Map && reaction.containsKey(userID)) {
          userExist = true;
        }
      }
      if (!userExist) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> unReact(String postID, String userID) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('Prayers').doc(postID);
      final docSnapshot = await docRef.get();

      final currentReactions =
          List<Map<String, dynamic>>.from(docSnapshot.get('reactions.users'));
      final userIndex = currentReactions
          .indexWhere((reaction) => reaction.containsKey(userID));

      if (userIndex >= 0) {
        currentReactions.removeAt(userIndex);
        await docRef.update({'reactions.users': currentReactions});
      }

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deletePost(String postID, String userID) async {
    bool canDelete = false;
    String currentUserID = await AuthServices.userID();

    if (userID == currentUserID) {
      try {
        await FirebaseFirestore.instance
            .collection('Prayers')
            .doc(postID)
            .delete();
        canDelete = true;
      } catch (e) {
        canDelete = false;
      }
    }

    return canDelete;
  }
}
