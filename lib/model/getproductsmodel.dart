import 'package:http/http.dart';

class Getproducts {
  final int id;
  final int ownerid;
  final int categoryid;
  final String firmname;
  final String phonenumber;
  final String location;
  final String equipment;
  final String type;
  final int priceperday;
  final String brand;
  final int availablequantity;
  final String description;
  final String image;
  Getproducts({
    required this.id,
    required this.ownerid,
    required this.categoryid,
    required this.firmname,
    required this.phonenumber,
    required this.location,
    required this.equipment,
    required this.type,
    required this.priceperday,
    required this.brand,
    required this.availablequantity,
    required this.description,
    required this.image,
  });
  factory Getproducts.tojson(Map<String,dynamic> tojson)=>
  Getproducts(
    id: int.parse(tojson["id"]),
    ownerid: int.parse(tojson["owner_id"]),
    categoryid: int.parse(tojson["category_id"]),
    firmname: tojson["firm_name"],
    phonenumber: tojson["phone"],
    location: tojson["location"],
    equipment: tojson["equipment"],
    type: tojson["type"],
    priceperday: int.parse(tojson["price_per_day"]),
    brand: tojson["brand"],
    availablequantity: int.parse(tojson["available_quantity"]),
    description: tojson["Description"],
    image: tojson["image"],

  );
}