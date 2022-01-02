import 'package:clothes_shop_app/layout/app_layout.dart';
import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/modules/login/forgot_password_screen.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/components/constants.dart';
import 'package:clothes_shop_app/shared/network/local/cashe_helper.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context, state)
        {
          {
            if(state is LoginSuccessState)
            {
              uId = state.uId;
              CasheHelper.saveData(
                key: 'uId',
                value: state.uId,
              ).then((value)
              {
                AppCubit.get(context).getUserData();
                AppCubit.get(context).getProducts();
                AppCubit.get(context).getFavorites();
                AppCubit.get(context).getCart();
                AppCubit.get(context).getAdmins();
                AppCubit.get(context).getAddresses();
                showToast(
                  message: 'Login Successfully',
                );
                navigateAndFinish(
                  context,
                  const AppLayout(),
                );
              });
            }
          }
        },
        builder: (context, state)
        {
          return Scaffold (
            backgroundColor: defaultColor,
            body: Column (
              children:
              [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
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
                                  'SIGN IN',
                                  style: TextStyle(
                                      color: defaultColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
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
                              height: 20,
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
                              onSubmit: (value)
                              {
                                if(formKey.currentState!.validate())
                                {
                                  LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              isPassword: LoginCubit.get(context).isPassword,
                              label: 'Password',
                              prefix: IconBroken.Password,
                              suffix: LoginCubit.get(context).suffix,
                              suffixPressed: ()
                              {
                                LoginCubit.get(context).changePasswordVisibility();
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                                child: defaultButton(
                                    function: ()
                                    {
                                      if(formKey.currentState!.validate())
                                      {
                                        LoginCubit.get(context).userLogin(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                      }
                                    },
                                    text: state is LoginLoadingState ? 'signing in ...' : 'sign in'
                                )
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            defaultTextButton(
                                function: ()
                                {
                                  navigateTo(context, const ForgotPasswordScreen());
                                },
                                text: 'Forgot Password?'
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
