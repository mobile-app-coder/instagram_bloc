import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/post_model.dart';
import '../../services/db_service.dart';
import '../../services/file_service.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc() : super(UploadInitial()) {
    on<UploadPostEvent>(_onUploadPostEvent);
  }

  Future<void> _onUploadPostEvent(
      UploadPostEvent event, Emitter<UploadState> emit) async {
    emit(UploadLoadingState());

    var downloadUrl = await FileService.uploadPostImage(event.image);
    if (downloadUrl.isEmpty) {
      emit(UploadFailureState("Please try again later"));
    }

    Post post = Post(event.caption, downloadUrl);
    // Post to posts
    Post posted = await DBService.storePost(post);
    // Post to feeds
    await DBService.storeFeed(posted);
    emit(UploadSuccessState());
  }
}
