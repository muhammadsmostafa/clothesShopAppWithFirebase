import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentPasswordController = TextEditingController();
    var newPasswordController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state)
      {
        if(state is AppChangePasswordSuccessState)
          {
            showToast(message: 'Updated Successfully');
            Navigator.pop(context);
            AppCubit.get(context).resetPasswordSuffixAndVisibility();
          }
      },
      builder: (context, state)
      {
        return WillPopScope(
          onWillPop: ()
          async {
            Navigator.pop(context);
            AppCubit.get(context).resetPasswordSuffixAndVisibility();
            return true;
          },
          child: SafeArea(
            child: Scaffold (
              backgroundColor: defaultColor,
              body: Column (
                children:
                [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children:
                      [
                        IconButton(
                            onPressed: ()
                            {
                              Navigator.pop(context);
                              AppCubit.get(context).resetPasswordSuffixAndVisibility();
                            },
                            icon: const Icon(
                              IconBroken.Arrow___Left,
                              color: Colors.white,
                            )),
                        const Text(
                          'Change Password',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  defaultFormField(
                                    controller: currentPasswordController,
                                    type: TextInputType.visiblePassword,
                                    validate: (String? value)
                                    {
                                      if (value!.isEmpty)
                                      {
                                        return 'password is too short';
                                      }
                                    },
                                    isPassword: AppCubit.get(context).isCurrentPassword,
                                    label: 'Current Password',
                                    prefix: IconBroken.Password,
                                    suffix: AppCubit.get(context).currentSuffix,
                                    suffixPressed: ()
                                    {
                                      AppCubit.get(context).changeCurrentPasswordVisibility();
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  defaultFormField(
                                    controller: newPasswordController,
                                    type: TextInputType.visiblePassword,
                                    validate: (String? value)
                                    {
                                      if(currentPasswordController.text==value)
                                        {
                                          return 'you are using the same password';
                                        }
                                      if (value!.isEmpty)
                                      {
                                        return 'password is too short';
                                      }
                                    },
                                    isPassword: AppCubit.get(context).isNewPassword,
                                    label: 'New Password',
                                    prefix: IconBroken.Password,
                                    suffix: AppCubit.get(context).newSuffix,
                                    suffixPressed: ()
                                    {
                                      AppCubit.get(context).changeNewPasswordVisibility();
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  defaultFormField(
                                    controller: confirmPasswordController,
                                    type: TextInputType.visiblePassword,
                                    validate: (String? value)
                                    {
                                      if (value!.isEmpty)
                                      {
                                        return 'you should confirm your password';
                                      }
                                      if (newPasswordController.text!=value)
                                      {
                                        return 'password not match';
                                      }
                                    },
                                    onSubmit: (value)
                                    {
                                      if(formKey.currentState!.validate())
                                      {
                                        AppCubit.get(context).changePassword(
                                            currentPassword: currentPasswordController.text ,
                                            newPassword: newPasswordController.text
                                        );
                                      }
                                    },
                                    isPassword: AppCubit.get(context).isConfirmPassword,
                                    label: 'Confirm password',
                                    prefix: IconBroken.Password,
                                    suffix: AppCubit.get(context).suffixConfirm,
                                    suffixPressed: ()
                                    {
                                      AppCubit.get(context).changeConfirmPasswordVisibility();
                                    },
                                  ),
                                  const SizedBox(height: 20,),
                                  defaultButton(
                                      function: ()
                                      {
                                        if(formKey.currentState!.validate())
                                        {
                                          AppCubit.get(context).changePassword(
                                              currentPassword: currentPasswordController.text ,
                                              newPassword: newPasswordController.text
                                          );
                                        }
                                      },
                                      text: state is AppChangePasswordLoadingState
                                          ?
                                      'Changing Password ...'
                                          :
                                      'Change Password'
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
