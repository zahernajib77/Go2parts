// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'account.dart';

class favourites extends StatefulWidget {
  const favourites({Key? key}) : super(key: key);

  @override
  _favouritespageState createState() => _favouritespageState();
}

class _favouritespageState extends State<favourites> {
  @override
  Widget build(BuildContext context) {
    return SizedBox();
    // return Scaffold(
    //     backgroundColor: Colors.white,
    //     body: SafeArea(
    //         child: Stack(
    //           children: [
    //             Container(
    //               margin: const EdgeInsets.only(top: 60),
    //               height: MediaQuery.of(context).size.height - 40,
    //               child: Padding(
    //                 padding:
    //                 EdgeInsets.symmetric(horizontal: 20),
    //                 child: ListView.builder(
    //                   itemCount: demoCarts.length,
    //                   itemBuilder: (context, index) => Padding(
    //                     padding: EdgeInsets.symmetric(vertical: 10),
    //                     child: Dismissible(
    //                       key: Key(demoCarts[index].product.id.toString()),
    //                       direction: DismissDirection.endToStart,
    //                       onDismissed: (direction) {
    //                         setState(() {
    //                           demoCarts.removeAt(index);
    //                         });
    //                       },
    //                       background: Container(
    //                         padding: EdgeInsets.symmetric(horizontal: 20),
    //                         decoration: BoxDecoration(
    //                           color: Color(0xFFFFE6E6),
    //                           borderRadius: BorderRadius.circular(15),
    //                         ),
    //                         child: Row(
    //                           children: [
    //                             Spacer(),
    //                             SvgPicture.asset("assets/icons/Trash.svg"),
    //                           ],
    //                         ),
    //                       ),
    //                       child: CartCard(cart: demoCarts[index]),
    //                     ),
    //                   ),
    //                 ),
    //               ),

    //             ),

    //             Positioned(
    //                 top: 0,
    //                 left: 0,
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Container(

    //                       height: 40,
    //                       color: Colors.white,
    //                       padding: const EdgeInsets.only(left: 10),
    //                       width: MediaQuery.of(context).size.width,
    //                       alignment: Alignment.centerLeft,
    //                       child: InkWell(
    //                           child: Row(

    //                             // ignore: prefer_const_literals_to_create_immutables
    //                             children: [

    //                               const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    //                               const SizedBox(width: 130,),

    //                               const Text('favourites',style: TextStyle(
    //                                   fontSize: 18,fontWeight: FontWeight.bold
    //                               ),)
    //                             ],
    //                           ),

    //                         onTap: (){
    //                           Navigator.pushReplacement(
    //                             context,
    //                             MaterialPageRoute(
    //                                 builder: (context) => AccountPage()),
    //                           );
    //                         }
    //                         ,
    //                       ),

    //                   ),
    //                 ))
    //           ],
    //         )));
  }
}
