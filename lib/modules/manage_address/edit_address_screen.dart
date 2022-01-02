import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/models/address_model.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditAddressScreen extends StatelessWidget {
  AddressModel model;
  EditAddressScreen({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var areaController = TextEditingController();
    var streetNameController = TextEditingController();
    var buildingNameOrNumberController = TextEditingController();
    var floorNumberController = TextEditingController();
    var apartmentNumberController = TextEditingController();
    var phoneController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    areaController.text = model.area!;
    streetNameController.text = model.streetName!;
    buildingNameOrNumberController.text = model.buildingName!;
    floorNumberController.text = model.floorNumber!;
    apartmentNumberController.text = model.apartmentNumber!;
    phoneController.text = model.phoneNumber!;
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state)
      {
        if(state is AppDeleteAddressSuccessState)
          {
            showToast(message: 'Deleted Successfully');
            Navigator.pop(context);
          }
        if(state is AppUpdateAddressSuccessState)
        {
          showToast(message: 'Updated Successfully');
          Navigator.pop(context);
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 40
                            ),
                            child: Column(
                              children: [
                                defaultFormField(
                                    controller: areaController,
                                    type: TextInputType.text,
                                    validate: (String? value)
                                    {
                                      if (value!.isEmpty)
                                      {
                                        return 'you should enter your area';
                                      }
                                    },
                                    label: 'Area',
                                    prefix: IconBroken.Location
                                ),
                                const SizedBox(height: 20,),
                                defaultFormField(
                                    controller: streetNameController,
                                    type: TextInputType.text,
                                    validate: (String? value)
                                    {
                                      if (value!.isEmpty)
                                      {
                                        return 'you should enter your street name';
                                      }
                                    },
                                    label: 'Street Name',
                                    prefix: Icons.streetview
                                ),
                                const SizedBox(height: 20,),
                                defaultFormField(
                                    controller: buildingNameOrNumberController,
                                    type: TextInputType.text,
                                    validate: (String? value)
                                    {
                                      if (value!.isEmpty)
                                      {
                                        return 'you should enter your building name/number';
                                      }
                                    },
                                    label: 'Building name/number',
                                    prefix: IconBroken.Home
                                ),
                                const SizedBox(height: 20,),
                                defaultFormField(
                                    controller: floorNumberController,
                                    type: TextInputType.number,
                                    validate: (String? value)
                                    {
                                      if (value!.isEmpty)
                                      {
                                        return 'you should enter your floor number';
                                      }
                                    },
                                    label: 'Floor Number',
                                    prefix: Icons.door_front_door_outlined
                                ),
                                const SizedBox(height: 20,),
                                defaultFormField(
                                    controller: apartmentNumberController,
                                    type: TextInputType.number,
                                    validate: (String? value)
                                    {
                                      if (value!.isEmpty)
                                      {
                                        return 'you should enter your apartment number';
                                      }
                                    },
                                    label: 'Apartment Number',
                                    prefix: Icons.door_front_door_outlined
                                ),
                                const SizedBox(height: 20,),
                                defaultFormField(
                                    controller: phoneController,
                                    type: TextInputType.phone,
                                    validate: (String? value)
                                    {
                                      if (value!.isEmpty)
                                      {
                                        return 'you should enter your phone number';
                                      }
                                    },
                                    label: 'phone Number',
                                    prefix: Icons.phone_android
                                ),
                                const SizedBox(height: 20,),
                                defaultButton(
                                  function: () {
                                    if(formKey.currentState!.validate())
                                    {
                                      AppCubit.get(context).updateAddress(
                                          area: areaController.text,
                                          streetName: streetNameController.text,
                                          buildingName: buildingNameOrNumberController.text,
                                          floorNumber: floorNumberController.text,
                                          apartmentNumber: apartmentNumberController.text,
                                          phoneNumber: phoneController.text,
                                          oldModel: model
                                      );
                                    }
                                  },
                                  text: state is AppUpdateAddressLoadingState
                                      ?
                                  'Updating address ...'
                                      :
                                  'Update address',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                defaultButton(
                                  function: ()
                                  {
                                    showDialog(
                                        context: context,
                                        builder: (context)
                                        {
                                          return AlertDialog(
                                            title: const Text('Deleting Address'),
                                            content: const Text('Are you really want to delete this address ?'),
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
                                                    AppCubit.get(context).deleteAddress(oldModel: model);
                                                    Navigator.pop(context);
                                                  },
                                                  text: 'Yes'
                                              )
                                            ],
                                          );
                                        }
                                    );
                                  },
                                  text: state is AppDeleteAddressLoadingState
                                      ?
                                  'deleting address ...'
                                      :
                                  'delete address',
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
