import 'package:clothes_shop_app/layout/app_layout.dart';
import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/models/user_model.dart';
import 'package:clothes_shop_app/modules/administration/add_admin_screen.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdministrationScreen extends StatelessWidget {
  const AdministrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state)
      {
        if(state is AppDeleteAdminsSuccessState)
          {
            showToast(message: 'Deleted Successfully');
          }
      },
      builder: (context, state)
      {
        return SafeArea(
          child: Scaffold (
            backgroundColor: defaultColor,
            body: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Row(
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
                        'Administration',
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 30
                              ),
                              child: Center(
                                child: Text(
                                  'ADMINS',
                                  style: TextStyle(
                                      color: defaultColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => buildAdminItem(context, AppCubit.get(context).admins[index]),
                                separatorBuilder: (context, index) => myDivider(),
                                itemCount: AppCubit.get(context).admins.length
                            ),
                            const SizedBox(height: 20,),
                            defaultButton(
                                function: ()
                                {
                                  navigateTo(context, const AddAdminScreen());
                                },
                                text: 'Add Admin'
                            ),
                          ],
                        ),
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

  Widget buildAdminItem(context, UserModel model) => Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      children:
      [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${model.name}',
              style: const TextStyle(
                  color: defaultColor,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${model.email}',
              style: const TextStyle(
                  color: defaultColor
              ),
            ),
          ],
        ),
        const Spacer(),
        defaultTextButton(
            function: ()
            {
              showDialog(
                  context: context,
                  builder: (context)
                  {
                    return AlertDialog(
                      title: const Text('Removing admin'),
                      content: const Text('Are you really want to remove him ?'),
                      actions:
                      [
                        defaultTextButton(
                            function: ()
                            {
                              Navigator.pop(context);
                            },
                            text: 'Cancel'
                        ),
                        defaultTextButton(
                            function: ()
                            {
                              Navigator.pop(context);
                              AppCubit.get(context).removeAdmin(
                                  userId: '${model.uId}'
                              );
                            },
                            text: 'Yes'
                        )
                      ],
                    );
                  }
              );
            },
            text: 'Remove'
        )
      ],
    ),
  );
}
