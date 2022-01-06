import 'package:clothes_shop_app/models/order_model.dart';
import 'package:clothes_shop_app/models/order_product_model.dart';

class UpcomingOrderModel
{
  List <OrderProductModel> orderProductModel;
  late OrderModel orderModel;

  UpcomingOrderModel({
    required this.orderModel,
    required this.orderProductModel,
});
}