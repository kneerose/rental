import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musical_equipment_rental/theme.dart';
import 'package:get/get.dart';
class CardFullViewUser extends StatefulWidget {
  final String title;
  final String imagepath;
  final String description;
  final String location;
  final String price;
  const CardFullViewUser({ Key? key,required this.title,required this.imagepath,required this.description,required this.location,required this.price }) : super(key: key);

  @override
  _CardFullViewUserState createState() => _CardFullViewUserState();
}

class _CardFullViewUserState extends State<CardFullViewUser> {
  int quantity =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text(widget.title) ,
        centerTitle: true,
        elevation: 0,
        backgroundColor: kprimaryColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            heightspace(20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                child: Image.network(widget.imagepath,fit: BoxFit.fill,)),
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
                        child: Text(widget.location.capitalizeFirst!,style: TextStyle(fontSize: 13),)),
                    ],
                  ),
                  Container(
                    child: Text("Rs ${widget.price}/day",style: TextStyle(fontSize: 13)))
              ],
              
            ),
               ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.description,textAlign: TextAlign.center,style: TextStyle(fontSize: 15,letterSpacing: 0.5),),
              ),
              heightspace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Contact number : 9861287112",style: TextStyle(fontSize: 13)),
                  widthspace(10),
                ],
              ),
              heightspace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  widthspace(10),
                  IconButton(onPressed: (){
                    if(quantity>0)
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
                      quantity++;
                    });
                  }, icon: Icon(FontAwesomeIcons.plus,size: 15,))
                ],
              ),
              
              heightspace(15),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: 
              Text("Hire"),
              ),
              heightspace(10),
               

          ],
        ),
      ),
      
    );
  }
}