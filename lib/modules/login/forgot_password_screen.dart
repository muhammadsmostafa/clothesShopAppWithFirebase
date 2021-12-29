import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context, state) {},
        builder: (context, state)
        {
          return Scaffold (
            backgroundColor: defaultColor,
            body: Column (
              children:
              [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: defaultColor,
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
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 30,
                                bottom: MediaQuery.of(context).size.height*0.13,
                            ),
                            child: const Center(
                              child: Text(
                                'FORGOT PASSWORD',
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
                          Center(
                                child: defaultButton(
                                    function: ()
                                    {
                                      if(formKey.currentState!.validate())
                                      {
                                        LoginCubit.get(context)
                                            .userForgotPassword(
                                            email: emailController.text);
                                        Navigator.pop(context);
                                        showToast(
                                            message:
                                            'We send password change link to you email address, reset your password and login',
                                            time: 10
                                        );
                                      }
                                    },
                                    text: 'Send'
                                ),
                              )
                        ],
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
