import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAdminScreen extends StatelessWidget {
  const AddAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state)
      {
        if(state is AppAddAdminsSuccessState)
          {
            showToast(message: 'Added Successfully');
            emailController.clear();
          }
        if(state is AppAddAdminsErrorState)
          {
            showToast(message: 'Check email address and try again', time: 10);
          }
      },
      builder: (context, state)
      {
        return SafeArea(
          child: Scaffold (
            backgroundColor: defaultColor,
            body: Column (
              children:
              [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Row(
                    children:
                    [
                      IconButton(
                          onPressed: ()
                          {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            IconBroken.Arrow___Left,
                            color: Colors.white,
                          )),
                      const Text(
                        'ADMINISTRATOR',
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
                          const SizedBox(height: 30,),
                          const Text(
                            'ADD ADMIN',
                            style: TextStyle(
                                color: defaultColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                defaultFormField(
                                  controller: emailController,
                                  type: TextInputType.emailAddress,
                                  validate: (String? value)
                                  {
                                    if (value!.isEmpty)
                                    {
                                      return 'please enter his email address';
                                    }
                                  },
                                  label: 'Email Address',
                                  prefix: IconBroken.Message,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                defaultButton(
                                    function: ()
                                    {
                                      if(formKey.currentState!.validate())
                                      {
                                        AppCubit.get(context).addAdmin(email: emailController.text);
                                      }
                                    },
                                    text: state is AppAddAdminsLoadingState
                                    ?
                                    'Adding Admin ...'
                                    :'Add Admin'
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
        );
      },
    );
  }
}