part of 'post_item_bloc.dart';

sealed class PostItemState extends Equatable {
  const PostItemState();
}

final class PostItemInitial extends PostItemState {
  @override
  List<Object> get props => [];
}

class LikePostState extends PostItemState {
  final Post post;

  const LikePostState(this.post);

  @override
  List<Object?> get props => [post];
}

class UnLikePostState extends PostItemState {
  final Post post;

  const UnLikePostState(this.post);

  @override
  List<Object?> get props => [post];
}

class RemovePostState extends PostItemState {
  @override
  List<Object?> get props => [];
}
