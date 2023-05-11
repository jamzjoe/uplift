part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class FetchListOfNotification extends NotificationEvent {
  final String userID;
  final bool newNotif;

  const FetchListOfNotification(this.userID, this.newNotif);
  @override
  List<Object> get props => [userID];
}

class RefreshListOfNotification extends NotificationEvent {
  final String userID;
  final bool newNotif;

  const RefreshListOfNotification(this.userID, this.newNotif);
  @override
  List<Object> get props => [userID];
}

class ClearNotification extends NotificationEvent {
  final List<UserNotifModel> notificationList;
  final String userID;

  const ClearNotification(this.notificationList, this.userID);

  @override
  List<Object?> get props => [];
}

class MarkAllAsRead extends NotificationEvent {
  final List<UserNotifModel> notificationList;
  final String userID;

  const MarkAllAsRead(this.notificationList, this.userID);

  @override
  List<Object?> get props => [];
}

class MarkOneAsRead extends NotificationEvent {
  final String userID, notificationID;

  const MarkOneAsRead(this.userID, this.notificationID);

  @override
  List<Object?> get props => [userID, notificationID];
}

class DeleteOneNotif extends NotificationEvent {
  final String userID, notificationID;

  const DeleteOneNotif(this.userID, this.notificationID);

  @override
  List<Object?> get props => [userID, notificationID];
}
