import 'dart:async';
import 'dart:convert';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musical_equipment_rental/screen/login/signup.dart';
import 'package:musical_equipment_rental/server/serverop.dart';
import 'package:musical_equipment_rental/validator.dart';
import '../../theme.dart';
import 'package:convert/convert.dart';
class LogSign extends StatefulWidget {
  const LogSign({ Key? key }) : super(key: key);

  @override
  _LogSignState createState() => _LogSignState();
}

class _LogSignState extends State<LogSign> {
 late Timer _timer;
 GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 bool notvisibile = true;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  int _currentPage = 0;
  bool up = false;
  List<Color> colors = [Colors.white, Colors.white, Colors.white];
  List<String> titles = ["Add equipments", "Notification", "Search equipments"];
  List<String> bodies = [
    "Add and manage your equipments",
    "Get notification of your equipment rent",
    "Find available equipmets"
  ];
  List<IconData> icons = [
    FontAwesomeIcons.guitar,
    FontAwesomeIcons.bell,
    FontAwesomeIcons.search
  ];
  bool isloading=false;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(_currentPage,
          duration: Duration(milliseconds: 350), curve: Curves.easeIn);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        isloading?Center(child: CircularProgressIndicator(),):SizedBox(),
        PageView.builder(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
              itemCount: titles.length,
              itemBuilder: (context, index) => buildBoard(
                  icon: icons[index],
                  color: colors[index],
                  title: titles[index],
                  body: bodies[index])),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              padding:
                  EdgeInsets.only(top: 18, right: 10, left: 10, bottom: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sign In",
                      style: TextStyle(
                          //fontFamily: "OpenSansBold",
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.bold,
                          // color: Colors.grey.shade800,
                          fontSize: 14)),
                  heightspace(10),
                        Form(
                          key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left:10,right:10,bottom: 10),
                                    child: TextFormField( 
                                        validator: (value)
                                        {
                                          if(value!.isEmpty)
                                          {
                                            email.clear();
                                            return knullemail;
                                          
                                          }
                                          return null;
                                        },
                               controller:email ,
                                    decoration:InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical:18),
                                      prefixIcon: Icon(Icons.email),
                                      hintText: "Email address",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                      )
                                    ),
                          ),
                                  ),
                         Container(
                             padding: EdgeInsets.only(left:10,right:10),
                             child: TextFormField(
                             
                               obscureText: notvisibile,
                              controller:password,
                              validator: (value)
                              {
                                if(value!.isEmpty)
                                {
                                    return knullpass;
                                }
                                return null;
                              },
                                    decoration:InputDecoration(
                                      prefixIcon: Icon(Icons.lock),
                                      contentPadding: EdgeInsets.symmetric(vertical:18),
                                      suffixIcon: IconButton(icon:notvisibile?Icon(Icons.visibility):Icon(Icons.visibility_off),onPressed: (){
                                        setState(() {
                                          notvisibile=!notvisibile;
                                        });
                                      },),
                                     // contentPadding: ,
                                      hintText: "Password",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                      )
                                    ),
                          ),
                           ),
                          // up?Container(
                          //    alignment: Alignment.centerRight,
                          //    padding: EdgeInsets.only(right: 15),
                          //    child: Text("forgot password")):Container(),
                          heightspace(10),
                          ElevatedButton(onPressed: ()async{
                            // DataConnectionStatus status = await DataConnectionChecker().connectionStatus;
                            // if(status == DataConnectionStatus.connected)
                            //{ 
                              if(_formKey.currentState!.validate())
                             {
                               print(hex.encode(utf8.encode(password.text)).toString());
                               setState(() {
                                  isloading=true;
                               });
                              
                               Serverop().login(email.text.trim(),hex.encode(utf8.encode(password.text)).toString(),context).then((value) {
                                    isloading=false;
                                    
                               } );
                               //_email.clear();
                              // _password.clear();
                               //loading=false;
                              //  print("validated");
                                
                             }
                          //  }
                            // else
                            // {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //         SnackBar(
                            //           duration: Duration(seconds: 2),
                            //           content: Text("No internet connection!"))
                            //             );
                            //           }
                                      }, child: Text("Login"),
                                                               style: ElevatedButton.styleFrom(
                                                                 primary: kprimaryColor,
                                                                 padding: const EdgeInsets.only(left: 50,right:50),
                                                                 elevation: 5,
                                                                   shape: RoundedRectangleBorder(
                                                                     borderRadius: BorderRadius.circular(12)
                                                                   )
                                                                 )
                                                               ),
                                                               heightspace(10),
                                                             InkWell(
                                                               child: Container(child: Text("Dont have an account")),onTap: (){
                                                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                                                               },)
                                                               
                                                                    ],
                                                                  ),
                                                            ),
                                                            
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ],)
                                        );
                                      }
                                      Container buildBoard(
                                          {required IconData icon,
                                          required Color color,
                                          String? title,
                                          String? body}) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 80),
                                          height: double.infinity,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                color.withOpacity(0.3),
                                                color.withOpacity(0.3),
                                                Colors.white10,
                                                Colors.white10
                                              ])),
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                FaIcon(
                                                  icon,
                                                  size: 50,
                                                  color: kprimaryColor,
                                                ),
                                                SizedBox(height: 10),
                                                Text(title!,
                                                    style: TextStyle(
                                                        letterSpacing: 1.5,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 20)),
                                                SizedBox(height: 8),
                                                Text(body!,
                                                    style: TextStyle(
                                                        letterSpacing: 0.2,
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 13)),
                                                SizedBox(height: 60),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: List.generate(
                                                      titles.length, (index) => buildIndicator(index: index)),
                                                )
                                              ]),
                                        );
                                      }
                                       AnimatedContainer buildIndicator({required int index}) {
                                        bool isSelected = index == _currentPage ? true : false;
                                        return AnimatedContainer(
                                            duration: Duration(milliseconds: 150),
                                            margin: EdgeInsets.only(right: 8),
                                            height: isSelected ? 7 : 6,
                                            width: isSelected ? 7 : 6,
                                            decoration: BoxDecoration(
                                                color: isSelected ? kprimaryColor : Colors.grey.shade300,
                                                borderRadius: BorderRadius.circular(5),
                                                boxShadow: [
                                                  isSelected
                                                      ? BoxShadow(
                                                          color: kprimaryColor.withOpacity(0.72),
                                                          blurRadius: 4.0,
                                                          spreadRadius: 1.0,
                                                          offset: Offset(
                                                            0.0,
                                                            0.0,
                                                          ),
                                                        )
                                                      : BoxShadow(
                                                          color: Colors.transparent,
                                                        ),
                                                ]));
                                      }
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
    _pageController.dispose();
  }
                                    

}