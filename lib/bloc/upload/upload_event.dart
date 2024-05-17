part of 'upload_bloc.dart';

sealed class UploadEvent extends Equatable {
  const UploadEvent();
}

class UploadPostEvent extends UploadEvent {
  @override
  List<Object?> get props => [];
}

class UploadGalleryEvent extends UploadEvent {
  @override
  List<Object?> get props => [];
}

class UploadCameraEvent extends UploadEvent {
  @override
  List<Object?> get props => [];
}

class RemoveImageEvent extends UploadEvent{
  @override
  List<Object?> get props => [];
}
