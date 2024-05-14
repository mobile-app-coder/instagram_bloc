part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();
}

final class SignInInitial extends SignInState {
  @override
  List<Object> get props => [];
}

class SignInErrorState extends SignInState {
  final String message;

  const SignInErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class SignedInState extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInLoadingState extends SignInState {
  @override
  List<Object?> get props => [];
}
