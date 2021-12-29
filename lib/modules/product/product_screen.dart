import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/models/product_model.dart';
import 'package:clothes_shop_app/modules/edit_product/edit_product_screen.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatelessWidget {
  ProductModel productModel;
  ProductScreen({Key? key, required this.productModel,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state)
      {
        if(state is AppAddToCartSuccessState)
          {
            AppCubit.get(context).selectedSize=null;
            showToast(message: 'Added Successfully', time: 1);
          }
        if(state is AppAddToCartErrorState)
        {
          showToast(message: 'Error while adding try again', time: 10);
        }
      },
      builder: (context, state){
        var favorites = AppCubit.get(context).favorites;
        return WillPopScope(
          onWillPop: ()
          async {
            Navigator.pop(context);
            AppCubit.get(context).selectedSize=null;
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: defaultColor,
              body: Column(
                children: [
                  Builder(
                    builder: (context) {
                      bool favorite = false;
                      if (favorites.contains(productModel.productId))
                      {
                        favorite = true;
                      }
                      else
                        {
                          favorite = false;
                        }
                      return Row(
                        children:
                        [
                          IconButton(
                              onPressed: ()
                              {
                                Navigator.pop(context);
                                AppCubit.get(context).selectedSize = null;
                              },
                              icon: const Icon(
                                IconBroken.Arrow___Left,
                                color: Colors.white,
                              )),
                          const Spacer(),
                          AppCubit.get(context).adminsId.contains(AppCubit.get(context).userModel!.uId)
                              ?
                          IconButton(
                              onPressed:()
                              {
                                navigateTo(context, EditProductScreen(model: productModel));
                              },
                              icon: const Icon(
                                IconBroken.Edit,
                                color: Colors.white,
                              )
                          )
                          :
                              const SizedBox(),
                          IconButton(
                            onPressed: ()
                            {
                              if(favorite)
                                {
                                  AppCubit.get(context).removeProductFromFavorites(productModel: productModel);
                                }
                              else {
                                AppCubit.get(context).addProductToFavorites(productModel: productModel);
                              }
                            },
                            icon: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                favorite
                                    ?
                                Colors.pink
                                    :
                                Colors.grey,
                                child: const Icon(
                                  IconBroken.Heart,
                                  size: 20,
                                  color: Colors.white,
                                )),
                          ),
                          const SizedBox(width: 10,),
                        ],
                      );
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.cover,
                      image:
                      NetworkImage(
                        '${productModel.productMainImage}',
                      ),
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(
                                20
                            ),
                            child: Row(
                              children:
                              [
                                Text(
                                  '${productModel.productName}',
                                  style: const TextStyle(
                                      color: defaultColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  ),
                                ),
                                const Spacer(),
                                if(productModel.discount)
                                  Text(
                                    '${productModel.oldPrice!.round()}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                const SizedBox(width: 5,),
                                Text(
                                  '${productModel.price!.round()}'' EGP',
                                  style: const TextStyle(
                                      color: defaultColor,
                                      fontSize: 16
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  '${productModel.description}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  )
                              ),
                            ),
                          ),
                          if(productModel.sizesOfThisProduct!.isNotEmpty)
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 15,
                                      left: 10
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      'Sizes',
                                      style: TextStyle(
                                          color: defaultColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10
                                  ),
                                  child: SizedBox(
                                    height: 60,
                                    child:
                                    ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) => buildSizesItem(sizes: productModel.sizesOfThisProduct!.toList(), index: index, context: context),
                                        separatorBuilder: (context, index) => const SizedBox(width: 10,),
                                        itemCount: productModel.sizesOfThisProduct!.length
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const Spacer(),
                          defaultButton(
                            function: ()
                            {
                              if(AppCubit.get(context).selectedSize != null)
                                {
                                  AppCubit.get(context).addToCart(
                                      productModel: productModel,
                                      size: AppCubit.get(context).selectedSize
                                  );
                                }
                              else
                                {
                                  showToast(message: 'You must choose size', time: 10);
                                }
                            },
                            text: state is AppAddToCartLoadingState ? 'Adding to cart ...' : 'Add to cart',
                            textColor: Colors.white,
                          ),
                          const SizedBox(height: 10,)
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

  Widget buildSizesItem({
  required int index,
  required List<dynamic> sizes,
  required context,
  })=> InkWell(
    onTap: () => AppCubit.get(context).onSizeSelected(size: sizes[index]),
    child: CircleAvatar(
      backgroundColor: AppCubit.get(context).selectedSize != sizes[index] || AppCubit.get(context).selectedSize == null ? Colors.grey : defaultColor,
      child: Center(
        child: Text(
           sizes[index],
            style: TextStyle(
              color: AppCubit.get(context).selectedSize != sizes[index] || AppCubit.get(context).selectedSize == null ? defaultColor : Colors.white,
            ),
        ),
      ),
    ),
  );
}