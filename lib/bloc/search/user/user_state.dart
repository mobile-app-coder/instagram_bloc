part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();
}

final class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class FollowedState extends UserState {
  @override
  List<Object?> get props => [];
}

class UnFollowedState extends UserState {
  @override
  List<Object?> get props => [];
}
