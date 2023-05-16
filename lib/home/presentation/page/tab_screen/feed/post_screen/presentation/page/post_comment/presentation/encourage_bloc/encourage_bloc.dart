import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/data/user_comment_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/domain/comment_repository.dart';

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
        emit(const LoadingEncouragesError());
      }
    });

    on<RefreshEncourageEvent>((event, emit) async {
      log('Running');
      try {
        final data = await commentRepository.fetchComments(event.postID);
        data.sort((a, b) => a.commentModel.createdAt!
            .toDate()
            .compareTo(b.commentModel.createdAt!.toDate()));
        emit(LoadingEncouragesSuccess(data));
      } catch (e) {
        emit(const LoadingEncouragesError());
      }
    });

    on<AddEncourageEvent>((event, emitas) async {
      try {
        await commentRepository.addComment(
            event.postID, event.userID, event.comment);
        add(RefreshEncourageEvent(event.postID));
      } catch (e) {
        // ignore: invalid_use_of_visible_for_testing_member
        emit(const LoadingEncouragesError());
      }
    });
  }
}
