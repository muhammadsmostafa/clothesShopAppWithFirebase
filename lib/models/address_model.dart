class AddressModel
{
  String? area;
  String? streetName;
  String? buildingName;
  String? floorNumber;
  String? apartmentNumber;
  String? phoneNumber;
  String? addressId;

  AddressModel({
    required this.area,
    required this.streetName,
    required this.buildingName,
    required this.floorNumber,
    required this.apartmentNumber,
    required this.phoneNumber,
    required this.addressId,
  });

  AddressModel.fromJson(Map <String, dynamic>? json)
  {
    area = json!['area'];
    streetName = json['streetName'];
    buildingName = json['buildingName'];
    floorNumber = json['floorNumber'];
    apartmentNumber = json['apartmentNumber'];
    phoneNumber = json['phoneNumber'];
    addressId = json['addressId'];
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
      'addressId': addressId,
    };
  }
}