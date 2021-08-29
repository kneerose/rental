import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:musical_equipment_rental/model/bookingmodel.dart';
import 'package:musical_equipment_rental/server/serverop.dart';
import 'package:musical_equipment_rental/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
class Notificationuser extends StatefulWidget {
  const Notificationuser({ Key? key }) : super(key: key);

  @override
  _NotificationuserState createState() => _NotificationuserState();
}

class _NotificationuserState extends State<Notificationuser> {
   RefreshController _refreshController =RefreshController(initialRefresh: false);
   List<Booking> booking = [];
   List<int> notificationid =[];
   bool isfirst = true;
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getid();
    fetchnotification();
  }
  Future fetchnotification() async
  {
    List value = await Serverop().getnotification();
    if(value.isNotEmpty)
    {
       for(int i =0;i<value.length;i++)
      {
        if(notificationid.isEmpty)
     {
       if(id==value[i]["customer_id"])
       {setState(() {
          booking.add(Booking.tojson(value[i]));
          isfirst=false;
       });
       }
       
      }
      else
     {
       if(!notificationid.contains(int.parse(value[i]["id"])))
       {
         if(email==value[i]["customer_id"])
       {
         setState(() {
           booking.add(Booking.tojson(value[i]));
           isfirst=false;
         });
       }
         
       }
     }
      }
     

    }
    else
    {
      Fluttertoast.showToast(msg: "Error in fetching notification",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM);
    }
  }
  void _refresh({String purpose = 'refresh'})async{
    setState(() {
      notificationid=booking.map((e) => e.id).toList();
    });
    fetchnotification();
     if (purpose == 'refresh') {
      _refreshController.refreshCompleted();
      setState(() {});
      print("hi");
    }
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
      appBar: AppBar(
        title: Text("Notification"),
        backgroundColor: kprimaryColor,
        centerTitle: true,
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,))
      ),
      body: SmartRefresher(controller:_refreshController,
      onRefresh: _refresh,
      child:isfirst?SizedBox(): booking.length!=0?ListView.builder(
        itemCount: booking.length,
        itemBuilder: (context,item)=>Container(
          //height: 100,
          padding: EdgeInsets.only(left:10,right:10,top:5,bottom:5),
          child: notificationdesign(booking[booking.length-item-1]),
        )):Center(child: CircularProgressIndicator(color: kprimaryColor,)),
      ),
      
    );
  }
  Card notificationdesign(Booking booking)
  {
    return Card(
      elevation: 2,
      child:Padding(
        padding: const EdgeInsets.all(10),
        child: Text("you  hired  ${booking.type} ${booking.equipment} for ${booking.noofdays} days from ${booking.dateofrental} to ${booking.dateofreturn} \nowner will contact you soon please be patience!!",style: TextStyle(
          height: 1.5,
          letterSpacing: 1
        ),),
      ) ,
    );
  }
}