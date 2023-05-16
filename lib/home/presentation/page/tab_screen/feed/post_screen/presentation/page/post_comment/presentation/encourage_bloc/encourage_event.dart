part of 'encourage_bloc.dart';

abstract class EncourageEvent extends Equatable {
  const EncourageEvent();
}

class FetchEncourageEvent extends EncourageEvent {
  final String postID;

  const FetchEncourageEvent(this.postID);
  
  @override
  List<Object?> get props => [postID];
}
