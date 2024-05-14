part of 'feed_bloc.dart';

@immutable
sealed class FeedState extends Equatable {
  const FeedState();
}

final class FeedInitial extends FeedState {
  @override
  List<Object> get props => [];
}

class FeedLoadPostsState extends FeedState {
  final List<Post> posts;

  const FeedLoadPostsState(this.posts);

  @override
  List<Object?> get props => [posts];
}

class FeedErrorState extends FeedState {
  final String message;

  const FeedErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class FeedLoadingState extends FeedState {
  @override
  List<Object?> get props => [];
}
