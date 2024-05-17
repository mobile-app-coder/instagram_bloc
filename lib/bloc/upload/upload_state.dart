part of 'upload_bloc.dart';

sealed class UploadState extends Equatable {
  const UploadState();
}

final class UploadInitial extends UploadState {
  @override
  List<Object> get props => [];
}

class UploadPostState extends UploadState {
  @override
  List<Object?> get props => [];
}
