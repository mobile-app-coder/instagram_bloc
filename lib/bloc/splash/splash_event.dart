part of 'splash_bloc.dart';

sealed class SplashEvent extends Equatable {
  const SplashEvent();
}

class SplashCallEvent extends SplashEvent {
  final BuildContext context;

  @override
  List<Object?> get props => [context];

  const SplashCallEvent(this.context);
}

class SplashInitEvent extends SplashEvent{
  @override
  List<Object?> get props => [];

}
