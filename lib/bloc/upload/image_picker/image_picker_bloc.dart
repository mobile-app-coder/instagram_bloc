

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  File? image;

  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<SelectedPhotoEvent>(_onSelectedPhotoEvent);
    on<ClearedPhotoEvent>(_onClearedPhotoEvent);
  }

  Future<void> _onSelectedPhotoEvent(
      SelectedPhotoEvent event, Emitter<ImagePickerState> emit) async {
    image = event.image;
    emit(SelectedPhotoState());
  }

  Future<void> _onClearedPhotoEvent(
      ClearedPhotoEvent event, Emitter<ImagePickerState> emit) async {
    image = null;
    emit(ClearedPhotoState());
  }
}
