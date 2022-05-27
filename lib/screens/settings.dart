import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'account.dart';
import 'notifications.dart';
class settingspage extends StatefulWidget {
  const settingspage({Key? key}) : super(key: key);

  @override
  _settingspageState createState() => _settingspageState();
}

class _settingspageState extends State<settingspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(



     // appBar: AppBar(
     //    // backgroundColor: Colors.white,
     //
     //   title: Text('Settings' ,style: TextStyle(fontSize: 20,), ),
     //   leading: IconButton( icon: Icon(
     //         Icons.arrow_back,
     //         // color: Colors.white,
     //       ),
     //       onPressed: () {
     //         // do something
     //       },),
     //
     //
     //
     //
     // ),

      body:SafeArea(
child: Stack(
  children: [
    Container( margin: const EdgeInsets.only(top: 40),
        height: MediaQuery.of(context).size.height - 40,
      child:Text('Settings list')  ),

    Positioned(
        top: 0,
        left: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(

            height: 40,
            padding: const EdgeInsets.only(left: 10),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,

            child: InkWell(
              child:  Row(

                children: [

                  Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  SizedBox(width: 110,),

                  Text('Settings',style: TextStyle(
                      fontSize: 18,fontWeight: FontWeight.bold
                  ),)
                ],
              ),
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountPage()),
                );
              }
              ,
            ),

          ),
        ))


  ],
),
      )

       );
  }
}


