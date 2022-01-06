import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel
{
  String? area;
  String? streetName;
  String? buildingName;
  String? floorNumber;
  String? apartmentNumber;
  String? phoneNumber;
  int? orderPrice;
  Timestamp? dateTime;
  late List<dynamic> productsId;

  OrderModel({
    required this.area,
    required this.streetName,
    required this.buildingName,
    required this.floorNumber,
    required this.apartmentNumber,
    required this.phoneNumber,
    required this.orderPrice,
    required this.dateTime,
    required this.productsId,
  });

  OrderModel.fromJson(Map <String, dynamic>? json)
  {
    area = json!['area'];
    streetName = json['streetName'];
    buildingName = json['buildingName'];
    floorNumber = json['floorNumber'];
    apartmentNumber = json['apartmentNumber'];
    phoneNumber = json['phoneNumber'];
    orderPrice = json['orderPrice'];
    dateTime = json['dateTime'];
    productsId = json['productsId'];
  }

  Map <String, dynamic> toMap()
  {
    return {
      'area': area,
      'streetName': streetName,
      'buildingName': buildingName,
      'floorNumber': floorNumber,
      'apartmentNumber': apartmentNumber,
      'phoneNumber': phoneNumber,
      'orderPrice': orderPrice,
      'dateTime': dateTime,
      'productsId': productsId,
    };
  }
}