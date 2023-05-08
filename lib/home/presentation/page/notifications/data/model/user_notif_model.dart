import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/notification_model.dart';

class UserNotifModel {
  final UserModel userModel;
  final NotificationModel notificationModel;

  UserNotifModel(this.userModel, this.notificationModel);
}
