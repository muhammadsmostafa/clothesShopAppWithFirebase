import 'package:bloc/bloc.dart';
import 'package:clothes_shop_app/modules/login/cubit/states.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  })
  {
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value){
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      if (error.code == 'wrong-password') {
        showToast(message: 'Password Wrong');
      } else if (error.code == 'user-not-found') {
        showToast(message: 'No User Found With This Email');
      }
      emit(LoginErrorState());
    });
  }

  void userForgotPassword({
  required String email
  })
  {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value){
      emit(LoginSendEmailResetPasswordSuccessState());
    });
  }

  IconData suffix = IconBroken.Shield_Done;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword =! isPassword;
    suffix = isPassword ? IconBroken.Shield_Done : IconBroken.Shield_Fail;
    emit(LoginChangePasswordVisibilityState());
  }
}