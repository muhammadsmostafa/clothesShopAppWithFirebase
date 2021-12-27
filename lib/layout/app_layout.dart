import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/modules/add_product/add_product_screen.dart';
import 'package:clothes_shop_app/modules/favorites/favorites_screen.dart';
import 'package:clothes_shop_app/modules/my_account//my_account_screen.dart';
import 'package:clothes_shop_app/modules/my_cart/cart_screen.dart';
import 'package:clothes_shop_app/modules/onboarding_and_splash/onboarding_screen.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state){
        var userModel = AppCubit.get(context).userModel;
        var productModel = AppCubit.get(context).productModel;
        var favorites = AppCubit.get(context).favorites;
        return userModel!=null && productModel.isNotEmpty
        ?
        Container(
          decoration: const BoxDecoration(
            color: defaultColor,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(30),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
            title: InkWell(
                child: Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Row(
                    children:
                    const [
                      SizedBox(width: 5,),
                      Icon(
                        IconBroken.Search,
                        size: 20,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 15,
                          color: defaultColor
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              )
            ),
            drawer: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 40,),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(100),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *0.70,
                  child: Drawer(
                    child: Container(
                      color: defaultColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [
                            const SizedBox(height: 120,),
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              child:  CircleAvatar(
                                radius: 34,
                                backgroundImage:
                                NetworkImage(
                                  '${userModel.image}',
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
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
                            const SizedBox(height: 40,),
                            Padding (
                              padding: const EdgeInsetsDirectional.only(
                              start:10.0,
                              end: 10.0,
                                ),
                              child: Container(
                                width: double.infinity,
                                height: 1.0,
                                color: Colors.white54,
                                ),
                              ),
                            Expanded(
                              child: ListView(
                                children: [
                                  const SizedBox(height: 10,),
                                  userModel.admin ?? false
                                      ?
                                  Column(
                                    children: [
                                      drawerItem(
                                        icon: IconBroken.Plus,
                                        text: 'Add Product',
                                        onTap: ()
                                        {
                                          navigateTo(context, AddProductScreen());
                                        },
                                      ),
                                      const SizedBox(height: 30,),
                                    ],
                                  )
                                      :
                                  const SizedBox(),
                                  drawerItem(
                                    icon: IconBroken.Profile,
                                    text: 'My Account',
                                    onTap: ()
                                    {
                                      navigateTo(context,
                                          const MyAccountScreen()
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 30,),
                                  drawerItem(
                                    icon: IconBroken.Heart,
                                    text: 'My Favorite',
                                    onTap: ()
                                    {
                                      AppCubit.get(context).getCart();
                                      navigateTo(context, const FavoritesScreen());
                                    },
                                  ),
                                  const SizedBox(height: 30,),
                                  drawerItem(
                                    icon: IconBroken.Buy,
                                    text: 'My Cart',
                                    onTap: ()
                                    {
                                      navigateTo(context, const MyCartScreen());
                                    },
                                  ),
                                  const SizedBox(height: 30,),
                                  drawerItem(
                                    icon: Icons.delivery_dining,
                                    text: 'Upcoming Orders',
                                    onTap: ()
                                    {},
                                  ),
                                  const SizedBox(height: 30,),
                                  drawerItem(
                                    icon: IconBroken.Chat,
                                    text: 'My Chats',
                                    onTap: ()
                                    {},
                                  ),
                                  const SizedBox(height: 30,),
                                  drawerItem(
                                    icon: IconBroken.Paper_Plus,
                                    text: 'Help',
                                    onTap: ()
                                    {},
                                  ),
                                  const SizedBox(height: 30,),
                                  drawerItem(
                                    icon: IconBroken.Setting,
                                    text: 'Settings',
                                    onTap: ()
                                    {},
                                  ),
                                  const SizedBox(height: 30,),
                                  drawerItem(
                                    icon: IconBroken.Logout,
                                    text: state is AppLogoutLoadingState
                                    ?
                                    'Logging out ...'
                                    :
                                    'Logout',
                                    onTap: ()
                                    {
                                      AppCubit.get(context).logout().then((value){
                                        navigateAndFinish(context, const OnboardingScreen());
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 30,),
                                ],
                              ),
                            ),
                            ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1.45,
                children: List.generate(
                  productModel.length,
                  (index) => buildGridProduct(productModel[index], context, favorites, false),
                ),
              ),
            ),
          ),
        )
        :
        Container(
          color: Colors.white,
          child: const Center(child: CircularProgressIndicator()),
        );
      }
    );
  }

  Widget drawerItem({
  required IconData icon,
  required String text,
  required Function()? onTap
  }) => InkWell(
      onTap: onTap,
      child: Row(
        children:
        [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          )
        ],
      )
  );
}