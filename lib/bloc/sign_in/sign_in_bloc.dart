import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../pages/home_page.dart';
import '../../services/auth_service.dart';
import '../../services/prefs_service.dart';
import '../../services/utils_service.dart';
import '../home/home_cubit.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  var isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  SignInBloc() : super(SignInInitial()) {
    on<SignInSignEvent>(_signIn);
  }

  Future<void> _signIn(SignInSignEvent event, Emitter<SignInState> emit) async {
    emit(SignInInitial());
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;

    emit(SignInLoadingState());
    isLoading = true;

    var user = await AuthService.signInUser(event.context, email, password);

    isLoading = false;
    emit(SignedInState());
    if (user != null) {
      await Prefs.saveUserId(user.uid);
      _callHomePage(event.context);
    } else {
      Utils.fireToast("Check your email or password");
    }
  }

  _callHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return BlocProvider(
        create: (context) => HomeCubit(),
        child: HomePage(),
      );
    }));
  }
}
