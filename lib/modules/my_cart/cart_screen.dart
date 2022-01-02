import 'package:buildcondition/buildcondition.dart';
import 'package:clothes_shop_app/layout/app_layout.dart';
import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/models/cart_model.dart';
import 'package:clothes_shop_app/modules/manage_address/add_new_address_screen.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCartScreen extends StatelessWidget {
  const MyCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        var cartModel = AppCubit.get(context).cartModel;
        return WillPopScope(
          onWillPop: ()
          async {
            navigateAndFinish(context, const AppLayout());
            return true;
          },
          child: SafeArea(
            child: Scaffold(
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
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: BuildCondition(
                          condition: cartModel.isNotEmpty,
                          builder: (context) => SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => buildCartItem(context, cartModel[index]),
                                    separatorBuilder: (context, index) => myDivider(),
                                    itemCount: cartModel.length
                                ),
                              ],
                            ),
                          ),
                          fallback: (context) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'You didn\'t add any products to your cart yet !',
                                    style: TextStyle(
                                        color: defaultColor,
                                        fontSize: 17
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              defaultButton(
                                  function: ()
                                  {
                                    navigateAndFinish(context, const AppLayout());
                                  },
                                  text: 'Continue Shopping'
                              ),
                            ],
                          ),
                        ),
                    ),
                  ),
                  AppCubit.get(context).totalPriceOfCartItems != 0
                  ?
                  Container(
                    width: double.infinity,
                    decoration:  const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 5,),
                         Text(
                          'Total Price is ${AppCubit.get(context).totalPriceOfCartItems.round()} EGP',
                          style: const TextStyle(
                            fontSize: 18
                          ),
                        ),
                        const SizedBox(height: 10,),
                        defaultButton(
                          function: ()
                          {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:
                                         [
                                          const Center(
                                            child: Text(
                                                'Choose delivery location',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                           const SizedBox(
                                             height: 15,
                                           ),
                                           AppCubit.get(context).addresses.isNotEmpty
                                           ?
                                           ListView.separated(
                                               shrinkWrap: true,
                                               physics: const NeverScrollableScrollPhysics(),
                                               itemBuilder: (context, index) => buildAddressItem(context, AppCubit.get(context).addresses[index], true),
                                               separatorBuilder: (context, index) => const SizedBox(height: 15,),
                                               itemCount: AppCubit.get(context).addresses.length
                                           )
                                           :
                                           const SizedBox(),
                                           const SizedBox(height: 15,),
                                           Center(
                                             child: defaultButton(
                                                 function: ()
                                                 {
                                                   navigateTo(context, const AddNewAddressScreen());
                                                 },
                                                 text: 'add new address'
                                             ),
                                           ),
                                        ],
                                      ),
                                    ),
                                  ),
                            ));
                          },
                          text: 'checkout',
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  )
                      :
                  const SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCartItem(context, CartModel cartModel) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image(
          height: MediaQuery.of(context).size.width * 0.25,
          width: MediaQuery.of(context).size.width * 0.25,
          fit: BoxFit.cover,
          image: NetworkImage('${cartModel.productModel!.productMainImage}'
          )
      ),
      const SizedBox(width: 10,),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text(
              '${cartModel.productModel!.productName}',
              style: const TextStyle(
                  color: defaultColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Size: ${cartModel.size}',
              style: const TextStyle(
                color: defaultColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  '${cartModel.productModel!.price!.round()}'' EGP',
                ),
                cartModel.productModel!.discount
                ?
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${cartModel.productModel!.oldPrice}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    )
                    :
                    const SizedBox()
              ],
            ),
          ],
        ),
      ),
      Column(
        children: [
          TextButton(
              onPressed: ()
              {
                AppCubit.get(context).removeFromCart(thisCartModel: cartModel);
              },
              child: const Text('Remove')),
          Row(
            children: [
              IconButton(
                onPressed: ()
                {
                  if(cartModel.quantity <= 1)
                    {
                      showToast(message: 'If you really want to remove this item tap remove', time: 10);
                    }
                  else
                    {
                        AppCubit.get(context).decreaseCart(cartModel: cartModel);
                    }
                },
                icon: CircleAvatar(
                    radius: 12,
                    backgroundColor:
                    defaultColor,
                    child: Icon(
                      Icons.remove,
                      size: 22,
                      color: Colors.grey[300],
                    )
                ),
              ),
              Text(
                '${cartModel.quantity}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              IconButton(
                onPressed: ()
                {
                  AppCubit.get(context).incrementCart(cartModel: cartModel);
                },
                icon: CircleAvatar(
                    radius: 12,
                    backgroundColor:
                    defaultColor,
                    child: Icon(
                      Icons.add,
                      size: 22,
                      color: Colors.grey[300],
                    )
                ),
              ),
              const SizedBox(width: 5,)
            ],
          ),
        ],
      ),
    ],
  );
}


