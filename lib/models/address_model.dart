class AddressModel
{
  String? area;
  String? streetName;
  String? buildingName;
  String? floorNumber;
  String? apartmentNumber;
  String? phoneNumber;

  AddressModel({
    required this.area,
    required this.streetName,
    required this.buildingName,
    required this.floorNumber,
    required this.apartmentNumber,
    required this.phoneNumber,
  });

  AddressModel.fromJson(Map <String, dynamic>? json)
  {
    area = json!['area'];
    streetName = json['streetName'];
    buildingName = json['buildingName'];
    floorNumber = json['floorNumber'];
    apartmentNumber = json['apartmentNumber'];
    phoneNumber = json['phoneNumber'];
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
    };
  }
}