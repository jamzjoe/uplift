import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/user_notif_model.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';

part 'notification_event.dart';
part 'notification_state.dart';

final NotificationRepository notificationRepository = NotificationRepository();

late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    streamSubscription;

final userID = FirebaseAuth.instance.currentUser!.uid;

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) {});

    streamSubscription = FirebaseFirestore.instance
        .collection('Notifications')
        .snapshots()
        .listen((event) async {
      final userID = await AuthServices.userID();
      add(FetchListOfNotification(userID.toString(), true));
    });

    on<FetchListOfNotification>((event, emit) async {
      try {
        final data =
            await notificationRepository.getUserNotifications(event.userID);
        emit(NotificationLoadingSuccess(data, false));
      } catch (e) {
        log(e.toString());
        emit(NotificationLoadingError());
      }
    });

    on<RefreshListOfNotification>((event, emit) async {
      emit(NotificationLoading());
      try {
        final data =
            await notificationRepository.getUserNotifications(event.userID);
        emit(NotificationLoadingSuccess(data, false));
      } catch (e) {
        emit(NotificationLoadingError());
      }
    });

    on<ClearNotification>((event, emit) async {
      try {
        for (var each in event.notificationList) {
          NotificationRepository.delete(each.notificationModel.notificationId!);
        }
      } catch (e) {
        emit(NotificationLoadingError());
      }
    });

    on<MarkAllAsRead>((event, emit) async {
      try {
        for (var each in event.notificationList) {
          NotificationRepository.markAsRead(
              each.notificationModel.notificationId!);
        }
      } catch (e) {
        emit(NotificationLoadingError());
      }
    });
  }
}
