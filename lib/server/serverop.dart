import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:musical_equipment_rental/main.dart';
import 'package:musical_equipment_rental/model/addlist.dart';
import 'package:musical_equipment_rental/screen/homescreen/homescreenadmin.dart';
import 'package:musical_equipment_rental/screen/homescreen/homescreenuser.dart';
import 'package:musical_equipment_rental/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Serverop{
  Future login(String email,String password,BuildContext context)async
  {
    try{
      final uri =Uri.parse("http://musicalequipmentrental.000webhostapp.com/login.php");
      final uri1 = Uri.parse("https://musicalequipmentrental.000webhostapp.com/logincustomer.php");
      var body = {
        "email":email,
        "password":password,
      };
      var response = await http.post(uri,body:body );
      var response1 = await http.post(uri1,body: {
        "email":email,
        "password":password,
      });
      print(response1.statusCode);
     // print(response.body);
      if(response.statusCode==200 && response1.statusCode==200)
      {
        final data = jsonDecode(response.body);
        final data1 = jsonDecode(response1.body);
        print("i am here");
        print("for first $data");
        print(data.runtimeType);
        print(data1);
        if(data=="dont have an account" && data1=="dont have an account")
        {
          Fluttertoast.showToast(msg: "No account found",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
        }
        else
        {
          if(data.runtimeType==String && data1.runtimeType==String)
          {
             Fluttertoast.showToast(msg: "Incorrect password",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
          }
          else if(data.runtimeType!=String)
          {
            print("i am in");
            print(data);
             if(data=="false")
            {
               Fluttertoast.showToast(msg: "Incorrect password",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
            }
            else
            {
            Fluttertoast.showToast(msg: "Loged in ",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance().then((value){ 
              data[5]=="admin"? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()),(r)=>false): Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreenuser()),(r)=>false);
              return value;
            }
            );
            sharedPreferences.setString("id",data[0]);
             sharedPreferences.setString("username", data[1]);
            sharedPreferences.setString("contactnumber", data[2]);
            sharedPreferences.setString("location", data[3]);
            sharedPreferences.setString("email", data[4]);
            sharedPreferences.setString("status", data[5]);
            }
          }
          else if(data1.runtimeType!=String)
          {
            if(data1=="false")
            {
               Fluttertoast.showToast(msg: "Incorrect password",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
            }
            else
            {
            Fluttertoast.showToast(msg: "Loged in ",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance().then((value){ 
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreenuser()),(r)=>false);
              return value;
            }
            );
            sharedPreferences.setString("id", data1[0]);
            sharedPreferences.setString("username", data1[1]);
             sharedPreferences.setString("email", data1[2]);
            sharedPreferences.setString("contactnumber", data1[3]);
            sharedPreferences.setString("location", data1[4]);
            sharedPreferences.setString("status", "user");
            }
          }
        }
      }
      else
      {
        print(response.statusCode);
        
      Fluttertoast.showToast(msg: "error in getting data ",gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT);
      }
    }catch(e)
    {
      print(e);
      print("not");
    }
  }
  Future signup(String passWord,String emAil,String userName,String loCation,String phoneNumber,String tokengenerate ,BuildContext context)async
  {
     try{
       final uri =Uri.parse("http://musicalequipmentrental.000webhostapp.com/signup.php");
       var body = {
         "username":userName,
         "contactnumber":phoneNumber,
         "location":loCation,
         "email":emAil,
         "password":passWord,
       };
       var response = await http.post(uri,body: body);
       if(response.statusCode==200)
       {
         var data = jsonDecode(response.body);
         print(data);
         if(data=="Error")
         {
           Fluttertoast.showToast(msg: kalreadyaccount,toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
         }
         else if(data=="Success")
         {
          
           Fluttertoast.showToast(msg: kAccountCreated,toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreenuser()),(r)=>false);
           SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString("email", emAil);
            sharedPreferences.setString("contactnumber", phoneNumber);
            sharedPreferences.setString("location", loCation);
            sharedPreferences.setString("username",userName);
            sharedPreferences.setString("status", "user");
            sharedPreferences.setString("token",tokengenerate);
         }
         else
          {
            Fluttertoast.showToast(msg: "Failed",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
          }

       }
       else
       {
         Fluttertoast.showToast(msg: "Failed in server",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
       }
    }catch(e)
    {
      print(e);
    }
  }
  Future forgotpassword()async
  {
     try{

    }catch(e)
    {
      print(e);
    }
  }
  Future addequipmentsserver(String title,String type,String description,String quantity,String imagepath,String location,String price) async
  {
    try{
      final uri = Uri.parse("http://musicalequipmentrental.000webhostapp.com/setdata.php");
      var request = http.MultipartRequest('POST',uri);
      request.fields["title"]=title;
      request.fields["type"]=type;
      request.fields["description"]=description;
      request.fields["quantity"]=quantity;
      request.fields["location"]=location;
      request.fields["price_per_day"]=price;
      var picture = await http.MultipartFile.fromPath("image",imagepath);
      request.files.add(picture);
      var response = await request.send();
    print(response.statusCode);
      if(response.statusCode==200)
      {
        Fluttertoast.showToast(msg: "uploaded",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
      }
      else
      {
        Fluttertoast.showToast(msg: "failed",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
      }
      
    }
    catch(e){
      print(e);
    }
  }
  Future getequipmentsserver()async
  {
    try{
    final uri = Uri.parse("http://musicalequipmentrental.000webhostapp.com/getdata.php");
    var response = await http.get(uri);
    if(response.statusCode==200)
   { print(response.body);
  return jsonDecode(response.body);
   }
   else
   {
     print(response.statusCode);
   }
    }
    catch(e)
    {
      print(e);
    }
  }
  Future delete(Addlist addlist, BuildContext context) async
  {
    print("i am call");
    try{
    final url =Uri.parse("https://musicalequipmentrental.000webhostapp.com/delete.php");
    print("i am inside");
    var res = await http.post(url,body:{
      "id":addlist.id.toString(),
    });
    print(res.statusCode);
    if(res.statusCode==200)
    {
      
     Fluttertoast.showToast(msg: "Deleted",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
     return res.body;
    }
    else
    {
       Fluttertoast.showToast(msg:"Failed", toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
    }
  }
  catch(e)
  {
    return "error";
  }
  }
  Future edit(String title,String type,String description,String quantity,String price,String id)async
  {
    print(location);
    final uri = Uri.parse("https://musicalequipmentrental.000webhostapp.com/edit.php");
    var body = {
       "id":id,
      "title":title ,
        "type": type,
        "description": description,
        "quantity": quantity,
        "price_per_day":price
    };
    var response = await http.post(uri,body:body);
    print(response.statusCode);
    if(response.statusCode==200)
    {
       Fluttertoast.showToast(msg: "Updated",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
      return response.body;
    
    }
  }
  // Future deleteimage(String imageid)async
  // {
  //   print("i am in");
  //   final uri = Uri.parse("https://musicalequipmentrental.000webhostapp.com/image/c3952c44-2ac4-44e5-b7d3-4fe9c2ec3d4d1330449491.jpg");
  //   final  response = await http.delete(uri,
  //   headers: {
  //     'Accept': 'application/json',
  //     'Content-Type': 'multipart/form-data',
  //     'contentType': 'application/x-tar',
  //   },
  //   );
  //   print(response);
  //   return response;
  // }
  
}
