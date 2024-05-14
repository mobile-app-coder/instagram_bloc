import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../models/member_model.dart';
import '../../models/post_model.dart';
import '../../services/db_service.dart';
import '../../services/http_service.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  bool isLoading = false;

  List<Post> items = [];

  FeedBloc() : super(FeedInitial()) {
    on<FeedLoadPostEvent>(_apiLoadFeeds);
  }

  Future<void> _apiPostLike(Post post) async {
    isLoading = true;

    await DBService.likePost(post, true);
    isLoading = false;
    post.liked = true;
  }

  Future<void> _apiLoadFeeds(
      FeedLoadPostEvent event, Emitter<FeedState> emit) async {
    emit(FeedLoadingState());

    var result = await DBService.loadFeeds();
    items = result;
    emit(FeedLoadPostsState(result));
  }

  void _apiPostUnLike(Post post) async {
    isLoading = true;

    await DBService.likePost(post, false);

    isLoading = false;
    post.liked = false;

    var owner = await DBService.getOwner(post.uid);
    sendNotificationToFollowedMember(owner);
  }

  void sendNotificationToFollowedMember(Member someone) async {
    Member me = await DBService.loadMember();
    await Network.POST(Network.API_SEND_NOTIF, Network.NotifyLike(me, someone));
  }

// _dialogRemovePost(Post post,) async {
//   var result = await Utils.dialogCommon(
//       context, "Instagram", "Do you want to detele this post?", false);
//
//   if (result) {
//
//       isLoading = true;
//
//     DBService.removePost(post).then((value) => {
//       _apiLoadFeeds(),
//     });
//   }
// }
}
