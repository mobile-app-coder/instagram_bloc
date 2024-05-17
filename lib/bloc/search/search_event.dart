part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchUser extends SearchEvent {
  final String username;

  const SearchUser(this.username);

  @override
  List<Object?> get props => [username];
}
