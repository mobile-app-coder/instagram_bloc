import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../models/post_model.dart';
import '../../services/db_service.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  bool isLoading = false;

  List<Post> items = [];

  FeedBloc() : super(FeedInitial()) {
    on<FeedLoadPostEvent>(_apiLoadFeeds);
  }

  Future<void> _apiLoadFeeds(
      FeedLoadPostEvent event, Emitter<FeedState> emit) async {
    emit(FeedLoadingState());

    var result = await DBService.loadFeeds();
    items = result;
    emit(FeedLoadPostsState(result));
  }


}
