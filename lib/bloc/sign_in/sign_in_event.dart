part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();
}

class SignInSignEvent extends SignInEvent {
  final BuildContext context;

  const SignInSignEvent(this.context);
  @override
  List<Object?> get props => [context];
}
