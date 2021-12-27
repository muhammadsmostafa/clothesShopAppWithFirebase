import 'package:clothes_shop_app/layout/app_layout.dart';
import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/modules/register/cubit/states.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/components/constants.dart';
import 'package:clothes_shop_app/shared/network/local/cashe_helper.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state)
        {
          if(state is RegisterSuccessState)
          {
            uId = FirebaseAuth.instance.currentUser!.uid;
            CasheHelper.saveData(
              key: 'uId',
              value: FirebaseAuth.instance.currentUser!.uid,
            ).then((value) async {
              AppCubit.get(context).getUserData();
              AppCubit.get(context).getProducts();
              navigateAndFinish(
                  context,
                  const AppLayout()
              );
            });
          }
        },
        builder: (context, state)
        {
          return Scaffold(
            backgroundColor: defaultColor,
            body: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    const [
                      CircleAvatar(
                        child: Center(
                          child: Text(
                            'C',
                            style: TextStyle(
                                fontSize: 33,
                                color: defaultColor,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        radius: 30,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          'Clothes Market',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )
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
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(
                                  20
                              ),
                              child: Center(
                                child: Text(
                                  'REGISTER',
                                  style: TextStyle(
                                      color: defaultColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            defaultFormField(
                              controller: nameController,
                              type: TextInputType.name,
                              validate: (String? value)
                              {
                                if (value!.isEmpty)
                                {
                                  return 'please enter your name address';
                                }
                              },
                              label: 'Name',
                              prefix: IconBroken.Profile,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            defaultFormField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validate: (String? value)
                              {
                                if (value!.isEmpty)
                                {
                                  return 'please enter your email address';
                                }
                              },
                              label: 'Email Address',
                              prefix: IconBroken.Message,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            defaultFormField(
                              controller: phoneController,
                              type: TextInputType.phone,
                              validate: (String? value)
                              {
                                if (value!.isEmpty)
                                {
                                  return 'please enter your phone address';
                                }
                              },
                              label: 'Phone Number',
                              prefix: IconBroken.Call,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            defaultFormField(
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              validate: (String? value)
                              {
                                if (value!.isEmpty)
                                {
                                  return 'password is too short';
                                }
                              },
                              isPassword: RegisterCubit.get(context).isPassword,
                              label: 'Password',
                              prefix: IconBroken.Password,
                              suffix: RegisterCubit.get(context).suffix,
                              suffixPressed: ()
                              {
                                RegisterCubit.get(context).changePasswordVisibility();
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
                                if (passwordController.text!=value)
                                {
                                  return 'password not match';
                                }
                              },
                              onSubmit: (value)
                              {
                                if(formKey.currentState!.validate())
                                {
                                  RegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              isPassword: RegisterCubit.get(context).isConfirmPassword,
                              label: 'Confirm password',
                              prefix: IconBroken.Password,
                              suffix: RegisterCubit.get(context).suffixConfirm,
                              suffixPressed: ()
                              {
                                RegisterCubit.get(context).changeConfirmPasswordVisibility();
                              },

                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            state is RegisterLoadingState
                                ?
                            const Center(child: CircularProgressIndicator())
                                :
                            defaultButton(
                              function: () {
                                if(formKey.currentState!.validate())
                                {
                                  RegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              text: 'register',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
