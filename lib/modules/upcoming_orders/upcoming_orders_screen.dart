import 'package:buildcondition/buildcondition.dart';
import 'package:clothes_shop_app/layout/app_layout.dart';
import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/models/upcoming_order_model.dart';
import 'package:clothes_shop_app/modules/upcoming_orders/specific_order.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpcomingOrderScreen extends StatelessWidget {
  const UpcomingOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        var upcomingOrders = AppCubit.get(context).upcomingOrders;
        return WillPopScope(
          onWillPop: ()
          async {
            Navigator.pop(context);
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
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              IconBroken.Arrow___Left,
                              color: Colors.white,
                            )),
                        const Text(
                          'Upcoming Orders',
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
                        condition: upcomingOrders.isNotEmpty,
                        builder: (context) => SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20,),
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => buildOrderItem(context,upcomingOrders[index]),
                                  separatorBuilder: (context, index) => const SizedBox(height: 10,),
                                  itemCount: upcomingOrders.length
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
                                  'You didn\'t place any order yet !',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildOrderItem(context, UpcomingOrderModel model) => InkWell(
  onTap: ()
  {
    navigateTo(context, SpecificOrderScreen(model: model.orderProductModel,));
  },
  child:Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: 10
    ),
    child: Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child:   Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Text('${model.orderModel.area}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: defaultColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${model.orderModel.orderPrice}'' EGP',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 10,)
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);