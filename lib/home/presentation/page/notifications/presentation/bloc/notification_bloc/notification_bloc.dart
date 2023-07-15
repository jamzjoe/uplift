import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/user_notif_model.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

final NotificationRepository notificationRepository = NotificationRepository();

final userID = FirebaseAuth.instance.currentUser!.uid;

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      streamSubscription;

  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) {});

    streamSubscription = FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .collection('notifications')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> event) {
      add(FetchListOfNotification(userID));
    });

    on<FetchListOfNotification>((event, emit) async {
      try {
        final data =
            await notificationRepository.retrieveNotifications(event.userID);
        emit(NotificationLoadingSuccess(data, false));
      } catch (e) {
        log(e.toString());
        emit(NotificationLoadingError('Fetch error ${e.toString()}'));
      }
    });

    on<RefreshListOfNotification>((event, emit) async {
      emit(NotificationLoading());
      try {
        final data =
            await notificationRepository.retrieveNotifications(event.userID);
        emit(NotificationLoadingSuccess(data, false));
      } catch (e) {
        emit(const NotificationLoadingError('Refresh error'));
      }
    });

    on<ClearNotification>((event, emit) async {
      try {
        notificationRepository.deleteAllNotifications(event.userID);

        add(RefreshListOfNotification(userID, false));
      } catch (e) {
        emit(const NotificationLoadingError('Clear error'));
      }
    });

    on<MarkAllAsRead>((event, emit) async {
      try {
        notificationRepository.markAllAsRead(event.userID);
        add(RefreshListOfNotification(userID, false));
      } catch (e) {
        emit(NotificationLoadingError(e.toString()));
      }
    });

    on<MarkOneAsRead>((event, emit) async {
      try {
        notificationRepository.markAsRead(event.userID, event.notificationID);
      } catch (e) {
        emit(NotificationLoadingError(e.toString()));
      }
    });

    on<DeleteOneNotif>((event, emit) async {
      try {
        notificationRepository.deleteNotification(
            event.userID, event.notificationID);
      } catch (e) {
        emit(NotificationLoadingError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    streamSubscription.cancel(); // Cancel the stream subscription
    return super.close();
  }
}
