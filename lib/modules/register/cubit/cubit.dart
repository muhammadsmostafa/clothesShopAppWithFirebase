import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:clothes_shop_app/models/user_model.dart';
import 'package:clothes_shop_app/modules/register/cubit/states.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
    registeringAccount = true;
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value){
      emit(RegisterSuccessState());
      uploadProfileImage(
          name: name,
          email: email,
          phone: phone,
          uId: value.user!.uid,
      );
    }).catchError((error){
      registeringAccount = false;
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
    required String image,
    required String phone,
    required String uId,
  })
  {
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image: image,
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
    registeringAccount = true;
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

  var picker = ImagePicker();
  Future<void> getProfileImage() async {
    var pickedFile = await picker.pickImage(
        source: ImageSource.gallery
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      emit(ProfileImagePickedErrorState());
    }
  }


  File? profileImage;
  void removeProfileImage() {
    profileImage = null;
    emit(RemoveProfileImageSuccessState());
  }

  bool registeringAccount = false;
  void uploadProfileImage({
    required String name,
    required String phone,
    required String email,
    required String uId,
  }) {
    emit(UploadProfileImagePickedLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref().
    child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
        emit(UploadProfileImagePickedSuccessState());
        userCreate(
            name: name,
            email: email,
            phone: phone,
            uId: uId,
            image: value
        );
      });
    }).catchError((error){
      registeringAccount = false;
      emit(UploadProfileImagePickedErrorState());
    });
  }
}