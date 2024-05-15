import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc_cubit/bloc/feed/feed_bloc.dart';

import '../../../models/member_model.dart';
import '../../../models/post_model.dart';
import '../../../services/db_service.dart';
import '../../../services/http_service.dart';
import '../../../services/utils_service.dart';

part 'post_item_event.dart';
part 'post_item_state.dart';

class PostItemBloc extends Bloc<PostItemEvent, PostItemState> {
  PostItemBloc() : super(PostItemInitial()) {
    on<LikePostEvent>(_apiPostLike);
    on<UnlikePostEvent>(_apiPostUnLike);
    on<RemovePostEvent>(_dialogRemovePost);
  }

  Future<void> _apiPostLike(
      LikePostEvent event, Emitter<PostItemState> emit) async {
    await DBService.likePost(event.post, true);
    event.post.liked = true;
    emit(LikePostState(event.post));
  }

  Future<void> _apiPostUnLike(
      UnlikePostEvent event, Emitter<PostItemState> emit) async {
    await DBService.likePost(event.post, false);

    event.post.liked = false;
    emit(UnLikePostState(event.post));

    var owner = await DBService.getOwner(event.post.uid);
    sendNotificationToFollowedMember(owner);
  }

  void sendNotificationToFollowedMember(Member someone) async {
    Member me = await DBService.loadMember();
    await Network.POST(Network.API_SEND_NOTIF, Network.NotifyLike(me, someone));
  }

  _dialogRemovePost(RemovePostEvent event, Emitter<PostItemState> emit) async {
    var result = await Utils.dialogCommon(
        event.context, "Instagram", "Do you want to delete this post?", false);
    emit(RemovePostState());

    if (result) {
      DBService.removePost(event.post).then(
          (value) => {event.context.read<FeedBloc>().add(FeedLoadPostEvent())});
    }
    emit(RemovePostState());
  }
}
