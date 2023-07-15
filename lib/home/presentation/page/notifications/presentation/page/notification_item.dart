import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/payload_model.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/user_notif_model.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/post_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/full_post_view/full_post_view.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/your_friends_screen.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

import '../../../tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key? key,
    required this.notificationModel,
    required this.currentUser,
  }) : super(key: key);

  final UserNotifModel notificationModel;
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    final user = notificationModel.userModel;
    final notification = notificationModel.notificationModel;
    final type = notificationModel.notificationModel.type;
    final payload = notificationModel.notificationModel.payload;

    return Dismissible(
      key: Key(notification.notificationId!),
      onDismissed: (direction) {
        BlocProvider.of<NotificationBloc>(context)
            .add(DeleteOneNotif(userID, notification.notificationId!));
      },
      child: InkWell(
        onTap: () async {
          final data = jsonDecode(payload!);
          final notifType = type;
          await routing(notifType, data, payload, context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          child: Row(
            children: [
              ProfilePhoto(user: user, radius: 15, size: 50),
              const SizedBox(width: 10),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: user.displayName,
                        style: const TextStyle(
                          color: darkColor,
                          fontFamily: 'Varela',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(
                        text: ' ${notification.message}',
                        style: TextStyle(
                          color: lighter,
                          fontSize: 14,
                          fontFamily: 'Varela',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openPrayerIntention(BuildContext context, UserModel user,
      PrayerRequestPostModel data, UserModel currentUser) {
    BlocProvider.of<EncourageBloc>(context)
        .add(FetchEncourageEvent(data.postId!));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullPostView(
            postModel: PostModel(user, data), currentUser: currentUser),
      ),
    );
  }

  Future<void> routing(
      notifType, data, String payload, BuildContext context) async {
    if (notifType == notificationType.comment.name) {
      final postId = data['post_id'];
      final postUserID = data['post_user_id'];
      final postModel =
          await PostRepository().getEachPrayerIntention(postId, postUserID);
      final userID = FirebaseAuth.instance.currentUser!.uid;
      await PrayerRequestRepository().getUserRecord(userID).then((value) =>
          openPrayerIntention(context, postModel!.userModel,
              postModel.prayerRequestPostModel, value!));
    } else if (notifType == notificationType.friend_request.name) {
      await PrayerRequestRepository()
          .getUserRecord(data['current_user'])
          .then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YourFriendsScreen(user: value!),
                ),
              ));
    } else if (notifType == "add_friend") {
      log('tap');
      final userID = FirebaseAuth.instance.currentUser!.uid;
      await PrayerRequestRepository()
          .getUserRecord(userID)
          .then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendsScreen(currentUser: value!),
                ),
              ));
    } else if (notifType == notificationType.post.name ||
        notifType == notificationType.react.name) {
      final decodedPayload = jsonDecode(payload);
      final timestampString = decodedPayload['date'];
      final timestamp = Timestamp.fromDate(DateTime.parse(timestampString));
      final text = decodedPayload['text'];
      final userId = decodedPayload['user_id'];
      final postId = decodedPayload['post_id'];
      final customName = decodedPayload['custom_name'];
      final title = decodedPayload['title'];

      final data = PrayerRequestPostModel(
        date: timestamp,
        text: text,
        userId: userId,
        postId: postId,
        name: customName,
        title: title,
      );

      final userID = FirebaseAuth.instance.currentUser!.uid;
      final currentUser = await PrayerRequestRepository().getUserRecord(userID);
      await PrayerRequestRepository().getUserRecord(userId).then(
          (value) => openPrayerIntention(context, value!, data, currentUser!));
    }
  }
}
