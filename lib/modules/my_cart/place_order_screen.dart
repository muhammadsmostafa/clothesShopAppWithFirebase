import 'package:clothes_shop_app/layout/app_layout.dart';
import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/models/address_model.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceOrderScreen extends StatelessWidget {
  AddressModel model;
  PlaceOrderScreen({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state)
      {
        if(state is AppPlaceOrderSuccessState)
          {
            showDialog(
                context: context,
                builder: (context)
                {
                  return AlertDialog(
                    title: const Icon(
                      Icons.done,
                      size: 30,
                      color: defaultColor,
                    ),
                    content: const Text('Your Order Successfully Placed'),
                    actions:
                    [
                      defaultTextButton(
                          function: ()
                          {
                            navigateAndFinish(context, const AppLayout());
                          },
                          text: 'Done'
                      )
                    ],
                  );
                }
            );
          }
      },
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
                              AppCubit.get(context).resetPasswordSuffixAndVisibility();
                            },
                            icon: const Icon(
                              IconBroken.Arrow___Left,
                              color: Colors.white,
                            )),
                        const Text(
                          'My Cart',
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
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                  child: Text(
                                      'Address Details',
                                    style: TextStyle(
                                        color: defaultColor,
                                        fontSize: 20,
                                    ),
                                  )
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Area : ''${model.area}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Street Name : ''${model.streetName}',
                                      style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Building Name/Number : ''${model.buildingName}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Floor Number : ''${model.floorNumber}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Apartment Number : ''${model.apartmentNumber}',
                                      style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16
                                   ),
                             ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Phone Number : ''${model.phoneNumber}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Center(
                                child: Text(
                                  'You Will Pay ${AppCubit.get(context).totalPriceOfCartItems.round()+20} EGP',
                                  style: const TextStyle(
                                    color: defaultColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Center(
                                child: defaultButton(
                                    function: ()
                                    {
                                      AppCubit.get(context).placeOrder(model: model, totalPrice: AppCubit.get(context).totalPriceOfCartItems.round()+20);
                                    },
                                    text: state is AppPlaceOrderLoadingState
                                    ?
                                    'Placing Order ...'
                                    :
                                    'Place order'
                                ),
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
          ),
        );
      },
    );
  }
}
