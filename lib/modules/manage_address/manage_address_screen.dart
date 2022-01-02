import 'package:buildcondition/buildcondition.dart';
import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/models/address_model.dart';
import 'package:clothes_shop_app/modules/manage_address/add_new_address_screen.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageAddress extends StatelessWidget {
  const ManageAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<AddressModel> model = AppCubit.get(context).addresses;
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return WillPopScope(
          onWillPop: ()
          async {
            Navigator.pop(context);
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
                            },
                            icon: const Icon(
                              IconBroken.Arrow___Left,
                              color: Colors.white,
                            )),
                        const Text(
                          'Manage Address',
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
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          BuildCondition(
                            condition: model.isNotEmpty,
                            builder: (context) => ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => buildAddressItem(context, model[index], false),
                              separatorBuilder: (context, index) => const SizedBox(height: 10,),
                              itemCount: model.length,),
                            fallback: (context) => Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height*0.35,),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10
                                  ),
                                  child: Text(
                                      'You didn\'t add any address yet',
                                      style: TextStyle(
                                          color: defaultColor,
                                          fontSize: 17
                                      )),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          defaultButton(
                              function: ()
                              {
                                navigateTo(context, const AddNewAddressScreen());
                              },
                              text: 'add new address'
                          ),
                        ],
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
