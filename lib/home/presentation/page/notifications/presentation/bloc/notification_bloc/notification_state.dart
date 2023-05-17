part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoading extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoadingSuccess extends NotificationState {
  final List<UserNotifModel> notifications;
  final bool newNotif;

  const NotificationLoadingSuccess(this.notifications, this.newNotif);

  @override
  List<Object> get props => [notifications];
}

class NotificationLoadingError extends NotificationState {
  final String error;

  const NotificationLoadingError(this.error);
  @override
  List<Object> get props => [error];
}
