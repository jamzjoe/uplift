import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/intentions_user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';

part 'same_intentions_suggestion_event.dart';
part 'same_intentions_suggestion_state.dart';

class SameIntentionsSuggestionBloc
    extends Bloc<SameIntentionsSuggestionEvent, SameIntentionsSuggestionState> {
  SameIntentionsSuggestionBloc() : super(SameIntentionsSuggestionInitial()) {
    on<SameIntentionsSuggestionEvent>((event, emit) {});

    on<FetchSameIntentionEvent>((event, emit) async {
      try {
        final data = await PrayerRequestRepository()
            .getSuggestedThatHaveSameIntentions(event.userID);
        emit(LoadingSameIntentionSuccess(data));
      } catch (e) {
        emit(const LoadingSameIntentionError());
      }
    });
  }
}
