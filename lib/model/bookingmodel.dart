import 'package:http/http.dart';

class Booking{
  final int id;
  final int customerid;
  final int ownerid;
  //final int productid;
  final int noofdays;
  final String dateofrental;
  final String dateofreturn;
  final int totalprice;
  final String contact;
  final String username;
  final String equipment;
  final String type;
  Booking({
    required this.id,
     required this.customerid,
    // required this.productid,
     required this.ownerid,
    required this.noofdays,
    required this.dateofrental,
    required this.dateofreturn,
    required this.totalprice,
    required this.contact,
    required this.equipment,
    required this.type,
    required this.username,
  }); 
  factory Booking.tojson(Map<String,dynamic> tojson)=>
  
    Booking(
      id: int.parse(tojson["id"]),
       customerid: int.parse(tojson["customer_id"]),
      // productid: int.parse(tojson["product_id"]),
      noofdays: int.parse(tojson["no_of_days"]),
      dateofrental: tojson["date_of_rental"],
      dateofreturn: tojson["date_of_return"],
      totalprice: int.parse(tojson["total_price"]),
      contact: tojson["contact"],
      username: tojson["username"],
      equipment: tojson["equipment"],
      type: tojson["type"],
      ownerid: int.parse(tojson["owner_id"]),

    );
  
}