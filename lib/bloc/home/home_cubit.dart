import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import 'home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  PageController? pageController;
  int currentPage = 0;

  Future onPageChange(int index) async {
    currentPage = index;
    emit(HomePageChangeState(currentPage, pageController!));
  }

  Future onTabChanged(int index) async {
    currentPage = index;
    pageController!.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    emit(HomePageChangeState(currentPage, pageController!));
  }
}
