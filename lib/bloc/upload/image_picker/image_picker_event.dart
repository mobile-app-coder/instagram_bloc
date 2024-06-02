part of 'image_picker_bloc.dart';

sealed class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();
}

class SelectedPhotoEvent extends ImagePickerEvent {
  final File image;

  const SelectedPhotoEvent({required this.image});

  @override
  List<Object> get props => [image];
}

class ClearedPhotoEvent extends ImagePickerEvent {
  @override
  List<Object> get props => [];
}
