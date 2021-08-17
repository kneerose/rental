import 'package:http/http.dart';

class Usermodel {
  String username;
  String contactnumber;
  String location;
  String email;
  String status;
  String token;
  Usermodel({
    required this.username,
    required this.contactnumber,
    required this.email,
    required this.location,
    required this.status,
    required this.token
  });
  factory Usermodel.tojson(Map<String,dynamic> tojson)
  {
    return Usermodel(
      username: tojson["username"],
      contactnumber: tojson["contactnumber"],
      location: tojson["location"],
      email: tojson["email"],
      status: tojson["status"],
      token: tojson["token"],
    );
  }
 Map<String,dynamic> tomap()=> {
    username: "username",
      contactnumber: "contactnumber",
      location: "location",
      email: "email",
      status: "status",
      token: "token",
 };
}