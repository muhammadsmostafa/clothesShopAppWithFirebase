import 'package:bloc/bloc.dart';
import 'package:clothes_shop_app/models/user_model.dart';
import 'package:clothes_shop_app/modules/register/cubit/states.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit <RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);

  Future<void> userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  })
  async {
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value){
      emit(RegisterSuccessState());
      userCreate(
          name: name,
          email: email,
          password: password,
          phone: phone,
          uId: value.user!.uid
      );
    }).catchError((error){
      if(error.code == 'weak-password')
      {
        showToast(message: 'Password Weak');
      } else if(error.code == 'email-already-in-use')
      {
        showToast(message: 'This Email Already Used');
      }
      emit(RegisterErrorState());
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String uId,
  })
  {
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image: '',
      admin: false
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap()).then((value){}
    ).catchError((error)
    {
      emit(CreateUserErrorState());
    });
  }

  IconData suffix = IconBroken.Shield_Done;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? IconBroken.Shield_Done : IconBroken.Shield_Fail;
    emit(RegisterChangePasswordVisibilityState());
  }

  IconData suffixConfirm = IconBroken.Shield_Done;
  bool isConfirmPassword = true;

  void changeConfirmPasswordVisibility()
  {
    isConfirmPassword = !isConfirmPassword;
    suffixConfirm = isConfirmPassword ? IconBroken.Shield_Done : IconBroken.Shield_Fail;
    emit(RegisterChangePasswordVisibilityState());
  }
}