import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class HomeState extends Equatable {}

class HomeInitialState extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class HomePageChangeState extends HomeState {
  final int currentPage;
  final PageController pageController;

  HomePageChangeState(this.currentPage, this.pageController);

  @override
  List<Object?> get props => [currentPage, pageController];
}
