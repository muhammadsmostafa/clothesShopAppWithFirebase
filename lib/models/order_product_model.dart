class OrderProductModel
{
  String? productName;
  String? description;
  double? oldPrice;
  double? price;
  String? productMainImage;
  int? quantity;
  late bool discount;
  String? size;

  OrderProductModel({
    required this.productName,
    required this.description,
    required this.oldPrice,
    required this.price,
    required this.productMainImage,
    required this.discount,
    required this.quantity,
    required this.size,
  });

  OrderProductModel.fromJson(Map <String, dynamic>? json)
  {
    productName = json!['productName'];
    description = json['description'];
    price = json['price'];
    oldPrice = json['oldPrice'];
    productMainImage = json['productImage'];
    discount = json['discount'];
    quantity = json['quantity'];
    size = json['size'];
  }

  Map <String, dynamic> toMap()
  {
    return {
      'productName': productName,
      'description': description,
      'oldPrice': oldPrice,
      'price': price,
      'productImage': productMainImage,
      'discount': discount,
      'quantity': quantity,
      'size': size,
    };
  }
}