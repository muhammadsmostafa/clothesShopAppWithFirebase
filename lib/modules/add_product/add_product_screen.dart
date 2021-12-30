import 'package:clothes_shop_app/layout/app_layout.dart';
import 'package:clothes_shop_app/layout/cubit/cubit.dart';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/shared/components/components.dart';
import 'package:clothes_shop_app/shared/styles/colors.dart';
import 'package:clothes_shop_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var productNameController = TextEditingController();
    var descriptionController = TextEditingController();
    var priceController = TextEditingController();
    var oldPriceController = TextEditingController();
    AppCubit.get(context).discount=false;
    List<String> sizesOfThisProduct=[];

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state)
      {
        if (state is AppAddProductSuccessState)
          {
            showToast(message: 'Added successfully', time: 10);
            AppCubit.get(context).sizesCount=0;
            navigateAndFinish(context, AddProductScreen());
          }
        if(state is AppAddProductErrorState || state is AppUploadProductImagePickedErrorState)
          {
            showToast(message: 'Error while add this product, try to ad it again', time: 10);
          }
      },
      builder: (context, state)
      {
        var productImage = AppCubit.get(context).productImage;
        return SafeArea(
          child: WillPopScope(
            onWillPop: ()
            async {
              navigateAndFinish(context, const AppLayout());
              AppCubit.get(context).removeProductImage();
              return true;
            },
            child: Scaffold(
              backgroundColor: defaultColor,
              body: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Row(
                      children:
                      [
                        IconButton(
                            onPressed: ()
                            {
                              navigateAndFinish(context, const AppLayout());
                              AppCubit.get(context).sizesCount=0;
                              AppCubit.get(context).removeProductImage();
                            },
                            icon: const Icon(
                              IconBroken.Arrow___Left,
                              color: Colors.white,
                            )),
                        const Text(
                          'Add Product',
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
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 150,
                                      color: defaultColor,
                                      child: Center(
                                        child:
                                        productImage == null
                                        ?
                                        const Text(
                                          'Product image',
                                          style: TextStyle(
                                            color: Colors.white
                                          ),
                                        )
                                        :
                                        Stack(
                                          alignment: AlignmentDirectional.topEnd,
                                          children: [
                                            Image(
                                              image: FileImage(productImage),
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ),
                                            IconButton(
                                              onPressed: ()
                                              {
                                                AppCubit.get(context).removeProductImage();
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        icon: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                            defaultColor,
                                            child: Icon(
                                              IconBroken.Camera,
                                              size: 20,
                                              color: Colors.grey[300],
                                            )),
                                      onPressed: ()
                                      {
                                        AppCubit.get(context).getProductImage();
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                defaultFormField(
                                  controller: productNameController,
                                  type: TextInputType.text,
                                  validate: (String? value)
                                  {
                                    if (value!.isEmpty)
                                    {
                                      return 'please enter product name';
                                    }
                                  },
                                  label: 'Product name',
                                  prefix: IconBroken.Bookmark,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  controller: descriptionController,
                                  type: TextInputType.text,
                                  validate: (String? value)
                                  {
                                    if (value!.isEmpty)
                                    {
                                      return 'please enter description to this product';
                                    }
                                  },
                                  label: 'Description',
                                  prefix: IconBroken.Paper,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left : 15
                                  ),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Sizes',
                                        style: TextStyle(
                                          color: defaultColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: ()
                                          {
                                            AppCubit.get(context).removeSize();
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            color: defaultColor,
                                          )
                                      ),
                                      IconButton(
                                          onPressed: ()
                                          {
                                            AppCubit.get(context).addSize();
                                          },
                                          icon: const Icon(
                                              Icons.add,
                                              color: defaultColor,
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppCubit.get(context).sizesCount!=0
                                ?
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10
                                        ),
                                        child: SizedBox(
                                          height: 80,
                                          child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) => buildSizeInputType(index: index),
                                              separatorBuilder: (context, index) => const SizedBox(width: 10,),
                                              itemCount: AppCubit.get(context).sizesCount
                                          ),
                                        ),
                                      )
                                      :
                                    const SizedBox(),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  controller: priceController,
                                  type: TextInputType.number,
                                  validate: (String? value)
                                  {
                                    if (value!.isEmpty)
                                    {
                                      return 'please enter product\'s price';
                                    }
                                  },
                                  label: 'Price',
                                  prefix: Icons.attach_money,
                                ),
                                AppCubit.get(context).discount == true
                                ?
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20
                                      ),
                                      child: Row(
                                        children:
                                        [
                                          const Text(
                                            'Is this product have a discount ?',
                                            style: TextStyle(
                                              color: defaultColor,
                                            ),
                                          ),
                                          const Spacer(),
                                          TextButton(
                                            onPressed: ()
                                            {
                                              AppCubit.get(context).changeDiscountAvailability();
                                            },
                                            child: const Text(
                                              'No',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    defaultFormField(
                                      controller: oldPriceController,
                                      type: TextInputType.number,
                                      validate: (String? value)
                                      {
                                        if (value!.isEmpty)
                                        {
                                          return 'please enter product\'s old price or remove discount';
                                        }
                                      },
                                      label: 'Old price',
                                      prefix: Icons.attach_money,
                                    ),
                                  ],
                                )
                                :
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20
                                  ),
                                  child: Row(
                                    children:
                                    [
                                      const Text(
                                        'Is this product have a discount ?',
                                        style: TextStyle(
                                          color: defaultColor,
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: ()
                                        {
                                          AppCubit.get(context).changeDiscountAvailability();
                                        },
                                        child: const Text(
                                          'Yes',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                defaultButton(
                                  function: () {
                                    if(formKey.currentState!.validate())
                                    {
                                      if(productImage == null)
                                        {
                                          showToast(message: 'you must add image for each product', time: 10);
                                        }
                                      else
                                      {
                                            for(int i=0; AppCubit.get(context).sizesCount>i; i++) {
                                              sizesOfThisProduct.add(sizesController[i].text.toUpperCase());
                                            }
                                            AppCubit.get(context).uploadProductImage(
                                              update: false,
                                              productName: productNameController.text,
                                              description: descriptionController.text,
                                              oldPrice: AppCubit.get(context).discount
                                                  ?
                                              double.parse(oldPriceController.text)
                                                  :
                                              double.parse(priceController.text),
                                              price: double.parse(priceController.text),
                                              discount: AppCubit.get(context).discount,
                                              sizesOfThisProduct: sizesOfThisProduct,
                                              productId: '',
                                            );
                                      }
                                    }
                                  },
                                  text: AppCubit.get(context).addingProduct
                                  ?
                                  'Adding product ...'
                                  :
                                  'Add Product',
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

  List<TextEditingController> sizesController =
  [
    for(int i=0; i!=10; i++)
      TextEditingController()
  ];
  Widget buildSizeInputType({
  required int index,
  }) => SizedBox(
    width: 55,
    height: 55,
    child: TextFormField(
      controller: sizesController[index],
      validator: (String? value)
      {
        if (value!.isEmpty)
        {
          return '';
        }
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: defaultColor
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: defaultColor
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.red
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: defaultColor,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
  );
}