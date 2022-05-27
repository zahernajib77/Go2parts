import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/screens/login.dart';
import '../config/config.dart';
import 'prof widgets/profile_widget.dart';
import 'prof widgets/textfield_widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  late bool isLoggedIn;
  String? phone;

  // final address = TextEditingController();
  // final phone = TextEditingController();
  // final name = TextEditingController();

  void initState() {
    database.setPersistenceEnabled(true);
    auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const loginpage()));
      }
    });
    super.initState();
  }

  Future updateUserProfileInfo() async {

    FirebaseFirestore.instance
        .collection("users")
        .doc(AutoParts.preferences!.getString(AutoParts.userUID))
        .update({
      // "name": name.toString(),
       "phone": phone.toString(),
      // "address": address.toString(),
    });
    // await AutoParts.preferences!
    //     .setString(AutoParts.userName, name.toString());
    // await AutoParts.preferences!
    //     .setString(AutoParts.userPhone, phone);
    // await AutoParts.preferences!
    //     .setString(AutoParts.userAddress, address.text);
  }

  @override
  Widget build(BuildContext context) {
    String uid = auth.currentUser!.uid.toString();
    String displayName = auth.currentUser!.displayName.toString();
    String profileUrl = auth.currentUser!.photoURL.toString();

    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 242, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Center(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .snapshots(),
            builder: (context, AsyncSnapshot snap) {
              if (!snap.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 0, 0, 0))),
                );
              } else {
                if (snap.hasData) {
                  final data = snap.data;
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 40,),
                      ProfileWidget(
                        imagePath:
                            'https://cdn.pixabay.com/photo/2016/11/18/19/07/happy-1836445_960_720.jpg',
                        isEdit: true,
                        onClicked: () async {},
                      ),
                      const SizedBox(height: 24),

                      TextFieldWidget(
                        label: 'Display Name',
                        text: data!['name'],
                        onChanged: (text) {
                          //print("zaher");
                          // setState(() {
                          //   name=name1;
                          //
                          // });


                        },
                      ),

                     // TextField(
                     //    controller: phone,
                     //
                     //    decoration: InputDecoration(
                     //      border: OutlineInputBorder(),
                     //      hintText:data!['phone'] ,
                     //    ),
                     //  ),

                      const SizedBox(height: 24),
                      TextFieldWidget(

                        label: 'Phone number',
                        text: data!['phonenumber'],
                        onChanged: (phone2) {

                          setState(() {
                            phone=phone2;


                          });

                        },
                      ),
                      const SizedBox(height: 24),
                      TextFieldWidget(
                        label: 'Adress',
                        // text: data!['address'],
                        text: data!['address'],
                        maxLines: 5,
                        onChanged: (Address2) {

                          // setState(() {
                          //   address=Address2;
                          //
                          //
                          // });

                        },
                      ),
                      const SizedBox(height: 30),
                      RaisedButton(
                        child: new Text(phone.toString()),
                        onPressed: (){

                          updateUserProfileInfo();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Profile()));
                        },
                      ),
                    ],
                  );;
                } else if (snap.connectionState == ConnectionState.none) {
                  return Center(
                    child: Column(
                      children: [
                       const Text('Check your internet connection!'),
                        const SizedBox(
                          height: 5,
                        ),
                       const  Icon(
                          Icons.error,
                          color: Colors.redAccent,
                        )
                      ],
                    ),
                  );
                } else {
                  return const loginpage();
                }
              }
            }),
        
        
      ),
    );
  }
}
