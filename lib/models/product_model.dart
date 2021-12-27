class ProductModel
{
  String? productName;
  String? description;
  double? oldPrice;
  double? price;
  String? productMainImage;
  late String productId;
  List<dynamic>? sizesOfThisProduct;
  late bool discount;

  ProductModel({
    required this.productName,
    required this.description,
    required this.oldPrice,
    required this.price,
    required this.productMainImage,
    required this.productId,
    required this.sizesOfThisProduct,
    required this.discount,
  });

  ProductModel.fromJson(Map <String, dynamic>? json)
  {
    productName = json!['productName'];
    description = json['description'];
    price = json['price'];
    oldPrice = json['oldPrice'];
    productMainImage = json['productImage'];
    productId = json['productId'];
    sizesOfThisProduct = json['sizesOfThisProduct'];
    discount = json['discount'];
  }

  Map <String, dynamic> toMap()
  {
    return {
      'productName': productName,
      'description': description,
      'oldPrice': oldPrice,
      'price': price,
      'productImage': productMainImage,
      'productId': productId,
      'sizesOfThisProduct': sizesOfThisProduct,
      'discount': discount,
    };
  }
}