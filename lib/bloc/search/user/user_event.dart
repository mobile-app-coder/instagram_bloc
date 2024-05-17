part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();
}

class FollowEvent extends UserEvent {
  final Member member;

  const FollowEvent(this.member);

  @override
  List<Object?> get props => [];
}

class UnFollowEvent extends UserEvent {
  final Member member;

  const UnFollowEvent(this.member);

  @override
  List<Object?> get props => [];
}
