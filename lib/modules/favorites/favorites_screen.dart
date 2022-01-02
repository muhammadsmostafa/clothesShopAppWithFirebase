import 'package:buildcondition/buildcondition.dart';
import 'package:clothes_shop_app/layout/app_layout.dart';
import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        var favoriteModel = AppCubit.get(context).favoriteProductModel;
        var favorites = AppCubit.get(context).favorites;
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
                          'My Favorite',
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
                        condition: favoriteModel.isNotEmpty,
                        builder: (context) => SingleChildScrollView(
                          child: Column(
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 1,
                                childAspectRatio: (MediaQuery.of(context).size.width*0.5) / ((MediaQuery.of(context).size.width*0.5)+91),
                                children: List.generate(
                                  favoriteModel.length,
                                      (index) => buildGridProduct(favoriteModel[index], context, favorites, true
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        fallback: (context) => Builder(
                          builder: (context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'You didn\'t add any products to your favorite yet !',
                                      style: TextStyle(
                                          color: defaultColor,
                                          fontSize: 17
                                      )
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
                            );
                          }
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
}