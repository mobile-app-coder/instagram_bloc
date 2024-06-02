part of 'upload_bloc.dart';

sealed class UploadState {
  const UploadState();
}

final class UploadInitial extends UploadState {}

class UploadLoadingState extends UploadState {}

class UploadSuccessState extends UploadState {}

class UploadFailureState extends UploadState {
  final String errorMessage;

  UploadFailureState(this.errorMessage);
}
