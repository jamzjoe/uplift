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
