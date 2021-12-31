import 'dart:io';
import 'package:clothes_shop_app/layout/cubit/states.dart';
import 'package:clothes_shop_app/models/cart_model.dart';
import 'package:clothes_shop_app/models/product_model.dart';
import 'package:clothes_shop_app/models/user_model.dart';
import 'package:clothes_shop_app/shared/components/constants.dart';
import 'package:clothes_shop_app/shared/network/local/cashe_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  void getUserData()
  {
    emit(AppGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(AppGetUserSuccessState());
    }).catchError((error) {
      emit(AppGetUserErrorState());
    });
  }

  String? userIdToBeAdmin;
  bool foundIt = false;
  void addAdmin({
  required String email,
  })
  {
    foundIt = false;
    emit(AppAddAdminsLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value){
          for (var element in value.docs) {
            if(element.data()['email'] == email)
              {
                userIdToBeAdmin = element.id;
                foundIt = true;
                break;
              }
          }}
          ).then((value){
            if(foundIt)
              {
                adminsId.add('$userIdToBeAdmin');
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(userIdToBeAdmin)
                    .get()
                    .then((value){
                  FirebaseFirestore.instance
                      .collection('admins')
                      .doc(userIdToBeAdmin)
                      .set({'admin': true});
                  admins.add(UserModel.fromJson(value.data()));
                }).then((value){
                  userIdToBeAdmin = null;
                  emit(AppAddAdminsSuccessState());
                });
              }
            else{
              emit(AppAddAdminsErrorState());
            }
    }).catchError((error){
      emit(AppAddAdminsErrorState());
    });
  }


  void removeAdmin({
    required String userId,
  })
  {
    emit(AppDeleteAdminsLoadingState());
    FirebaseFirestore.instance
        .collection('admins')
        .doc(userId)
        .delete().then((value){
          adminsId.remove(userId);
          admins.removeWhere((element) => userId == element.uId);
    }).then((value){
      emit(AppDeleteAdminsSuccessState());
    }).catchError((error){
      emit(AppDeleteAdminsErrorState());
    });
  }

  List<UserModel> admins=[];
  List<String> adminsId=[];
  void getAdmins()
  {
    admins=[];
    adminsId=[];
    emit(AppGetAdminsLoadingState());
    FirebaseFirestore.instance
        .collection('admins')
        .get()
        .then((value){
          for (var element in value.docs) {
            adminsId.add(element.id);
           FirebaseFirestore.instance
            .collection('users')
            .doc(element.id)
            .get()
            .then((value){
              admins.add(UserModel.fromJson(value.data()));
           });
          }}).then((value){
      emit(AppGetAdminsSuccessState());
    }).catchError((error){
      emit(AppGetAdminsErrorState());
    });
  }

  var picker = ImagePicker();
  Future<void> getProductImage() async {
    var pickedFile = await picker.pickImage(
        source: ImageSource.gallery
    );
    if (pickedFile != null) {
      productImage = File(pickedFile.path);
      emit(AppProductImagePickedSuccessState());
    } else {
      emit(AppProductImagePickedErrorState());
    }
  }

  Future<void> getProfileImage() async {
    var pickedFile = await picker.pickImage(
        source: ImageSource.gallery
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(AppProfileImagePickedSuccessState());
    } else {
      emit(AppProfileImagePickedErrorState());
    }
  }

  File? profileImage;
  void removeProfileImage() {
    profileImage = null;
    emit(AppRemoveProfileImageSuccessState());
  }

  bool updatingAccount = false;
  void uploadProfileImage({
    required String name,
    required String phone,
  }) {
    updatingAccount = true;
    emit(AppUploadProfileImagePickedLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref().
    child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
        emit(AppUploadProfileImagePickedSuccessState());
        removeProfileImage();
        updateAccount(
            name: name,
            phone: phone,
            image: value,
        );
      });
    }).catchError((error){
      emit(AppUploadProfileImagePickedErrorState());
    });
  }

  File? productImage;
  void removeProductImage() {
    productImage = null;
    emit(AppRemoveProductImageSuccessState());
  }

  void updateAccount({
    required String name,
    String? image,
    required String phone,
  })
  {
    updatingAccount=true;
    emit(AppUpdateAccountLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(
        UserModel(
            name: name,
            email: userModel!.email,
            phone: phone,
            uId: uId,
            image: image ?? userModel!.image,
            admin: userModel!.admin
        ).toMap()
    ).then((value){
      emit(AppUpdateAccountSuccessState());
    }).catchError((error){
      emit(AppUpdateAccountErrorState());
    });
    updatingAccount = false;
  }

  bool addingProduct = false;
  void uploadProductImage({
    required bool update,
    required String productId,
    required String productName,
    required String? description,
    required double? oldPrice,
    required double price,
    required bool discount,
    required List<String> sizesOfThisProduct,
  }) {
    addingProduct = true;
    emit(AppUploadProductImagePickedLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref().
    child('productsImages/${Uri
        .file(productImage!.path)
        .pathSegments
        .last}')
        .putFile(productImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
        emit(AppUploadProductImagePickedSuccessState());
        removeProductImage();
        update
        ?
        updateProduct(
          productName: productName,
          productId: productId,
          description: description,
          oldPrice: oldPrice,
          price: price,
          productMainImage: value,
          discount: discount,
          sizesOfThisProduct: sizesOfThisProduct,
        )
        :
        addProduct(
            productName: productName,
            description: description,
            oldPrice: oldPrice,
            price: price,
            productMainImage: value,
            discount: discount,
            sizesOfThisProduct: sizesOfThisProduct,
        );
      });
      }).catchError((error){
        emit(AppUploadProductImagePickedErrorState());
    });
  }

  void updateProduct({
    required String productName,
    required String? description,
    required String productId,
    required double? oldPrice,
    required double price,
    required String? productMainImage,
    required bool discount,
    required List<String> sizesOfThisProduct,
  })
  {
    addingProduct = true;
    emit(AppUpdateProductLoadingState());
    ProductModel productModel = ProductModel(
      productName: productName,
      description: description,
      oldPrice: oldPrice,
      price: price,
      productMainImage: productMainImage,
      discount: discount,
      sizesOfThisProduct: sizesOfThisProduct,
      productId: productId,
    );
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .set(productModel.toMap())
        .then((value){
      emit(AppUpdateProductSuccessState());
    }).catchError((error){
      emit(AppUpdateProductErrorState());
    });
    addingProduct = false;
  }

  void deleteProduct({
  required String productId
  })
  {
    emit(AppDeleteProductLoadingState());
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete().then((value){
      emit(AppDeleteProductSuccessState());
    }).catchError((error){
      emit(AppDeleteProductErrorState());
    });
  }

  String? selectedSize;
  void onSizeSelected({
  required String size,
  })
  {
    selectedSize = size;
    emit(AppChangeSelectedSizeState());
  }

  Future<void> logout()
  async {
    emit(AppLogoutLoadingState());
      CasheHelper.saveData(key: 'uId', value: '');
      uId = '';
      FirebaseAuth.instance.signOut()
          .then((value) {
        emit(AppLogoutSuccessState());
      });
  }

  int sizesCount = 0;
  void addSize()
  {
    if(sizesCount!=10)
      {
        sizesCount++;
        emit(AppAddSizeState());
      }
  }
  void removeSize()
  {
    if(sizesCount!=0)
      {
        sizesCount--;
        emit(AppRemoveSizeState());
      }
  }

  bool discount = false;
  void changeDiscountAvailability()
  {
    discount=!discount;
    emit(AppChangeDiscountAvailabilityState());
  }
  void addProduct({
    required String productName,
    required String? description,
    required double? oldPrice,
    required double price,
    required String productMainImage,
    required bool discount,
    required List<String> sizesOfThisProduct,
  })
  {
    emit(AppAddProductLoadingState());
    ProductModel productModel = ProductModel(
        productName: productName,
        description: description,
        oldPrice: oldPrice,
        price: price,
        productMainImage: productMainImage,
        discount: discount,
        sizesOfThisProduct: sizesOfThisProduct,
        productId: '',
    );
    FirebaseFirestore.instance
    .collection('products')
    .add(productModel.toMap())
        .then((value){
        value.update({'productId' : value.id});
       emit(AppAddProductSuccessState());
    }).catchError((error){
      emit(AppAddProductErrorState());
    });
    addingProduct = false;
  }

  List<ProductModel> productModel = [];
  void getProducts() {
    emit(AppGetProductLoadingState());
    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((event) {
        productModel=[];
        for (var element in event.docs){
          productModel.add(ProductModel.fromJson(element.data()));
      }
      emit(AppGetProductSuccessState());
    });
  }

  void addProductToFavorites({
  required ProductModel productModel,
 })
   {
    emit(AppAddToFavoritesLoadingState());
        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('favorites')
            .doc(productModel.productId)
            .set({'favorite': true}).then((value){
              if(!favorites.contains(productModel.productId))
                {
                  favorites.add(productModel.productId);
                  favoriteProductModel.add(productModel);
                  emit(AppAddToFavoritesSuccessState());
                }
          }).catchError((error){
            emit(AppAddProductErrorState());
          });
  }

  void removeProductFromFavorites({
    required ProductModel productModel,
  })
  {
    emit(AppRemoveFromFavoriteLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('favorites')
        .doc(productModel.productId)
        .delete().then((value){
          favorites.remove(productModel.productId);
          favoriteProductModel.removeWhere((element) => productModel.productId == element.productId
          );
      emit(AppRemoveFromFavoriteSuccessState());
    }).catchError((error){
      emit(AppRemoveFromFavoriteErrorState());
    });
  }

  List<String> favorites=[];
  void getFavorites() {
    favorites=[];
    emit(AppGetFavoriteLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('favorites')
        .get()
        .then((value){
          for (var element in value.docs) {
            favorites.add(element.id);
          }
    }).then((value){
      emit(AppGetFavoriteSuccessState());
    }).catchError((error){
      emit(AppGetFavoriteErrorState());
    });
  }

  List<ProductModel> favoriteProductModel=[];
  void getFavoriteScreen()
  {
    favoriteProductModel=[];
    for (var element in favorites) {
      FirebaseFirestore.instance
          .collection('products')
          .doc(element)
          .get()
          .then((value) {
          favoriteProductModel.add(ProductModel.fromJson(value.data()));
      }).then((value){
        emit(AppGetFavoriteScreenSuccessState());
      }).catchError((error){
        emit(AppGetFavoriteScreenErrorState());
      });
    }
  }

  void addToCart({
    required ProductModel productModel,
    required String? size,
  })
  {
    emit(AppAddToCartLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('cart')
        .doc(productModel.productId)
        .collection('sizes')
        .doc(size)
        .update({'quantity' : FieldValue.increment(1)})
        .then((value){
          CartModel cartModelOfThis = cartModel.firstWhere((element)
                  =>
                  productModel.productId == element.productModel!.productId && size == element.size);
          cartModelOfThis.quantity++;
          totalPriceOfCartItems += cartModelOfThis.productModel!.price!;
      emit(AppAddToCartSuccessState());
    }).catchError((error){
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('cart')
          .doc(productModel.productId)
          .set({'firstTime': true})
          .then((value){
            CartModel cartModelOfThis = CartModel(
                productModel: productModel,
                size: size,
                quantity: 1
            );
        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('cart')
            .doc(productModel.productId).collection('sizes')
            .doc(size)
            .set({'quantity' : 1})
            .then((value){
              cartModel.add(cartModelOfThis);
              totalPriceOfCartItems += cartModelOfThis.productModel!.price!;
        emit(AppAddToCartSuccessState());
        }).catchError((error){
        emit(AppAddToCartErrorState());
        });
      });
    });
  }

  void removeFromCart({
    required CartModel thisCartModel,
  })
  {
    emit(AppRemoveFromCartLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('cart')
        .doc(thisCartModel.productModel!.productId)
        .collection('sizes')
        .doc(thisCartModel.size)
        .delete()
      .then((value){
      cartModel.remove(thisCartModel);
      totalPriceOfCartItems -= thisCartModel.productModel!.price! * thisCartModel.quantity;
      emit(AppRemoveFromCartSuccessState());
      FirebaseFirestore.instance
      .collection('users')
      .doc(uId)
      .collection('cart')
      .doc(thisCartModel.productModel!.productId)
      .collection('sizes')
      .get()
      .then((value){
            if(value.docs.isEmpty)
            {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(uId)
                  .collection('cart')
                  .doc(thisCartModel.productModel!.productId)
                  .delete();
            }
      });
    }).catchError((error){
      emit(AppRemoveFromCartErrorState());
    });
  }

  void incrementCart({
  required CartModel cartModel,
  })
  {
    emit(AppIncrementLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('cart')
        .doc(cartModel.productModel!.productId)
        .collection('sizes')
        .doc(cartModel.size)
        .update({'quantity' : FieldValue.increment(1)})
        .then((value){
          cartModel.quantity++;
          totalPriceOfCartItems += cartModel.productModel!.price!;
      emit(AppIncrementSuccessState());
    }).catchError((error){
      emit(AppIncrementErrorState());
    });
  }

  void decreaseCart({
    required CartModel cartModel,
  })
   {
    emit(AppDecreaseLoadingState());
     FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('cart')
        .doc(cartModel.productModel!.productId)
        .collection('sizes')
        .doc(cartModel.size)
        .update({'quantity' : cartModel.quantity ==1 ? 1 : FieldValue.increment(-1)})
        .then((value){
      cartModel.quantity--;
      totalPriceOfCartItems -= cartModel.productModel!.price!;
      emit(AppDecreaseSuccessState());
    }).catchError((error){
      emit(AppDecreaseErrorState());
    });
  }

  List<String> cart = [];
  void getCart()
  {
    cart =[];
    emit(AppGetCartLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('cart')
        .get()
        .then((value) {
      for (var element in value.docs) {
        cart.add(element.id);
      }
      }).then((value){
      emit(AppGetCartSuccessState());
    }).catchError((error){
      emit(AppGetCartErrorState());
    });
  }

  List<ProductModel> cartProductModel=[];
  void getCartProductModel()
  {
    cartProductModel=[];
    cartModel=[];
    totalPriceOfCartItems=0;
    emit(AppGetCartProductModelLoadingState());
    for (var element in cart) {
      FirebaseFirestore.instance
          .collection('products')
          .doc(element)
          .get()
          .then((value) {
        cartProductModel.add(ProductModel.fromJson(value.data()));
      }).then((value){
        cart.remove(element);
        if (cart.isEmpty)
        {
          emit(AppGetCartProductModelSuccessState());
        }
      }).catchError((error){
        emit(AppGetCartProductModelErrorState());
      });
    }
  }

  List<CartModel> cartModel =[];
  void getCartScreen()
  {
    emit(AppGetCartScreenLoadingState());
    for (var element in cartProductModel) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('cart')
          .doc(element.productId)
          .collection('sizes')
          .get()
          .then((value){
            for (var e in value.docs) {
              cartModel.add(CartModel(
                  productModel: element,
                  size: e.id,
                  quantity: e.data()['quantity'],
              ));
            }
      }).then((value){
        cartProductModel.remove(element);
        if(cartProductModel.isEmpty)
          {
            emit(AppGetCartScreenSuccessState());
          }
      }).catchError((error){
        emit(AppGetCartScreenErrorState());
      });
    }
  }

    double totalPriceOfCartItems = 0;
    double singleItemPrice = 0;
    void getTotalPrice()
    {
      for (var element in cartModel) {
        singleItemPrice = element.productModel!.price! * element.quantity;
        totalPriceOfCartItems += singleItemPrice;
      }
    }
}