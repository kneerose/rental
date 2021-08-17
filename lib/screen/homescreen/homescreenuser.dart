import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:musical_equipment_rental/main.dart';
import 'package:musical_equipment_rental/model/addlist.dart';
import 'package:musical_equipment_rental/screen/carddisplay/cardfullviewuser.dart';
import 'package:musical_equipment_rental/screen/profile/profile.dart';
import 'package:musical_equipment_rental/server/serverop.dart';
import 'package:musical_equipment_rental/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
class HomeScreenuser extends StatefulWidget {
  const HomeScreenuser({ Key? key }) : super(key: key);

  @override
  _HomeScreenuserState createState() => _HomeScreenuserState();
}

class _HomeScreenuserState extends State<HomeScreenuser> {
  String? email;
  String? location;
  String? username;
  String? contactnumber;
  RefreshController _refreshController =RefreshController(initialRefresh: false);
  List<Addlist> equipmentlist = [];
  List equipmentid =[];
  TextEditingController _title = TextEditingController();
  String urlimagepath = "https://musicalequipmentrental.000webhostapp.com/image/";
  
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
      setState(() {
         equipmentlist.add(Addlist.tojson(value[i]));
      });
      }
      else
          {
            if(!equipmentid.contains(int.parse(value[i]["id"]))) 
          { setState(() {
              equipmentlist.add(Addlist.tojson(value[i]));
            });
          }
          
    }

   
    }
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
          // widthspace(20),
          //   IconButton(onPressed: ()async{
          //     SharedPreferences preferences = await SharedPreferences.getInstance();
          //     preferences.remove("email");
          //     preferences.remove("username");
          //     preferences.remove("location");
          //     preferences.remove("contactnumber");
          //     preferences.remove("status");
          //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LogSign()), (route) => false);
          // }, icon: Icon(Icons.logout))
            widthspace(20),
          IconButton(onPressed: (){
          print(equipmentlist[1].toMap());
          }, icon: Icon(Icons.notifications),),
        ],
      ),
      body:SmartRefresher(
        controller: _refreshController,
        onRefresh: _refresh,
        child:equipmentlist.length!=0?  Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TypeAheadFormField<Addlist>(
                
                  // key: _statekey,
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  textFieldConfiguration: TextFieldConfiguration(
        
                    // focusNode: widget.focusNode,
                    controller: _title,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon:
                            Icon(
                          Icons.arrow_drop_down_outlined,
                          size: 28,
                        ),
                        labelText: 'Search equipments',
                        labelStyle: TextStyle(fontSize: 16)),
                    //onChanged: statecontroller(),
                  ),
                  suggestionsCallback: (pattern) {
                    return 
                    equipmentlist
                        .where((e) => e.title
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
                  },
        
                  // suggestions.where((item) => item.toLowerCase().contains(pattern.toLowerCase())),
                  itemBuilder: (context, suggestion) {
                    //final state = suggestion!;
                    return ListTile(
                      title: Text(suggestion.title),
                    );
                  },
                  noItemsFoundBuilder: (context) => Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        'No Equipments Found.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      _title.text = suggestion.title;
                    });
                  },
                ),
            ),
            Expanded(
              
              child: ListView.builder(
                
                itemCount: equipmentlist.length,
                itemBuilder: (context,index){
                 if(equipmentlist[equipmentlist.length-1-index].title.toLowerCase().contains(_title.text.toLowerCase()))
                {       
                return InkWell(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CardFullViewUser(title:equipmentlist[equipmentlist.length-1-index].title , imagepath: urlimagepath+equipmentlist[equipmentlist.length-1-index].filepath, description: equipmentlist[equipmentlist.length-1-index].description, location:equipmentlist[equipmentlist.length-1-index].location, price:equipmentlist[equipmentlist.length-1-index].price)));
                  },
                  child: 
                  
                  Container(
                     height: 150,
                    margin: const EdgeInsets.only(left:10,right: 10,bottom: 5,top: 5),
                    child: equipmentlistcard(equipmentlist.length-1-index)),
                );
                }
                else
                {
                  return SizedBox();
                }
                }
                ),
            ),
          ],
        ):Center(child: CircularProgressIndicator(color: kprimaryColor,),),
      )
    );
  }
   Card equipmentlistcard(int i)
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
          placeholder: AssetImage("assets/no.png"), image:NetworkImage(urlimagepath+equipmentlist[i].filepath) ,fit: BoxFit.cover,)
        ,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            heightspace(10),
            Text(equipmentlist[i].title.capitalizeFirst!,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            heightspace(10),
           Flexible(
             child: Container(
               alignment: Alignment.center,
               width: (MediaQuery.of(context).size.width/2)-8,
               child: Text(
                 equipmentlist[i].description,style: TextStyle(fontSize: 12),maxLines: 4,),
             ),
           ),
            heightspace(10),
            Row(
              
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on),
                    widthspace(5),
                    Container(
                      width: MediaQuery.of(context).size.width/5,
                      child: Text(equipmentlist[i].location.capitalizeFirst!,style: TextStyle(fontSize: 8),)),
                  ],
                ),
                widthspace(10),
                Container(
                  width:MediaQuery.of(context).size.width/6 ,
                  child: Text("Rs ${equipmentlist[i].price}/day",style: TextStyle(fontSize: 10)))
              ],
              
            ),
            heightspace(10),
            
          ],),
        )
      ],),
    );
  }
   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _title.dispose();
    _refreshController.dispose();
  }
}