part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();
}

final class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class LoadUsers extends SearchState {
  final List<Member> users;

  const LoadUsers(this.users);

  @override
  List<Object?> get props => [users];
}
