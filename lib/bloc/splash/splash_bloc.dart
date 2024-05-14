import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc_cubit/bloc/sign_in/sign_in_bloc.dart';


import '../../pages/home_page.dart';
import '../../pages/signin_page.dart';
import '../../services/auth_service.dart';
import '../../services/log_service.dart';
import '../../services/notife_service.dart';
import '../../services/prefs_service.dart';
import '../home/home_cubit.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  SplashBloc() : super(SplashInitial()) {
    on<SplashCallEvent>(_callNextPage);
    on<SplashInitEvent>(_initNotification);
  }

  _callNextPage(SplashCallEvent event, Emitter<SplashState> emit) {
    emit(SplashInitial());
    Timer(const Duration(seconds: 3), () {
      if (AuthService.isLoggedIn()) {
        Navigator.of(event.context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return BlocProvider(
            create: (context) => HomeCubit(),
            child: const HomePage(),
          );
        }));
      } else {
        Navigator.of(event.context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return BlocProvider(
            create: (context) => SignInBloc(),
            child: const SignInPage(),
          );
        }));
      }
    });
  }

  _initNotification(SplashInitEvent event, Emitter<SplashState> emit) async {
    emit(SplashInitial());
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      LogService.i('User granted permission');
    } else {
      LogService.e('User declined or has not accepted permission');
    }

    _firebaseMessaging.getToken().then((value) async {
      String fcmToken = value.toString();
      Prefs.saveFCM(fcmToken);
      String token = await Prefs.loadFCM();
      LogService.i("FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String title = message.notification!.title.toString();
      String body = message.notification!.body.toString();
      LogService.i(title);
      LogService.i(body);
      LogService.i(message.data.toString());

      NotifyService().showLocalNotification(title, body);
    });
  }
}
