part of 'feed_bloc.dart';

sealed class FeedEvent extends Equatable {
  const FeedEvent();
}

class FeedLoadPostEvent extends FeedEvent {
  @override
  List<Object?> get props => [];
}
