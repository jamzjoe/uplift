import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/notification_model.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notificationModel,
  });
  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: notificationModel.read == true
          ? Colors.transparent
          : primaryColor.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultText(
                    text: notificationModel.message ?? 'Notification title',
                    color: secondaryColor),
                const SmallText(text: '12 minutes ago', color: lightColor)
              ],
            ),
          )
        ],
      ),
    );
  }
}
