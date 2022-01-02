import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/models/address_model.dart';
import 'package:clothes_shop_app/models/product_model.dart';
import 'package:clothes_shop_app/modules/edit_product/edit_product_screen.dart';
import 'package:clothes_shop_app/modules/manage_address/edit_address_screen.dart';
import 'package:clothes_shop_app/modules/product/product_screen.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String val)? onSubmit,
  Function(String val)? onChange,
  Function()? onTap,
  Function()? suffixPressed,
  bool isPassword = false,
  required String? Function(String? val)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isClickable = true,
}) =>
    Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 15,
        end: 15,
      ),
      child: TextFormField(
        cursorColor: defaultColor,
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        enabled: isClickable,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: onTap,
        validator: validate,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: defaultColor,
          ),
          prefixIcon: Icon(
            prefix,
            color: defaultColor,
          ),
          suffixIcon: suffix != null
          ?
          IconButton(
            onPressed: suffixPressed,
            icon: Icon(
              suffix,
                color: defaultColor
            ),
          )
          :
          null,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: defaultColor
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: defaultColor
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: defaultColor
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
                color: defaultColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: defaultColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
          )
        ),
      ),
    );

Widget defaultButton({
  double width = 250,
  Color background = defaultColor,
  Color? textColor,
  bool isUpperCase = true,
  double radius = 20,
  required Function() function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultTextButton({
  required Function() function,
  Color? textColor,
  required String text,
}) => TextButton(
  onPressed: function,
  child: Text(
    text,
    style: TextStyle(
      color: textColor ?? defaultColor
    ),
  ),
);

void navigateTo(context , widget) => Navigator.push(
  context,
  PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => widget,
      transitionDuration: Duration.zero
  ),
);

Future <void> navigateAndFinish(context , widget) => Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => widget,
        transitionDuration: Duration.zero
    ),
        (route)
    {
      return false;
    }
);

void showToast({
  required String message,
  int? time,
})=> Fluttertoast.showToast(
  msg: message,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: time ?? 5,
  fontSize: 16.0,
);

Widget buildGridProduct(ProductModel productModel, context, List favorites , bool favoriteScreen) => InkWell(
  onTap: ()=> navigateTo(context, ProductScreen(productModel: productModel)),
  child: Builder(
        builder: (context) {
        bool favorite = false;
        if(!favoriteScreen)
          {
            for (var element in favorites) {
              if(element == productModel.productId)
              {
                favorite = true;
                break;
              }
              else
              {
                favorite = false;
              }
            }
          }
        return Container(
            color: Colors.white,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Column(
                          children: [
                            Container(
                                color: Colors.white,
                                child:Image(
                                  image: NetworkImage('${productModel.productMainImage}'),
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.width*0.5,
                                  fit: BoxFit.cover,
                                )),
                          ],
                        ),
                        if(productModel.discount)
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              color: Colors.red,
                              child: const Text(
                                'DISCOUNT',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                ),
                              )
                          ),
                      ],
                    ),
                    favoriteScreen
                    ?
                    IconButton(
                      onPressed: ()
                      {
                        AppCubit.get(context).removeProductFromFavorites(productModel: productModel,);
                        AppCubit.get(context).favoriteProductModel.remove(productModel);
                      },
                      icon: CircleAvatar(
                          radius: 12,
                          backgroundColor:
                          defaultColor,
                          child: Icon(
                            Icons.remove,
                            size: 22,
                            color: Colors.grey[300],
                          )),
                    )
                    :
                    const SizedBox(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${productModel.productName}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height:1.3,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${productModel.price!.round()}'' EGP',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: defaultColor,
                            ),
                          ),
                          const SizedBox(width: 5,),
                          if(productModel.discount)
                            Text(
                              '${productModel.oldPrice!.round()}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          const Spacer(),
                          favoriteScreen
                          ?
                           AppCubit.get(context).adminsId.contains(AppCubit.get(context).userModel!.uId)
                              ?
                          IconButton(
                              onPressed:()
                              {
                                navigateTo(context, EditProductScreen(model: productModel));
                              },
                              icon: const Icon(
                                IconBroken.Edit,
                                color: defaultColor,
                              )
                          )
                              :
                              const SizedBox()
                          :
                          Row(
                            children: [
                              AppCubit.get(context).adminsId.contains(AppCubit.get(context).userModel!.uId)
                                  ?
                              IconButton(
                                  onPressed: ()
                                  {
                                    navigateTo(context, EditProductScreen(model: productModel,));
                                  },
                                  icon: const Icon(
                                    IconBroken.Edit,
                                    color: defaultColor,
                                  ))
                                  :
                                  const SizedBox(),
                              IconButton(
                                onPressed: ()
                                {
                                  if (favorite)
                                    {
                                      AppCubit.get(context).removeProductFromFavorites(productModel: productModel);
                                    }
                                  else
                                    {
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
                                    Colors.grey
                                    ,
                                    child: const Icon(
                                      IconBroken.Heart,
                                      size: 20,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
        );
      }
  ),
);

Widget myDivider() => Padding (
  padding: const EdgeInsetsDirectional.only(
    start:20.0,
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 10
    ),
    child: Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    ),
  ),
);

Widget buildAddressItem (context, AddressModel model, bool cartScreen) => InkWell(
  onTap: cartScreen
  ? ()
  {}
  : ()
  {
    navigateTo(context, EditAddressScreen(model: model));
  },
  child:Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: 10
    ),
    child: Container(
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
            const Icon(
              IconBroken.Home,
              color: defaultColor,
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Text('${model.streetName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: defaultColor,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    '${model.area}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);