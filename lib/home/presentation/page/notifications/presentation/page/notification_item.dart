import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/notification_model.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/user_notif_model.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/utils/widgets/default_text.dart';

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

    return InkWell(
      onTapDown: (TapDownDetails tapDownDetails) {
        _showMenu(tapDownDetails, context, notification);
      },
      child: ListTile(
          tileColor: notification.read == true
              ? Colors.white
              : primaryColor.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.photoUrl!),
          ),
          subtitle: RichText(
              text: TextSpan(children: [
            TextSpan(
                text: user.displayName,
                style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            TextSpan(
                text: ' ${notification.message}',
                style: const TextStyle(color: secondaryColor, fontSize: 15)),
          ]))),
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
              onTap: () async => await NotificationRepository.delete(
                  notification.notificationId!),
              child: const DefaultText(
                text: 'Delete',
                color: secondaryColor,
              )),
          PopupMenuItem(
              onTap: () async => await NotificationRepository.markAsRead(
                  notification.notificationId!),
              child: const DefaultText(
                text: 'Mark as read',
                color: secondaryColor,
              ))
        ]);
  }
}
