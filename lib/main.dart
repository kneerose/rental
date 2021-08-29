import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musical_equipment_rental/screen/splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
String? id;
String? email;
String? phonenumber;
String? location;
String? username;
String? status;
String? firmname;
String? password;
//String? token;
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  }
class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
    @override
  void initState() {
     getshare();
    // TODO: implement initState
    super.initState();
   
  }
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
    firmname = sharedPreferences.getString("firmname");
    password = sharedPreferences.getString("password");
  //  token = sharedPreferences.getString("token");
    });
  
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}