import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../models/member_model.dart';
import '../../services/db_service.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  var searchController = TextEditingController();

  List<Member> items = [];

  SearchBloc() : super(SearchInitial()) {
    on<SearchUser>(_apiSearchMembers);
  }

  Future<void> _apiSearchMembers(
      SearchUser event, Emitter<SearchState> emit) async {
    emit(SearchInitial());
    var result = await DBService.searchMembers(event.username);
    items = result;
    emit(LoadUsers(items));
  }
}
