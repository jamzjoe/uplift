import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/notification_model.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/user_notif_model.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notificationModel,
  });
  final UserNotifModel notificationModel;

  @override
  Widget build(BuildContext context) {
    final user = notificationModel.userModel;
    final notification = notificationModel.notificationModel;

    return Dismissible(
      key: Key(notification.notificationId!),
      onDismissed: (direction) {
        BlocProvider.of<NotificationBloc>(context)
            .add(DeleteOneNotif(userID, notification.notificationId!));
      },
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          child: Row(children: [
            ProfilePhoto(user: user, radius: 15, size: 50),
            const SizedBox(width: 10),
            Flexible(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: user.displayName,
                    style: const TextStyle(
                        color: primaryColor,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                TextSpan(
                    text: ' ${notification.message}',
                    style: TextStyle(
                        color: lighter, fontSize: 14, fontFamily: 'Quicksand')),
              ])),
            )
          ]),
        ),
      ),
    );
  }

  void _showMenu(TapDownDetails tapDownDetails, BuildContext context,
      NotificationModel notification) {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(tapDownDetails.globalPosition.dx,
            tapDownDetails.globalPosition.dy, 0, 0),
        items: [
          PopupMenuItem(
              onTap: () async {
                BlocProvider.of<NotificationBloc>(context)
                    .add(DeleteOneNotif(userID, notification.notificationId!));
              },
              child: const DefaultText(
                text: 'Delete',
                color: secondaryColor,
              )),
          PopupMenuItem(
              onTap: () async {
                BlocProvider.of<NotificationBloc>(context)
                    .add(MarkOneAsRead(userID, notification.notificationId!));
              },
              child: const DefaultText(
                text: 'Mark as read',
                color: secondaryColor,
              ))
        ]);
  }
}
