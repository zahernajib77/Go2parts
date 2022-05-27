import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '';
import 'account.dart';
class notificationpage extends StatefulWidget {
  const notificationpage({Key? key}) : super(key: key);

  @override
  _notificationpageState createState() => _notificationpageState();
}

class _notificationpageState extends State<notificationpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 60),
                  height: MediaQuery.of(context).size.height - 40,
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.notifications),



                                  ],
                                ),
                                SizedBox(width: 20,),

                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(children: [
                                          Text('hello',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ),),
                                          SizedBox(height: 7,),
                                          Text('welcome Go2Parts'),


                                        ],),


                                      ],

                                  )],

                                )





                              ],
                            ),







                          ),
                        ],
                      ),
                      ),
                    ),
                  ),

                ),

                Positioned(
                    top: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                          height: 40,
                          color: Colors.white,
                          padding: const EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                              child: Row(

                                children: [

                                  Icon(Icons.arrow_back_ios_new, color: Colors.black),
                                  SizedBox(width: 130,),

                                  Text('notifications',style: TextStyle(
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
            )));
  }
}
