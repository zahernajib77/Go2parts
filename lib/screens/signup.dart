import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:senior/screens/home.dart';
//import 'package:firebase/firestore.dart';

import '../config/config.dart';
import 'common/theme_helper.dart';
import 'login.dart';
import 'verifyemailpage.dart';

class signuppage extends StatefulWidget {
  const signuppage({Key? key}) : super(key: key);

  @override
  _signuppageState createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {
  double _headerHeight = 250;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  // final databaseRef = FirebaseDatabase.instance.reference();
  final email = TextEditingController();
  final phonenumber = TextEditingController();
  final displayname = TextEditingController();
  final password = TextEditingController(); //database reference object
  final confirmpassword = TextEditingController(); //database reference object

  Route _toHomePage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Homepage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Future createUser() async {
    User firebaseUser;

    await auth
        .createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        )
        // .whenComplete(() => {Navigator.of(context).push(_toHomePage())})
        .then((auth1) => {
              firebaseUser = auth1.user!,
              auth.currentUser!
                  .updateProfile(displayName: displayname.text.trim())
            })
        .catchError((error) {
      print(error);
    });
    saveUserInfoToFireStore(auth.currentUser!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color.fromARGB(255, 41, 41, 41),
      content: Text(
        'Sign up successfuly!',
        style: TextStyle(color: Colors.white),
      ),
    ));
  }

  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": displayname.text,
      "phonenumber": phonenumber.text,
      "address": '',
      "place":''
      // "url": userImage,
      // AutoParts.userCartList: ["garbageValue"],
    });
    await AutoParts.preferences!.setString("uid", fUser.uid);
    await AutoParts.preferences!.setString(AutoParts.userEmail, fUser.email!);
    // await AutoParts.preferences
    // !.setString(AutoParts.userName, firstname.text);
    // await AutoParts.preferences
    // !.setString(AutoParts.userPhone, mobile.text);
    /*await AutoParts.preferences
        !.setString(AutoParts.userAddress, 'Update your address..');*/
    // await AutoParts.preferences
    //     !.setString(AutoParts.userAvatarUrl, userImage);
    /* await AutoParts.preferences
        !.setStringList(AutoParts.userCartList, ["garbageValue"]);*/
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white, shadowColor: Colors.transparent),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Container(
                    padding:const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       const Padding(
                          padding: const EdgeInsets.only(left: 7.5),
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // ignore: prefer_const_literals_to_create_immutables
                                  boxShadow: [
                                    const BoxShadow(
                                      color: Color.fromARGB(255, 196, 195, 195),
                                      offset: Offset(
                                        0.5,
                                        0.5,
                                      ),
                                      blurRadius: 2.0,
                                      spreadRadius: 1.0,
                                    )
                                  ],
                                  border: Border.all(
                                      width: 0.5,
                                      color:
                                          Color.fromARGB(255, 155, 151, 151)),
                                  color: Colors.white),
                              child: CachedNetworkImage(
                                fit: BoxFit.contain,
                                errorWidget: (context, url, error) =>
                                  const Text("error"),
                                placeholder: (context, url) =>const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                                imageUrl:
                                    'https://res.cloudinary.com/zahernajib78/image/upload/v1645731437/Go2parts/google_1_tknxk8.png',
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                           const SizedBox(width: 20),
                            Container(
                              height: 60,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // ignore: prefer_const_literals_to_create_immutables
                                  boxShadow: [
                                   const BoxShadow(
                                      color: Color.fromARGB(255, 196, 195, 195),
                                      offset: Offset(
                                        0.5,
                                        0.5,
                                      ),
                                      blurRadius: 2.0,
                                      spreadRadius: 1.0,
                                    )
                                  ],
                                  border: Border.all(
                                      width: 0.5,
                                      color:const
                                          Color.fromARGB(255, 155, 151, 151)),
                                  color: Colors.white),
                              child: CachedNetworkImage(
                                fit: BoxFit.contain,
                                errorWidget: (context, url, error) =>
                                   const Text("error"),
                                placeholder: (context, url) =>const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                                imageUrl:
                                    'https://res.cloudinary.com/zahernajib78/image/upload/c_scale,w_68/v1645731608/Go2parts/facebook_g09ujy.png',
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              height: 60,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // ignore: prefer_const_literals_to_create_immutables
                                  boxShadow: [
                                  const BoxShadow(
                                      color: Color.fromARGB(255, 196, 195, 195),
                                      offset: Offset(
                                        0.5,
                                        0.5,
                                      ),
                                      blurRadius: 2.0,
                                      spreadRadius: 1.0,
                                    )
                                  ],
                                  border: Border.all(
                                      width: 0.5,
                                      color:const
                                          Color.fromARGB(255, 155, 151, 151)),
                                  color: Colors.white),
                              child: CachedNetworkImage(
                                fit: BoxFit.contain,
                                errorWidget: (context, url, error) =>
                                    const Text("error"),
                                placeholder: (context, url) =>const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                                imageUrl:
                                    'https://res.cloudinary.com/zahernajib78/image/upload/q_100/v1645732482/Go2parts/twitter_c9uit7.png',
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],

                          // children: [
                          //
                          // GestureDetector(
                          //
                          //
                          //         child: FaIcon(
                          //
                          //           FontAwesomeIcons.google,
                          //           size: 35,
                          //           color: Colors.red,
                          //
                          //         ),
                          //         onTap: () {
                          //
                          //         },
                          //       ),
                          //       SizedBox(width: 30),
                          //
                          //       GestureDetector(
                          //
                          //         child: FaIcon(
                          //           FontAwesomeIcons.facebook,
                          //           size: 35,
                          //           color: Colors.blue,
                          //
                          //
                          //         ),
                          //
                          //         onTap: () {
                          //
                          //         },
                          //       ),
                          //       SizedBox(width: 20,),
                          //
                          //       GestureDetector(
                          //         child: FaIcon(
                          //           FontAwesomeIcons.twitter,
                          //           size: 35,
                          //           // color: Colors.blue,
                          //         ),
                          //         onTap: () {
                          //
                          //         },
                          //       ),
                          //
                          //
                          //     ],
                        ),
                        const SizedBox(height: 30.0),
                        Container(
                          alignment: Alignment.center,
                          child:const Text(
                            'Or register with email',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                       const SizedBox(height: 20.0),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  // margin: EdgeInsets.fromLTRB(
                                  //     10, 10, 10, 10),
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'Email', 'Enter your Email '),
                                    controller: email,
                                    validator: (val) {
                                      if ((val!.isEmpty) |
                                          !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                              .hasMatch(val)) {
                                        return "Enter a valid email address";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                               const SizedBox(height: 30.0),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  // margin: EdgeInsets.fromLTRB(
                                  //     10, 10, 10, 10),
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'Display name', 'Enter your name'),
                                    controller: displayname,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Please enter your name";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  // margin: EdgeInsets.fromLTRB(
                                  //     10, 10, 10, 10),
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'Phone number', 'Enter your number'),
                                    controller: phonenumber,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Please enter your number";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  // margin: EdgeInsets.fromLTRB(
                                  //     10, 10, 10, 10),
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'Password', 'Enter your password'),
                                    controller: password,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Please enter your password";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  padding:const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  // margin: EdgeInsets.fromLTRB(
                                  //     10, 10, 10, 10),
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            ' Confirm your Password',
                                            'Confirm your password'),
                                    controller: confirmpassword,
                                    validator: (val) {
                                      if (val!.isEmpty) return 'Empty ';
                                      if (val != password.text)
                                        return 'Not Match';
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                               const SizedBox(height: 60),
                                Container(
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(100, 0, 100, 0),
                                      child: Text(
                                        'Sign up'.toUpperCase(),
                                        style:const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        createUser()
                                            .catchError((onError) => {
                                                  if (onError)
                                                    {
                                                      print("8alatttttt" +
                                                          onError),
                                                    }
                                                })
                                            .then((value) =>
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) => verifyEmailPage()
                                                    ),
                                                        (Route<dynamic> route) => false

                                                ));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ],
                    )),
              ),
             const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}
