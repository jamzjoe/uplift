import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/intentions_user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';

class PrayerRequestRepository {
  Stream<Map<String, dynamic>> getReactionInfo(String postID, String userID) {
    return FirebaseFirestore.instance
        .collection('Prayers')
        .doc(postID)
        .snapshots()
        .map((snapshot) {
      final List<dynamic> currentReactions =
          snapshot.data()!['reactions']['users'];
      bool userExist = false;
      for (var reaction in currentReactions) {
        if (reaction is Map && reaction.containsKey(userID)) {
          userExist = true;
        }
      }
      final int reactionCount = currentReactions.length;
      return {
        'isReacted': !userExist,
        'reactionCount': reactionCount,
      };
    }).handleError((error) {
      // Handle error if necessary
      return {'isReacted': false, 'reactionCount': 0};
    });
  }

  Future<List<PostModel>> getPrayerRequestList(
      {int? limit, required String userID}) async {
    final friendsRepository = FriendsRepository();
    List<PostModel> listOfPost = <PostModel>[];
    log('${limit}Joe');
    try {
      final fetchingUserID =
          await friendsRepository.fetchApprovedFriendRequest(userID);
      final friendsIDs =
          fetchingUserID.map((e) => e.userModel.userId.toString()).toList();
      friendsIDs.add(await AuthServices.userID());

      const chunkSize = 10;
      final chunks = _splitListIntoChunks(friendsIDs, chunkSize);

      final data = <PrayerRequestPostModel>[];

      for (var chunk in chunks) {
        QuerySnapshot<Map<String, dynamic>> response;
        if (limit != null) {
          response = await FirebaseFirestore.instance
              .collection('Prayers')
              .where('user_id', whereIn: chunk)
              .orderBy('date', descending: true)
              .limit(limit)
              .get();
        } else {
          response = await FirebaseFirestore.instance
              .collection('Prayers')
              .where('user_id', whereIn: chunk)
              .orderBy('date', descending: true)
              .get();
        }

        final chunkData = response.docs
            .map((e) => PrayerRequestPostModel.fromJson(e.data()))
            .toList();

        data.addAll(chunkData);
      }

      for (var each in data) {
        final user =
            await PrayerRequestRepository().getUserRecord(each.userId!);

        if (user != null) {
          listOfPost.add(PostModel(user, each));
        }
      }
      log(limit!.toString());
      listOfPost.sort((a, b) => b.prayerRequestPostModel.date!
          .compareTo(a.prayerRequestPostModel.date!));
    } catch (error) {
      log('Error in get prayer: $error');
    }

    return listOfPost
        .where((element) =>
            element.prayerRequestPostModel.privacy == null ||
            element.prayerRequestPostModel.userId == userID ||
            element.prayerRequestPostModel.privacy == PostPrivacy.public.name)
        .toList();
  }

  List<List<T>> _splitListIntoChunks<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  Future<List<PostModel>> getPrayerRequestListByReactions() async {
    FriendsRepository friendsRepository = FriendsRepository();
    List<PostModel> listOfPost = [];

    try {
      final userID = await AuthServices.userID();
      final fetchingUserID =
          await friendsRepository.fetchApprovedFriendRequest(userID);
      List<String> friendsIDs =
          fetchingUserID.map((e) => e.userModel.userId.toString()).toList();
      friendsIDs.add(await AuthServices.userID());

      // Split friendsIDs into chunks of 10 (or the desired limit)
      const chunkSize = 10;
      final chunks = _splitListIntoChunks(friendsIDs, chunkSize);

      List<PrayerRequestPostModel> data = [];

      // Perform multiple queries for each chunk
      for (var chunk in chunks) {
        QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
            .instance
            .collection('Prayers')
            .where('user_id', whereIn: chunk)
            .get();

        List<PrayerRequestPostModel> chunkData = response.docs
            .map((e) => PrayerRequestPostModel.fromJson(e.data()))
            .toList();

        data.addAll(chunkData);
      }

      // Sort prayer requests by the length of reactions
      data.sort((a, b) => (b.reactions?.users?.length ?? 0)
          .compareTo(a.reactions?.users?.length ?? 0));

      for (var each in data) {
        final UserModel? user =
            await PrayerRequestRepository().getUserRecord(each.userId!);

        if (user != null) {
          listOfPost.add(PostModel(user, each));
        }
      }
    } catch (error) {
      // Handle any potential errors or exceptions
      log('Error in getPrayerRequestListByReactions: $error');
    }

    return listOfPost;
  }

