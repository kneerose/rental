import 'package:flutter/material.dart';
import 'package:musical_equipment_rental/main.dart';
import 'package:musical_equipment_rental/screen/login/login_signupscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../theme.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
 // String? token;
//  String? id;
// String? email;
// String? phonenumber;
// String? location;
// String? username;
// String? status;
   Future getshare()async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
    id = sharedPreferences.getString("id");
    email=sharedPreferences.getString("email");
    location = sharedPreferences.getString("location");
    username = sharedPreferences.getString("username");
    phonenumber= sharedPreferences.getString("contactnumber");
    status = sharedPreferences.getString("status");
    //token = sharedPreferences.getString("token");
    });
  
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getshare();
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: CircleAvatar(
                  backgroundColor: kprimaryColor,
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              heightspace(20),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kprimaryColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${username!.capitalizeFirst}",
                          style: TextStyle(fontSize: 18,color: Colors.grey),
                        ),
                      ],
                    ),
                    // Icon(
                    //   Icons.edit,
                    //   size: 30,
                    // ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kprimaryColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Text(
                          location!.toUpperCase(),
                          style: TextStyle(fontSize: 15,color: Colors.grey),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.location_on,
                      size: 30,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kprimaryColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 5),
                    Text(
                      email!,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
             heightspace(10),
               Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kprimaryColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Contact number",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Text(
                          phonenumber!,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                    Icon(Icons.phone)
                  ],
                ),
              ),
              heightspace(10),
              ElevatedButton(
                onPressed: ()async {
               SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.remove("email");
              preferences.remove("username");
              preferences.remove("location");
              preferences.remove("contactnumber");
              preferences.remove("status");
              //preferences.remove("token");
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LogSign()), (route) => false);
                },
                child: Text("Logout"),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                        primary: kprimaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
