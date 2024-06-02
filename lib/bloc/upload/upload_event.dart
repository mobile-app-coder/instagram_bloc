part of 'upload_bloc.dart';

sealed class UploadEvent extends Equatable {
  const UploadEvent();
}

class UploadPostEvent extends UploadEvent {
  final String caption;
  final File image;

  const UploadPostEvent({required this.caption, required this.image});

  @override
  List<Object> get props => [];
}
