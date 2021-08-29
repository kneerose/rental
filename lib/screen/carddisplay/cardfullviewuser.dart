import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musical_equipment_rental/model/addlist.dart';
import 'package:musical_equipment_rental/model/equipmentcategory.dart';
import 'package:musical_equipment_rental/model/getproductsmodel.dart';
import 'package:musical_equipment_rental/server/serverop.dart';
import 'package:musical_equipment_rental/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
class CardFullViewUser extends StatefulWidget {
  // final String title;
  // final String imagepath;
  // final String description;
  // final String location;
  // final String price;
  // final Equipmentcategory equipmentcategory;
  //final Addlist addlist;
  final Getproducts getproducts;
  const CardFullViewUser({ Key? key,required this.getproducts}) : super(key: key);

  @override
  _CardFullViewUserState createState() => _CardFullViewUserState(getproducts);
}

class _CardFullViewUserState extends State<CardFullViewUser> {
  int quantity =1;
 // Equipmentcategory equipmentcategory;
  DateTime initialdate = DateTime.now();
  Getproducts getproducts;
 // Addlist addlist;
  _CardFullViewUserState(this.getproducts);
   String urlimagepath = "https://musicalequipmentrental.000webhostapp.com/image/";
   late String dateofrental= DateFormat("yyyy-MM-dd").format(initialdate);
   late String dateofreturn= DateFormat("yyyy-MM-dd").format(initialdate.add(Duration(days: 1)));
   late int price = getproducts.priceperday;
   bool isloading = false;
  int days = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getid();
  }
   Future getid()async
  {
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    id = sharedPreferences.getString("id");
    print(id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text(getproducts.equipment) ,
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
                child: FadeInImage(
          fadeInDuration: Duration(milliseconds: 100),
          placeholder: AssetImage("assets/no.png"), image:NetworkImage(urlimagepath+getproducts.image) ,fit: BoxFit.contain,)
        ,),
              //  Image.network(urlimagepath+getproducts.image,fit: BoxFit.fill,)),
            ),
              heightspace(10),
              Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child:Text("${getproducts.firmname}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),), ),
              
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
                        child: Text(getproducts.location.capitalizeFirst!,style: TextStyle(fontSize: 13),)),
                    ],
                  ),
                  Container(
                    child: Text("Rs ${getproducts.priceperday}/day",style: TextStyle(fontSize: 13)))
              ],
              
            ),
               ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(getproducts.description,textAlign: TextAlign.center,style: TextStyle(fontSize: 15,letterSpacing: 0.5),),
              ),
              heightspace(10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Contact number : ${getproducts.phonenumber}",style: TextStyle(fontSize: 13)),
                  widthspace(10),
                ],
              ),
              heightspace(10),
              Text("Available quantity : ${getproducts.availablequantity}",style: TextStyle(fontSize: 15),),
              heightspace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  widthspace(10),
                  IconButton(onPressed: (){
                    if(quantity>1)
                   { setState(() {
                      quantity--;
                    });
                   }
                  }, icon: Icon(FontAwesomeIcons.minus,size: 15,),),
                  Container(
                    width: 50,
                    height: 25,
                    child: Center(child: Text("$quantity")),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)
                    ),
                  ),
                  IconButton(onPressed: (){
                    setState(() {
                      if(quantity<getproducts.availablequantity)
                      {quantity++;}
                    });
                  }, icon: Icon(FontAwesomeIcons.plus,size: 15,))
                ],
              ),
              
              heightspace(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Date of rental :"),
                   Container(
                   
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.black)),
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("$dateofrental"),
                    ))),
                  IconButton(onPressed: (){
                    pickdate();
                  }, icon: Icon(FontAwesomeIcons.calendar)),
                 

                ],
              ),
               heightspace(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Date of return :"),
                   Container(
                   
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.black)),
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("$dateofreturn"),
                    ))),
                  IconButton(onPressed: (){
                    pickdatereturn();
                  }, icon: Icon(FontAwesomeIcons.calendar)),
                 

                ],
              ),
              heightspace(10),
              Text("Price you have to pay : ${price*quantity*days}"),
              heightspace(15),
              Center(child: Container(
                 width: 100,
                    height: 40,
                    child:   ElevatedButton(onPressed: (){
                print("id =$id");
                setState(() {
                  isloading=true;
                });
                Serverop().hire(id!, getproducts.ownerid,getproducts.id, days, dateofrental, dateofreturn,(price*quantity*days)).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    isloading=false;
                  });
                }
                  
                 );
              
              }, child: isloading?Center(child: CircularProgressIndicator(color: Colors.white),):
              Text("Hire"),style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              ),
              ),),
            
              heightspace(20),
               

          ],
        ),
      ),
      
    );
  }
  Future pickdate() async {
    final newdate = await showDatePicker(
        context: context,
        initialDate: initialdate,
        firstDate: initialdate,
        lastDate: DateTime(DateTime.now().year + 2));
    if (newdate == null) return;
    setState(() {
      dateofrental =DateFormat("yyyy-MM-dd").format(newdate);
      dateofreturn = DateFormat("yyyy-MM-dd").format(newdate.add(Duration(days: 1)));
      days = DateTime.parse("$dateofreturn").difference(DateTime.parse("$dateofrental")).inDays;
      print(days); 
    });
  }
   Future pickdatereturn() async {
    final newdate = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.parse("$dateofrental").add(Duration(days: 1)))),
        firstDate:DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.parse("$dateofrental").add(Duration(days: 1)))),
        lastDate: DateTime(DateTime.now().year + 2));
    if (newdate == null) return;
    setState(() {
      dateofreturn = DateFormat("yyyy-MM-dd").format(newdate);
      days = DateTime.parse("$dateofreturn").difference(DateTime.parse("$dateofrental")).inDays;
      print(days);
      
    });
  }
  
}