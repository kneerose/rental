import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:musical_equipment_rental/model/bookingmodel.dart';
import 'package:musical_equipment_rental/server/serverop.dart';
import 'package:musical_equipment_rental/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
class Notificationadmin extends StatefulWidget {
  const Notificationadmin({ Key? key }) : super(key: key);
  @override
  _NotificationadminState createState() => _NotificationadminState();
}

class _NotificationadminState extends State<Notificationadmin> {
   RefreshController _refreshController =RefreshController(initialRefresh: false);
   List<Booking> booking = [];
   List<int> notificationid =[];
   
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getid();
    fetchnotification();
   
  }
   Future getid()async
  {
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    id = sharedPreferences.getString("id");
    print(id);
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
      
       if(id==value[i]["owner_id"])
       {setState(() {
          booking.add(Booking.tojson(value[i]));
       });
       }
       
      }
      else
     {
       if(!notificationid.contains(int.parse(value[i]["id"])))
       {
         if(id==value[i]["owner_id"])
       {
         setState(() {
           booking.add(Booking.tojson(value[i]));
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
      child: booking.length!=0?ListView.builder(
        itemCount: booking.length,
        itemBuilder: (context,item)=>Container(
          //height: 100,
          padding: EdgeInsets.only(left:10,right:10,top:5,bottom:5),
          child: InkWell(
            onLongPress: (){
              _makePhoneCall('tel:${booking[booking.length-item-1].contact}');
            },
            child: notificationdesign(booking[booking.length-item-1])),
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
        child: Text("${booking.username} want to hire your ${booking.type} ${booking.equipment} for ${booking.noofdays} days from ${booking.dateofrental} to ${booking.dateofreturn} \nlongpress for phonecall",style: TextStyle(
          height: 1.5,
          letterSpacing: 1
        ),),
      ) ,
    );
  }
   Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}