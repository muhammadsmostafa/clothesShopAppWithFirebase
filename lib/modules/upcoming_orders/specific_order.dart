import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/models/order_product_model.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecificOrderScreen extends StatelessWidget {
  List<OrderProductModel> model;
  SpecificOrderScreen({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
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
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => buildCartItem(context, model[index],),
                                separatorBuilder: (context, index) => myDivider(),
                                itemCount: model.length
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

Widget buildCartItem(context, OrderProductModel model) => Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Image(
        height: MediaQuery.of(context).size.width * 0.25,
        width: MediaQuery.of(context).size.width * 0.25,
        fit: BoxFit.cover,
        image: NetworkImage('${model.productMainImage}'
        )
    ),
    const SizedBox(width: 10,),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          Text(
            '${model.productName}',
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
            'Size: ${model.size}',
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
                '${model.price!.round()}'' EGP',
              ),
              model.discount
                  ?
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '${model.oldPrice}',
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
    Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Center(
        child: Text(
          '${model.quantity}',
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
      ),
    ),
    const SizedBox(width: 10,),
  ],
);