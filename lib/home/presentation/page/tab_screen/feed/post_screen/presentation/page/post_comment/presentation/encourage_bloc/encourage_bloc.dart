import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/payload_model.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/data/user_comment_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/domain/comment_repository.dart';
import 'package:uplift/utils/widgets/scroll_to_bottom.dart';
import 'package:uplift/utils/widgets/small_text.dart';

part 'encourage_event.dart';
part 'encourage_state.dart';

final CommentRepository commentRepository = CommentRepository();

class EncourageBloc extends Bloc<EncourageEvent, EncourageState> {
  EncourageBloc() : super(EncourageInitial()) {
    on<EncourageEvent>((event, emit) {});

    on<FetchEncourageEvent>((event, emit) async {
      emit(const LoadingEncourages());
      try {
        final data = await commentRepository.fetchComments(event.postID);
        data.sort((a, b) => a.commentModel.createdAt!
            .toDate()
            .compareTo(b.commentModel.createdAt!.toDate()));
        emit(LoadingEncouragesSuccess(data));
      } catch (e) {
        emit(LoadingEncouragesError(e.toString()));
      }
    });

    on<RefreshEncourageEvent>((event, emit) async {
      log('Running');
      try {
        final data = await commentRepository.fetchComments(event.postID);
        data.sort((a, b) => a.commentModel.createdAt!
            .toDate()
            .compareTo(b.commentModel.createdAt!.toDate()));
        if (data.length > 2) {
          UIServices().scrollToBottom(event.scrollController);
        }
        emit(LoadingEncouragesSuccess(data));
      } catch (e) {
        emit(LoadingEncouragesError(e.toString()));
      }
    });

    on<AddEncourageEvent>((event, emit) async {
      try {
        await commentRepository
            .addComment(event.postID, event.currentUser.userId!, event.comment)
            .then((value) {
          event.controller.clear();
          FocusScope.of(event.context).unfocus();
          ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
              content: SmallText(
                  text: 'Comment sent successfully!', color: whiteColor)));
        });
        if (event.currentUser.userId != event.postUserModel.userId) {
          final data = {
            "type": notificationType.comment.name,
            "post_id": event.postID,
            "post_user_id": event.postUserModel.userId
          };
          NotificationRepository.sendPushMessage(
              event.postUserModel.deviceToken!,
              '${event.currentUser.displayName} sent encouragement to your prayer intention.',
              'Uplift notification',
              'comment',
              jsonEncode(data).toString());
          NotificationRepository.addNotification(
              event.postUserModel.userId!,
              'Uplift notification',
              'sent encouragement to your prayer intention.',
              type: 'comment',
              payload: jsonEncode(data).toString());
        }

        // ignore: use_build_context_synchronously
        add(RefreshEncourageEvent(
            event.postID, event.context, event.scrollController));
      } catch (e) {
        log(e.toString());
        emit(LoadingEncouragesError(e.toString()));
      }
    });
  }
}
