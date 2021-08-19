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
            Fluttertoast.showToast(msg: "Loged in",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance().then((value){ 
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()),(r)=>false);
              return value;
            }
            );
            sharedPreferences.setString("id",data[0]);
             sharedPreferences.setString("username", data[5]);
            sharedPreferences.setString("contactnumber", data[3]);
            sharedPreferences.setString("location", data[2]);
            sharedPreferences.setString("email", data[4]);
            sharedPreferences.setString("status", data[6]);
            sharedPreferences.setString("firmname",data[1]);
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
  Future signup(String passWord,String emAil,String userName,String loCation,String phoneNumber ,BuildContext context)async
  {
     try{
       final uri =Uri.parse("http://musicalequipmentrental.000webhostapp.com/signup.php");
       var body = {
         "username":userName,
         "contact":phoneNumber,
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
         }
         else
          {
            passWord.hashCode;
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
  // Future forgotpassword()async
  // {
  //    try{

  //   }catch(e)
  //   {
  //     print(e);
  //   }
  // }
  Future addequipmentsserver(String brand,String ownerid,String categoryid,String description,String quantity,String imagepath,String location,String contactnumber) async
  {
    try{
      print("Category_id is $categoryid");
      final uri = Uri.parse("http://musicalequipmentrental.000webhostapp.com/setdata.php");
      var request = http.MultipartRequest('POST',uri);
      request.fields["brand"]=brand;
      request.fields["owner_id"]=ownerid;
      request.fields["category_id"]=categoryid;
      request.fields["description"]=description;
      request.fields["quantity"]=quantity;
      request.fields["contactnumber"]=contactnumber;
      request.fields["location"]=location;
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
      "imagepath":addlist.filepath,
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
  Future edit(String brand,String description,String quantity,int categoryid,String id)async
  {
    print("category $categoryid");
    final uri = Uri.parse("https://musicalequipmentrental.000webhostapp.com/edit.php");
    var body = {
       "id":id,
      "brand":brand ,
        "description": description,
        "quantity": quantity,
        "categoryid":categoryid.toString(),
    };
    var response = await http.post(uri,body:body);
    print(response.statusCode);
    if(response.statusCode==200)
    {
      print(response.body);
       Fluttertoast.showToast(msg: "Updated",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
      return response.body;
    
    }
    
  }
  Future getequipmentcategory()async{
    try{
      print("i am innnn");
    final uri = Uri.parse("https://musicalequipmentrental.000webhostapp.com/getequipmentcategory.php");
    final response = await http.get(uri);
    if(response.statusCode==200)
    {
      var data = json.decode(response.body);
      print(data);
      return data;
    }
    else
    {
      Fluttertoast.showToast(msg: "failed ",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
    }
  } catch(e)
  {
    print(e);
  }
  }
  Future getnotification()async
  {
    try{
      final uri = Uri.parse("https://musicalequipmentrental.000webhostapp.com/getbookings.php");
      final response = await http.get(uri);
      if(response.statusCode==200)
      {
        var data = jsonDecode(response.body);
        return data;
      }
    }
    catch(e)
    {
      print(e);
    }
  }
  Future hire(String customerid,int ownerid,int productid,int noofdays,String dateofrental,String dateofreturn,int totalprice)async
  {
    try{
      final uri = Uri.parse("https://musicalequipmentrental.000webhostapp.com/booking.php");
      var body = {
        "customer_id":customerid,
        "owner_id":ownerid.toString(),
        "product_id":productid.toString(),
        "no_of_days":noofdays.toString(),
        "date_of_rental":dateofrental,
        "date_of_return":dateofreturn,
        "total_price":totalprice.toString(),
      };
      final response = await http.post(uri,body:body );
      if(response.statusCode==200)
      {
        Fluttertoast.showToast(msg: "submitted succesfully",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
      }
    }
    catch(e)
    {
      print(e);
    }
  }
}
