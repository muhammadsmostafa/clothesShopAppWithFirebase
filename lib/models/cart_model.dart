import 'package:clothes_shop_app/models/product_model.dart';

class CartModel
{
  ProductModel? productModel;
  String? size;
  int quantity;

  CartModel({
    required this.productModel,
    required this.size,
    required this.quantity,
  });
}