import 'package:clothes_shop_app/layout/app_layout.dart';
import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/modules/my_account/edit_profile_screen.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var userModel = AppCubit.get(context).userModel;
        return WillPopScope(
          onWillPop: ()
          async {
            navigateAndFinish(context, const AppLayout());
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
                                  navigateAndFinish(context, const AppLayout());
                                },
                                icon: const Icon(
                                    IconBroken.Arrow___Left,
                                    color: Colors.white,
                                )),
                            const Text(
                              'My Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 100,
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                color: Colors.white,
                              ),
                              child: MaterialButton(
                                onPressed: ()
                                {
                                  navigateTo(context, const EditProfileScreen());
                                },
                                child: const Text(
                                  'EDIT Profile',
                                  style: TextStyle(
                                      color: defaultColor,
                                      fontSize: 12
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20,)
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 46,
                                backgroundColor: Colors.white,
                                child:  CircleAvatar(
                                  radius: 45,
                                  backgroundImage:
                                  NetworkImage(
                                    '${userModel!.image}',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Text(
                                '${userModel.name}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.white
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Text(
                                userModel.email!.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
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
                        child: Column(
                          children:
                          [
                            const SizedBox(height: 30,),
                            buildItem(
                              icon: IconBroken.Shield_Done,
                              text: 'Manage Password',
                              onTap: ()
                              {},
                            ),
                            const SizedBox(height: 30,),
                            buildItem(
                              icon: IconBroken.Location,
                              text: 'Manage Address',
                              onTap: ()
                              {},
                            ),
                            const SizedBox(height: 30,),
                            buildItem(
                              icon: Icons.payment,
                              text: 'Update Payment',
                              onTap:()
                              {},
                            ),
                          ],
                        ),
                      )
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
  
  Widget buildItem({
    required IconData icon,
    required String text,
    required Function()? onTap
  })=> InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15
        ),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.all(
              Radius.circular(10)
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25
            ),
            child: Row(
              children:
              [
                Icon(
                  icon,
                  color: defaultColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    color: defaultColor,
                    fontSize: 17,
                  ),
                )
              ],
            ),
          ),
        ),
      )
  );
}
