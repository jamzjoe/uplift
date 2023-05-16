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
      try {
        final data = await commentRepository.fetchComments(event.postID);
        emit(LoadingEncouragesSuccess(data));
      } catch (e) {
        emit(const LoadingEncouragesError());
      }
    });

    
  }
}