  List<List<T>> splitListIntoChunks<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  Future<List<PostModel>> searchPrayerRequest(String query) async {
    FriendsRepository friendsRepository = FriendsRepository();
    List<PostModel> listOfPost = [];

    try {
      final userID = await AuthServices.userID();
      final fetchingUserID =
          await friendsRepository.fetchApprovedFriendRequest(userID);
      List<String> friendsIDs =
          fetchingUserID.map((e) => e.userModel.userId.toString()).toList();
      friendsIDs.add(await AuthServices.userID());

      // Split friendsIDs into chunks of 10 (or the specified limit)
      const chunkSize = 10;
      final chunks = _splitListIntoChunks(friendsIDs, chunkSize);

      List<PrayerRequestPostModel> data = [];

      // Perform multiple queries for each chunk
      for (var chunk in chunks) {
        QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
            .instance
            .collection('Prayers')
            .where('user_id', whereIn: chunk)
            .orderBy('date', descending: true)
            .limit(10)
            .get();

        List<PrayerRequestPostModel> chunkData = response.docs
            .map((e) => PrayerRequestPostModel.fromJson(e.data()))
            .toList();

        data.addAll(chunkData);
      }

      for (var each in data) {
        final UserModel? user =
            await PrayerRequestRepository().getUserRecord(each.userId!);

        if (user != null) {
          listOfPost.add(PostModel(user, each));
        }
      }
    } catch (error) {
      // Handle any potential errors or exceptions
      log('Error in get prayer: $error');
    }

    return listOfPost
        .where((element) =>
            element.prayerRequestPostModel.text!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element.prayerRequestPostModel.title!
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
  }

  Future<UserModel?> getUserRecord(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> users =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();

    if (users.exists) {
      return UserModel.fromJson(users.data()!);
    } else {
      return null;
    }
  }

  Future<bool> postPrayerRequest(User user, String text, List<File> imageFiles,
      String name, List<UserFriendshipModel> friends, String title) async {
    log(friends.toString());
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
      "custom_name": name,
      "title": title,
      'privacy': PostPrivacy.public.name
    };

    try {
      await reference.doc(postID).set(prayerRequest);
      for (var each in friends) {
        log('Running notif');
        final message = '${user.displayName} post a prayer intention.';
        NotificationRepository.sendPushMessage(each.userModel.deviceToken!,
            message, 'Uplift Notification', 'post');
        NotificationRepository.addNotification(
            each.userModel.userId!, title, 'post a prayer intention.');
      }
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

  Future<bool> addReaction(String postID, String userID, UserModel userModel,
      UserModel currentUser, PostModel postModel) async {
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

      if (currentUser.userId != userModel.userId) {
        NotificationRepository.sendPushMessage(
          userModel.deviceToken!,
          '${currentUser.displayName} prayed your prayer intentions.',
          'Uplift notification',
          'react',
        );

        Map<String, dynamic> jsonData =
            postModel.prayerRequestPostModel.toJson();
        DateTime dateTime =
            postModel.prayerRequestPostModel.date!.toDate(); // Assuming `date` is a `Timestamp` object
        jsonData['date'] = dateTime.toUtc().toIso8601String();
        String data = jsonEncode(jsonData);

        NotificationRepository.addNotification(
          userModel.userId!,
          'Uplift notification',
          'prayed your prayer intentions.',
          payload: data,
          type: 'react',
        );
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

    try {
      await FirebaseFirestore.instance
          .collection('Prayers')
          .doc(postID)
          .delete();
      canDelete = true;
    } catch (e) {
      canDelete = false;
    }

    return canDelete;
  }

  Future<List<PostModel>> getPrayerIntentions(
      String userID, bool isSelf) async {
    FriendsRepository friendsRepository = FriendsRepository();
    List<PostModel> listOfPost = [];

    try {
      final fetchingUserID =
          await friendsRepository.fetchApprovedFriendRequest(userID);
      List<String> friendsIDs =
          fetchingUserID.map((e) => e.userModel.userId.toString()).toList();
      friendsIDs.add(await AuthServices.userID());
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Prayers')
          .where('user_id', isEqualTo: userID)
          .orderBy('date', descending: true)
          .get();
      List<PrayerRequestPostModel> data = response.docs
          .map((e) => PrayerRequestPostModel.fromJson(e.data()))
          .toList();

      for (var each in data) {
        final UserModel? user =
            await PrayerRequestRepository().getUserRecord(each.userId!);

        if (user != null) {
          listOfPost.add(PostModel(user, each));
        }
      }
    } catch (error) {
      // Handle any potential errors or exceptions
      log('Error in getPrayerRequestList: $error');
    }

    if (isSelf != true) {
      return listOfPost
          .where((element) =>
              element.prayerRequestPostModel.privacy == null ||
              element.prayerRequestPostModel.userId == userID ||
              element.prayerRequestPostModel.privacy ==
                  PostPrivacy.public.name ||
              element.prayerRequestPostModel.privacy ==
                  PostPrivacy.private.name)
          .toList();
    } else {
      return listOfPost
          .where((element) =>
              element.prayerRequestPostModel.privacy == null ||
              element.prayerRequestPostModel.userId != userID ||
              element.prayerRequestPostModel.privacy == PostPrivacy.public.name)
          .toList();
    }
  }

  Future<List<IntentionsAndUserModel>> getSuggestedThatHaveSameIntentions(
      String userID) async {
    final List<PostModel> myPrayerIntentions =
        await PrayerRequestRepository().getPrayerIntentions(userID, true);
    final List<PrayerRequestPostModel> allPrayerIntentions =
        await PrayerRequestRepository().getAllPrayerRequestList();
    List<IntentionsAndUserModel> myIntentionsAndUser = [];
    List<IntentionsAndUserModel> publicPrayerIntentions = [];

    for (var intention in myPrayerIntentions) {
      myIntentionsAndUser.add(IntentionsAndUserModel(
          intention.prayerRequestPostModel.title?.toLowerCase() ?? '',
          intention.userModel));
    }
    for (var otherIntention in allPrayerIntentions) {
      final UserModel user =
          await AuthServices().getUserRecord(otherIntention.userId!);
      publicPrayerIntentions.add(IntentionsAndUserModel(
          otherIntention.title?.toLowerCase() ?? '', user));
    }

    List<IntentionsAndUserModel> filteredIntentions = [];

    for (var intention in publicPrayerIntentions) {
      if (myIntentionsAndUser
          .any((publicIntention) => publicIntention.text == intention.text)) {
        if (intention.userModel!.userId != userID &&
            !filteredIntentions.any((filteredIntention) =>
                filteredIntention.userModel!.userId ==
                intention.userModel!.userId)) {
          filteredIntentions.add(intention);
        }
      }
    }

    return filteredIntentions;
  }

  Future<List<PrayerRequestPostModel>> getAllPrayerRequestList(
      {int? limit}) async {
    List<PrayerRequestPostModel> prayerIntentions = [];
    try {
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
          .instance
          .collection('Prayers')
          .orderBy('date', descending: true)
          .get();
      prayerIntentions = response.docs
          .map((e) => PrayerRequestPostModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      log(e.toString());
    }
    return prayerIntentions;
  }
}
