import 'package:flutter/material.dart';
import 'package:musical_equipment_rental/screen/homescreen/homescreenadmin.dart';
import 'package:musical_equipment_rental/screen/homescreen/homescreenuser.dart';
import 'package:musical_equipment_rental/screen/login/login_signupscreen.dart';
import 'package:musical_equipment_rental/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
     preferences();
    // TODO: implement initState
    super.initState();
   
  }
  Future preferences ()async
  {
    SharedPreferences shared = await SharedPreferences.getInstance();
    setState(() {
    email = shared.getString("email");
    phonenumber=shared.getString("contactnumber");
    location = shared.getString("location");
    username = shared.getString("username");
    status = shared.getString("status");
    });
   
  }
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: email==null?LogSign():(status=="admin"?HomeScreen():HomeScreenuser()),
     // (status=="admin"?HomeScreen():HomeScreenuser()),
      duration: 5100,
      imageSize: 130,
      imageSrc: "assets/splashscreen/logo.png",
      text: "Musical \n Equipment Rental ",
      textType: TextType.TyperAnimatedText,
      textStyle: TextStyle(
        fontSize: 20.0,
        color: Colors.white
      ),
      backgroundColor: kprimaryColor,
    );

  }
}