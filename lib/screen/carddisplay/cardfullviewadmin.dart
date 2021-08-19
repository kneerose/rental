import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musical_equipment_rental/model/addlist.dart';
import 'package:musical_equipment_rental/model/equipmentcategory.dart';
import 'package:musical_equipment_rental/theme.dart';
import 'package:get/get.dart';
class CardFullViewAdmin extends StatefulWidget {
  // final String brand;
  // final String imagepath;
  // final String description;
  // final String location;
  // final int price;
  // final String quantity;
  final Equipmentcategory equipmentcategory;
  final Addlist addlist;
  const CardFullViewAdmin({ Key? key,required this.equipmentcategory,required this.addlist}) : super(key: key);

  @override
  _CardFullViewAdminState createState() => _CardFullViewAdminState(equipmentcategory,addlist);
}

class _CardFullViewAdminState extends State<CardFullViewAdmin> {
  Equipmentcategory equipmentcategory;
  Addlist addlist;
  _CardFullViewAdminState(this.equipmentcategory,this.addlist);
    String urlimagepath = "https://musicalequipmentrental.000webhostapp.com/image/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text(equipmentcategory.equipment) ,
        centerTitle: true,
        elevation: 0,
        backgroundColor: kprimaryColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            heightspace(20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                child: Image.network(urlimagepath +addlist.filepath,fit: BoxFit.fill,)),
            ),
              heightspace(10),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      widthspace(5),
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Text(addlist.location.capitalizeFirst!,style: TextStyle(fontSize: 13),)),
                    ],
                  ),
                  Container(
                    child: Text("Rs ${equipmentcategory.priceperday}/day",style: TextStyle(fontSize: 13)))
              ],
              
            ),
               ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(addlist.description,textAlign: TextAlign.center,style: TextStyle(fontSize: 15,letterSpacing: 0.5),),
              ),
              heightspace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Contact number : ${addlist.contactnumber}",style: TextStyle(fontSize: 13)),
                  widthspace(10),
                ],
              ),
              heightspace(10),
            Text("Available Quantity :   ${addlist.quantity}",textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
          
              heightspace(10),
               

          ],
        ),
      ),
      
    );
  }
}