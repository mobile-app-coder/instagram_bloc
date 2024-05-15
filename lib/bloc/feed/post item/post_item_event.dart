part of 'post_item_bloc.dart';

sealed class PostItemEvent extends Equatable {
  const PostItemEvent();
}

class LikePostEvent extends PostItemEvent {
  final Post post;

  const LikePostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

class UnlikePostEvent extends PostItemEvent {
  final Post post;

  const UnlikePostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

class RemovePostEvent extends PostItemEvent {
  final Post post;
  final BuildContext context;

  const RemovePostEvent(this.post, this.context);

  @override
  List<Object?> get props => [post, context];
}
