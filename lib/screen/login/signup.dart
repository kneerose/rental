import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:musical_equipment_rental/server/serverop.dart';
import 'package:musical_equipment_rental/theme.dart';
import 'package:musical_equipment_rental/validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class Signup extends StatefulWidget {
  const Signup({ Key? key }) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _username =TextEditingController();
  TextEditingController _contactnumber =TextEditingController();
  TextEditingController _location =TextEditingController();
  TextEditingController _email =TextEditingController();
  TextEditingController _password =TextEditingController();
  TextEditingController _vp =TextEditingController();
  bool _isnotvisiblepass= true;
  bool _isnotvisiblevp = true;
  bool isloading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.close,color: Colors.black,size: 30,)),
            widthspace(10),
      ],),
      body:SafeArea(
              child: Stack(
                children: [
                   isloading?Center(child: CircularProgressIndicator(),):SizedBox(),
                  SingleChildScrollView(
              child: Form(
                key: _key,
                         child: Column(
                    children: [
                    CircleAvatar(
                   radius: 50,
                   backgroundColor: kprimaryColor,
                   foregroundImage: AssetImage("assets/profile/user.png"),
                    ),
                    heightspace(10),
                    Container(
                   margin: const EdgeInsets.only(left:10,right:10),
                   child: TextFormField(
                     controller: _username,
                     validator: (value)
                     {
                       if(value==null || value.isEmpty)
                       {
                           return knullUsername;
                       }
                       return null;
                     },
                     decoration: InputDecoration(
                       labelText: "Username",
                       prefixIcon: Icon(Icons.person),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(12),
                       )
                     ),
                   ),
                    ),
                  heightspace(10),
                    Container(
                    margin: const EdgeInsets.only(left:10,right:10),
                   child: TextFormField(
                     validator: (value)
                     {
                       if(value==null || value.isEmpty)
                       {
                         return knullphone;
                       }
                      else if(!phoneValidatorRegExp.hasMatch(value))
                       {
                         return knotValidPhone;
                       }
                       return null;
                     },
                     controller: _contactnumber,
                     decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                       labelText: "Contact number",
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(12),
                       )
                     ),
                   ),
                    ),
                  heightspace(10),
                    Container(
                    margin: const EdgeInsets.only(left:10,right:10),
                   child: TextFormField(
                     controller: _location,
                     validator: (value)
                     {
                       if(value==null || value.isEmpty)
                       {
                         return knulllocation;
                       }
                       return null;
                     },
                     decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                       labelText: "Location",
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(12),
                       )
                     ),
                   ),
                    ),
                  heightspace(10),
                    Container(
                    margin: const EdgeInsets.only(left:10,right:10),
                   child: TextFormField(
                     controller: _email,
                     validator: (value)
                     {
                       if(value==null || value.isEmpty)
                       {
                         return knullemail;
                       }
                       else if (!emailValidatorRegExp.hasMatch(value))
                       {
                         return knotvalidemail;
                       }
                       return null;
                     },
                     decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                       labelText: "Email address",
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(12),
                       )
                     ),
                   ),
                    ),
                  heightspace(10),
                    Container(
                  margin: const EdgeInsets.only(left:10,right:10),
                   child: TextFormField(
                     obscureText: _isnotvisiblepass,
                     validator: (value)
                     {
                       if(value==null || value.isEmpty)
                       {
                         return knullpass;
                       }
                       else if(!passwordValidatorRegExp.hasMatch(value))
                       {
                         return knotvalidpassword;
                       }
                       return null;

                     },
                     controller: _password,
                     decoration: InputDecoration(
                       prefixIcon: Icon(Icons.lock),
                       suffixIcon:IconButton(onPressed: (){
                         setState(() {
                           _isnotvisiblepass=!_isnotvisiblepass;
                         });
                       }, icon: _isnotvisiblepass?Icon(Icons.visibility):Icon(Icons.visibility_off)),
                       labelText: "Password",
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(12),
                       )
                     ),
                   ),
                    ),
                  heightspace(10),
                    Container(
                    margin: const EdgeInsets.only(left:10,right:10),
                   child: TextFormField(
                     obscureText: _isnotvisiblevp,
                     validator: (value)
                     {
                      if (_password.text!=value)
                       {
                         return knotmatchpassword;
                       }
                       return null;
                     },
                     controller: _vp,
                     decoration: InputDecoration(
                       prefixIcon: Icon(Icons.lock),
                       suffixIcon: IconButton(onPressed: (){
                         setState(() {
                           _isnotvisiblevp=!_isnotvisiblevp;
                         });
                       }, icon: _isnotvisiblevp?Icon(Icons.visibility):Icon(Icons.visibility_off)),
                       labelText: "verify password",
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(12),
                       )
                     ),
                   ),
                    ),
                    heightspace(20),
                    ElevatedButton(
                   onPressed: ()async{
                     DataConnectionStatus status = await DataConnectionChecker().connectionStatus;
                   //  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                         if(_key.currentState!.validate())
                         {
                           // setState(() {
                           //   sharedPreferences.setString("email", _email.text);
                           //   sharedPreferences.setString("contactnumber", _contactnumber.text);
                           //   sharedPreferences.setString("location", _location.text);
                           //   sharedPreferences.setString("username", _username.text);
                           // });

                           if(status==DataConnectionStatus.connected)
                           {
                             setState(() {
                                isloading=true;
                             });
        
                             print(hex.encode(utf8.encode(_password.text)).toString());
                                Serverop().signup(hex.encode(utf8.encode(_password.text)).toString(),_email.text,_username.text,_location.text,_contactnumber.text, context,).then((value) {
                               setState(() {
                                 isloading=false;
                               });
                             });
                          
                            
                           }
                           else
                           {
                             ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("No internet connection !!"))
                             );
                           }
                         }
                   }, 
                   child: Text("Sign up"),
                   style: ElevatedButton.styleFrom(
                     primary: kprimaryColor,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(12),
                     ),
                     padding: const EdgeInsets.symmetric(horizontal:60,vertical:15)
                   ),
                   ),
                   heightspace(20),

                    

                  
                    
                    ],
            ),
          ),
        ),
                ],
              ),
      ) ,
    );
  }
}