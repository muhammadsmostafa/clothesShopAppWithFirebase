import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state)
      {
        if(state is AppUpdateAccountSuccessState)
          {
            showToast(message: 'updated successfully' , time: 10);
            AppCubit.get(context).getUserData();
          }
      },
      builder: (context, state)
      {
        var profileImage = AppCubit.get(context).profileImage;
        var userModel = AppCubit.get(context).userModel;
        nameController.text = userModel!.name!;
        phoneController.text =userModel.phone!;
        return WillPopScope(
          onWillPop: ()
          async {
            Navigator.pop(context);
            AppCubit.get(context).removeProfileImage();
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
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      children:
                      [
                        Row(
                          children:
                          [
                            IconButton(
                                onPressed: ()
                                {
                                  Navigator.pop(context);
                                  AppCubit.get(context).removeProfileImage();
                                },
                                icon: const Icon(
                                  IconBroken.Arrow___Left,
                                  color: Colors.white,
                                )),
                            const Text(
                              'Edit Profile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  profileImage == null
                                  ?
                                  CircleAvatar(
                                    radius: 122,
                                    backgroundColor: Colors.white,
                                    child:  CircleAvatar(
                                      radius: 120,
                                      backgroundImage:
                                      NetworkImage(
                                        '${userModel.image}',
                                      ),
                                    ),
                                  )
                                  :
                                  Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      CircleAvatar(
                                        radius: 122,
                                        backgroundColor: Colors.white,
                                        child:  CircleAvatar(
                                          radius: 120,
                                          backgroundImage: FileImage(profileImage),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: ()
                                        {
                                          AppCubit.get(context).removeProfileImage();
                                        },
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: ()
                                    {
                                      AppCubit.get(context).getProfileImage();
                                    },
                                    icon: const Icon(
                                        IconBroken.Camera,
                                    ),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
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
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
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
                                const SizedBox(height: 30,),
                                defaultButton(
                                  function: () {
                                    if(formKey.currentState!.validate())
                                    {
                                      if(profileImage==null)
                                        {
                                          AppCubit.get(context).updateAccount(
                                              name: nameController.text,
                                              phone: phoneController.text
                                          );
                                        }
                                      else
                                      {
                                        AppCubit.get(context).uploadProfileImage(
                                            name: nameController.text,
                                            phone: phoneController.text
                                        );
                                      }
                                    }
                                  },
                                  text: AppCubit.get(context).updatingAccount ? 'updating ...' : 'update',
                                ),
                              ],
                            ),
                          ),
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
