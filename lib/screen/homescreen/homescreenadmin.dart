import 'dart:io';
import 'dart:ui';

import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musical_equipment_rental/model/addlist.dart';
import 'package:musical_equipment_rental/screen/carddisplay/cardfullviewadmin.dart';
import 'package:musical_equipment_rental/screen/profile/profile.dart';
import 'package:musical_equipment_rental/server/serverop.dart';
import 'package:musical_equipment_rental/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../theme.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? email;
  String? location;
  String? username;
  String? contactnumber;
  String?  status;
  String? imagepath;
  File? image;
  List equipmentid=[];
  bool isuploading = false;
  bool isfirst = true;
  //bool isequipmentadded = false;
  int count = 0;
  bool ispictureloading = false;
  List<Addlist> equipmentlist = [];
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _type = TextEditingController();
  TextEditingController _quantity = TextEditingController();
   TextEditingController _price = TextEditingController();
  String urlimagepath = "https://musicalequipmentrental.000webhostapp.com/image/";
  RefreshController _refreshController =RefreshController(initialRefresh: false);
 
  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    getshare();
    fetch();
   
  }


  Future getshare()async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
    email=sharedPreferences.getString("email");
    location = sharedPreferences.getString("location");
    username = sharedPreferences.getString("username");
    contactnumber= sharedPreferences.getString("contactnumber");
    status = sharedPreferences.getString("status");
    });
  
  }
  Future fetch()async{
     DataConnectionStatus status = await DataConnectionChecker().connectionStatus;
    if(status==DataConnectionStatus.connected)
    {print("i am in");
   List value = await Serverop().getequipmentsserver();
  if(value.isNotEmpty)
  {
    for(int i=0;i<value.length;i++)
    {
        if(equipmentid.isEmpty)
        {
          if(location!.toUpperCase().trim()==value[i]["location"].toUpperCase().trim())
         { setState(() {
              equipmentlist.add(Addlist.tojson(value[i]));
            });
         }
        }
          else
          {
            if(!equipmentid.contains(int.parse(value[i]["id"])))
            {
              if(location!.toUpperCase().trim()==value[i]["location"].toUpperCase().trim())
          { setState(() {
              equipmentlist.add(Addlist.tojson(value[i]));
            });
          }
        
          }
    }
    
    
   
    }
    setState(() {
      isfirst=false;
    });
  }
  }
  else
  {
  ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text("No internet connection!"))
              );
  }
    
  }
  void _refresh({String purpose = 'refresh'}) 
  {
    setState(() {
      equipmentid = equipmentlist.map((e) => e.id).toList();
    });
    
    print(equipmentid);
    fetch();
    print(location!.capitalizeFirst!.trim());
    for(int i=0;i<equipmentlist.length;i++)
    { 
      print(equipmentlist[i].location.trim());

    }
   
    if (purpose == 'refresh') {
      _refreshController.refreshCompleted();
      setState(() {});
      print("hi");
    }
  }
  


  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
        }, icon: Icon(Icons.account_circle_rounded,size: 30,)),
        backgroundColor: kprimaryColor,
        title: Text("${username!.capitalizeFirst}"),
        actions: [
          //Center(child: Text("$status")),
          // widthspace(20),
          //   IconButton(onPressed: ()async{
          //     SharedPreferences preferences = await SharedPreferences.getInstance();
          //     preferences.remove("email");
          //     preferences.remove("username");
          //     preferences.remove("location");
          //     preferences.remove("contactnumber");
          //     preferences.remove("status");
          //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LogSign()), (route) => false);
          // }, icon: Icon(Icons.logout)),
          widthspace(20),
          IconButton(onPressed: (){
           
          }, icon: Icon(Icons.notifications),),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        // _description.clear();
        //               _quantity.clear();
        //               _title.clear();
        //               _type.clear();
         showModalBottomSheet(
            backgroundColor: Colors.transparent,
            useRootNavigator: false,
            isScrollControlled: true,
            isDismissible: false,

            context: context, builder: (context)=>
               StatefulBuilder(
          builder: (BuildContext context, StateSetter setstate )=>equipmentadd(setstate,"add",equipmentlist[0])));
      },
      backgroundColor: kprimaryColor,
      child: Icon(Icons.add),
      ),
      body:
      SmartRefresher(
        controller: _refreshController,
        onRefresh: _refresh,
        child:isfirst?Center(child:CircularProgressIndicator(),): equipmentlist.isNotEmpty? ListView.builder(
          itemCount: equipmentlist.length,
          itemBuilder: (context,item){
              return  InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CardFullViewAdmin(title:equipmentlist[equipmentlist.length-item-1].title.trim().capitalizeFirst! , imagepath:urlimagepath+equipmentlist[equipmentlist.length-item-1].filepath, description: equipmentlist[equipmentlist.length-item-1].description, location:equipmentlist[equipmentlist.length-item-1].location, price:equipmentlist[equipmentlist.length-item-1].price, quantity: equipmentlist[equipmentlist.length-item-1].quantity)));
                },
                child: Container(
                        height: 150,
                        margin: const EdgeInsets.only(left:10,right: 10,bottom: 5,top: 5),
                        child: equipmentlistcard(equipmentlist[equipmentlist.length-item-1],context,setState)),
              );
            }
            // else
            // {
            //   return SizedBox();
            // }
       // }
        ):
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      
        Center(child: Icon(FontAwesomeIcons.listAlt,size: 150,color: kprimaryColor,)),
          heightspace(30),
        // Flexible(child: Image(image: AssetImage("assets/signup/signup.jpg"))),
        Text("Nothing to show",style: TextStyle(fontSize:20 ),),
          heightspace(30),
        Text("please Add equipments for rent")
      ],),
      )
     
    );
  }
 equipmentadd(StateSetter setstate,String purpose,Addlist addlist)
  {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
       margin: EdgeInsets.only(left: 5,right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          )
        ),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                heightspace(10),
              IconButton(onPressed: (){
                Navigator.pop(context);
                _title.clear();
                _quantity.clear();
                _type.clear();
                _description.clear();
                image = null;
              }, icon: Icon(Icons.clear)),
                //heightspace(10),
                Container(
                    margin: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _title,
                    validator: (value)
                    {
                      if(value=="" || value!.isEmpty)
                      {
                        return knull;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black),
                    
                  ),
                  child:purpose=="update"?Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.network(urlimagepath+imagepath!),
                  ): (image==null)? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ispictureloading?CircularProgressIndicator(color: kprimaryColor,):
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(onPressed: (){
                                  setstate((){
                       ispictureloading=true;
                     });
                     filepickfromcamera().then((value) => {
                       if(value==null)
                       {
                         setstate((){
                            image=null;
                            ispictureloading=false;
                         })
                       }
                       else
                        setstate(() {
                            image = File(value.path);
                           imagepath = value.path;
                           ispictureloading=false;
                           
                        })
                     });
                              }, icon: Icon(FontAwesomeIcons.camera,size: 50,)),
                              IconButton(icon: Icon(FontAwesomeIcons.solidImage,size: 50,),onPressed: (){

                                  setstate((){
                       ispictureloading=true;
                     });
                     filepickfromgallery().then((value) => {
                       if(value==null)
                       {
                         setstate((){
                            image=null;
                            
                         })
                       }
                       else
                        setstate(() {
                            image = File(value.path);
                           imagepath = value.path;
                           ispictureloading=false;
                          
                        })
                     });
                              },),
                            ],
                          ),
                            heightspace(30),
                      Text("Import picture"),
                        ],
                        
                      )
                       
                    ],
                  ):
                ispictureloading?Center(child: CircularProgressIndicator(color: kprimaryColor,)) :InkWell(
                  onLongPress: (){
                    setstate((){
                      image=null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Image.file(image!,fit: BoxFit.cover),
                  ),
                )
                 
                   
                ),
                Container(
                    margin: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value)
                    {
                      if(value=="" || value!.isEmpty)
                      {
                        return knull;
                      }
                      return null;
                    },
                    controller: _type,
                    decoration: InputDecoration(
                      labelText: "Type",
                      
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                  child: TextFormField(
                    
                    maxLines: 5,
                    validator: (value)
                    {
                      if(value=="" || value!.isEmpty)
                      {
                        return knull;
                      }
                      return null;
                    },
                    controller: _description,
                    decoration: InputDecoration(
                      labelText: "Description",
                      alignLabelWithHint: true,
                      
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value)
                    {
                      if(value=="" || value!.isEmpty)
                      {
                        return knull;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: _quantity,
                    decoration: InputDecoration(
                      labelText: "Quantity",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                    ),
                  ),
                ),
                 Container(
                    margin: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value)
                    {
                      if(value=="" || value!.isEmpty)
                      {
                        return knull;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: _price,
                    decoration: InputDecoration(
                      labelText: "Price_per_day",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(onPressed: (){
                      if(_key.currentState!.validate() && image!=null)
                      {
                        print("validated");
                        setstate((){
                             isuploading=true;
                        }  );
                           // count++;
                            print("$image");
                            print("${_title.text}");
                            print("${_description.text}");
                            print("$location");
                           purpose=="add"? Serverop().addequipmentsserver(_title.text, _type.text, _description.text, _quantity.text, image!.path,location!,_price.text).then((value) => {
                              setstate((){
                                isuploading=false;
                                Navigator.pop(context,count);
                                      _type.clear();
                                _title.clear();
                                _description.clear();
                                _quantity.clear();
                                _price.clear();
                                image=null;
                              })
                            }):Serverop().edit(_title.text, _type.text, _description.text, _quantity.text,_price.text,addlist.id.toString()).then((value) => {
                              setstate(()
                              {
                                 isuploading=false;
                                 setState(() {
                                    equipmentlist.remove(addlist);
                                 });
                                Navigator.pop(context,count);
                                      _type.clear();
                                _title.clear();
                                _description.clear();
                                _quantity.clear();
                                _price.clear();
                                image=null;
                              })
                            });
                         
                        
                       
                      }
                      else if (imagepath==null)
                      {
                        Fluttertoast.showToast(msg: "Please add image",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
                      }
                    }, child:isuploading?Center(child: CircularProgressIndicator(color: Colors.white,),): purpose=="add"?Text("Submit"):Text("Update"),style: ElevatedButton.styleFrom(
                      primary: kprimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      //padding: EdgeInsets.symmetric(horizontal: 50,vertical: 13),
                    ),),
                  ),
                )
            
                
              ],
            ),
          ),
        ),
      ),
    );
   
  }
 Card equipmentlistcard(Addlist addlist,BuildContext context,StateSetter setstate)
  {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      Container(
        //alignment: Alignment.center,
        width: MediaQuery.of(context).size.width/3,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 1.0
            )
          ]
        ),
        child:FadeInImage(
          fadeInDuration: Duration(milliseconds: 100),
          placeholder: AssetImage("assets/no.png"), image:NetworkImage(urlimagepath+addlist.filepath) ,fit: BoxFit.cover,)
        ,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            heightspace(10),
        
            Stack(
              children: [
                Text(addlist.title.trim().capitalizeFirst!,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                Container(
                  width: MediaQuery.of(context).size.width/2-18,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          _title.text=addlist.title;
                          _type.text=addlist.type;
                          _description.text=addlist.description;
                          _quantity.text = addlist.quantity;
                          _price.text=addlist.price;
                          imagepath=addlist.filepath;
                          image = File(imagepath!);
                           showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    useRootNavigator: false,
                    isScrollControlled: true,
                    isDismissible: false,

                    context: context, builder: (context)=>
                      StatefulBuilder(
                  builder: (BuildContext context, StateSetter setstate )=>
                          equipmentadd(setstate, "update",addlist)));
                        },
                        child: Icon(Icons.edit,size: 18,color: kprimaryColor,)),
                        widthspace(10),
                      InkWell(
                        onTap: (){
                          showDialog(
                              context: this.context,
                              builder: (context) => deletecard(addlist));
                         
                        },
                        child: Icon(Icons.delete,size: 18,color: kprimaryColor,)),
                    ],
                  )),
              ],
            ),
            heightspace(10),
           Flexible(
             child: Container(
               alignment: Alignment.center,
               width: (MediaQuery.of(context).size.width/2)-8,
               child: Text(
                 addlist.description,style: TextStyle(fontSize: 12),maxLines: 4,),
             ),
           ),
            heightspace(10),
            Row(
              
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on,color: kprimaryColor,),
                    widthspace(5),
                    Container(
                      width: MediaQuery.of(context).size.width/5,
                      child: Text(addlist.location.capitalizeFirst!,style: TextStyle(fontSize: 8),)),
                  ],
                ),
                widthspace(10),
                Container(
                  width:MediaQuery.of(context).size.width/6 ,
                  child: Text("Rs ${addlist.price}/day",style: TextStyle(fontSize: 10)))
              ],
              
            ),
            heightspace(10),
            
          ],),
        )
      ],),
    );
  }
  Widget deletecard(Addlist addlist) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
                top: -40,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.warning, size: 30, color: Colors.white),
                )),
            Container(
              height: 170,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 10),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Center(
                          child: Text(
                        "Delete the box?",
                        style: TextStyle(fontSize: 20),
                      )),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                // Serverop().deleteimage(addlist.filepath);
                               Serverop().delete(addlist, context).then((value) => {
                            setState((){
                                 equipmentlist.remove(addlist);
                                 
                            })
                           
                          });
                                Navigator.pop(this.context);
                              },
                              child: Text("Yes")),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(this.context);
                              },
                              child: Text("No")),
                        ],
                      )
                    ],
                  )),
            )
          ],
        ));
  }

  Future<XFile?> filepickfromgallery() async
  {
     return await ImagePicker().pickImage(source: ImageSource.gallery);
  }
  Future<XFile?> filepickfromcamera() async{
    return await ImagePicker().pickImage(source: ImageSource.camera);
  }
   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _description.dispose();
    _quantity.dispose();
    _title.dispose();
    _type.dispose();
    _price.dispose();
    _refreshController.dispose();
  }
}