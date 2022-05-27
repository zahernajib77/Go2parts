import 'package:flutter/material.dart';

class orderhistory extends StatefulWidget {
  const orderhistory({Key? key}) : super(key: key);

  @override
  _orderhistoryState createState() => _orderhistoryState();
}

class _orderhistoryState extends State<orderhistory> {
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

                      itemCount: 1,
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadiusDirectional.circular(10),
                          color: Colors.white,
                          // ignore: prefer_const_literals_to_create_immutables
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 196, 195, 195),
                              offset: const Offset(
                                0.5,
                                0.5,
                              ),
                              blurRadius: 2.0,
                              spreadRadius: 1.0,
                            )
                          ],
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                         
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(


                              children: [
                                Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                  children: [

                                    Container(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text('sep 22 2021'),

                                            ],




                                          ),


                                          SizedBox(width:200,),
                                          Column(
                                            children: [
                                              Text('pending'),

                                            ],
                                          ),



                                        ],


                                      ),



                                    ),


                                  ],



                                ),
                                SizedBox(height: 5,),
                                Column(
                                  children: [
                                    Row(
                                      children: [

                                        Text(' order id:20200' ),

                                      ],


                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [

                                        Text(' phone number:81523695' ),

                                      ],


                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [

                                        Text(' location: tripoli' ),

                                      ],


                                    ),

                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Text(' total bill:' ),
                                    SizedBox(width: 55,),
                                    Text(' 536' ),
                                  ],


                                )



                              ],
                            ),
                          ),
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



                          child: Row(

                            children: [

                              Icon(Icons.arrow_back_ios_new, color: Colors.black),
                              SizedBox(width: 130,),

                              Text('order history',style: TextStyle(
                                  fontSize: 18,fontWeight: FontWeight.bold
                              ),)
                            ],
                          )
                      ),
                    ))
              ],
            )));
  }
}