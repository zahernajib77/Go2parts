import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:senior/screens/home.dart';
import 'package:senior/screens/profile.dart';
import 'package:senior/screens/signup.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/config.dart';
import 'AuthService.dart';
import 'account.dart';
import 'common/theme_helper.dart';
import 'forgot_password_page.dart';

class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);

  @override
  _loginpageState createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  @override
  Widget build(BuildContext context) {
    // final databaseRef = FirebaseDatabase.instance.reference();
    final name = TextEditingController();
    final password = TextEditingController();
     final googleSignIn = GoogleSignIn();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final Future<FirebaseApp> _future = Firebase.initializeApp();
    double _headerHeight = 250;
    final _formKey = GlobalKey<FormState>();

    Future readEmailSignInUserData(User fUser) async {
      FirebaseFirestore.instance
          .collection("users")
          .doc(fUser.uid)
          .get()
          .then((dataSnapshot) async {
        await AutoParts.preferences!
            .setString("uid", dataSnapshot.data()![AutoParts.userUID]);
        await AutoParts.preferences!.setString(
            AutoParts.userEmail, dataSnapshot.data()![AutoParts.userEmail]);
        await AutoParts.preferences!.setString(
            AutoParts.userName, dataSnapshot.data()![AutoParts.userName]);
        /*await AutoParts.sharedPreferences.setString(AutoParts.userAvatarUrl,
          dataSnapshot.data()[AutoParts.userAvatarUrl]);
      List<String> cartList =
      dataSnapshot.data()[AutoParts.userCartList].cast<String>();
      await AutoParts.sharedPreferences
          .setStringList(AutoParts.userCartList, cartList);*/
      });
    }

    Future saveUserGoogleSignInInfoToFirebase(User currentUser) async {
      FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
        "uid": currentUser.uid,
        "Firstname": currentUser.displayName,
        "email": currentUser.email,
        "mobile": currentUser.phoneNumber
        //"password":"update your password" ,
        //"url": currentUser.photoURL,
        //AutoParts.userCartList: ["garbageValue"],
      });
      await AutoParts.preferences!.setString("uid", currentUser.uid);
      await AutoParts.preferences!
          .setString(AutoParts.userEmail, currentUser.email.toString());
      await AutoParts.preferences!
          .setString(AutoParts.userName, currentUser.displayName.toString());
      await AutoParts.preferences!
          .setString(AutoParts.userPhone, 'Update your phone..');
      await AutoParts.preferences!
          .setString(AutoParts.userAddress, 'Update your address..');
      /*await AutoParts.preferences
        !.setString(AutoParts.userAvatarUrl, currentUser.photoURL);
    await AutoParts.preferences
        !.setStringList(AutoParts.userCartList, ["garbageValue"]);*/
    }

    //  Future init() async {
    //   SharedPreferences _preferences = await SharedPreferences.getInstance();
    // }
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


    Future<void> login(String data, String data2) async {
      // this is for the real time database
      // databaseRef.child(" logged in").push().set({'name': data, 'password': data2});

      User fUser;
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data,
        password: data2,
      ).whenComplete(() => {Navigator.of(context).push(_toHomePage())});
      /*.then((authUser) {
      fUser = authUser.user;
      readEmailSignInUserData( fUser);

    }   );*/

      fUser = userCredential.user as User;
      readEmailSignInUserData(fUser);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 41, 41, 41),
        content: Text('login successfuly!!!',style: TextStyle(color: Colors.white),),
      ));
    }


    Future init() async {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
    }
  

    // Future<bool> googleaccountSignIn(BuildContext context) async {
    //   showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) => ProgressDialog(
    //       status: "Login, Please wait....",
    //     ),
    //   );
    //   User currentUser;
    //   GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    //   if (googleSignInAccount != null) {
    //     GoogleSignInAuthentication googleSignInAuthentication =
    //         await googleSignInAccount.authentication;
    //     AuthCredential credential = GoogleAuthProvider.credential(
    //       idToken: googleSignInAuthentication.idToken,
    //       accessToken: googleSignInAuthentication.accessToken,
    //     );
    //     final UserCredential userCredential =
    //         await auth.signInWithCredential(credential);

    //     final User user = userCredential.user as User;
    //     assert(user.email != null);
    //     assert(user.displayName != null);
    //     assert(!user.isAnonymous);
    //     assert(await user.getIdToken() != null);
    //     currentUser = await auth.currentUser as User;
    //     final User googlecurrentuser = auth.currentUser as User;
    //     assert(googlecurrentuser.uid == currentUser.uid);
    //     if (googlecurrentuser != null) {
    //       saveUserGoogleSignInInfoToFirebase(googlecurrentuser)
    //           .whenComplete(() {
    //         setState(() {
    //           Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(
    //               builder: (c) => Profile(),
    //             ),
    //           );
    //         });
    //       });
    //     }
    //   }
    //   return Future.value(true);
    // }

    // Future<UserCredential> signInWithGoogle() async {
    //   // Trigger the authentication flow
    //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //   // Obtain the auth details from the request
    //   final GoogleSignInAuthentication? googleAuth =
    //       await googleUser?.authentication;

    //   // Create a new credential
    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth?.accessToken,
    //     idToken: googleAuth?.idToken,
    //   );

    //   // Once signed in, return the UserCredential
    //   return await FirebaseAuth.instance.signInWithCredential(credential);
    // }


  Route _toSignUp() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const signuppage(),
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

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,shadowColor: Colors.transparent),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Container(
                    padding:const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       const SizedBox(
                          height: 70,
                        ),
                       const Padding(
                          padding: const EdgeInsets.only(left: 7.5),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                       const SizedBox(height: 30.0),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  padding:const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  // margin: EdgeInsets.fromLTRB(
                                  //     20, 10, 20, 10),
                                  child: TextFormField(
                                    
                                    decoration: ThemeHelper().textInputDecoration(
                                        'Email', 'Enter your Email '),
                                    controller: name,
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
                                  padding:const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: ThemeHelper().textInputDecoration(
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
                               const SizedBox(height: 15.0),
                                Container(
                                  margin:const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                               const ForgotPasswordPage()),
                                      );
                                    },
                                    child: const Text(
                                      "Forgot your password?",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration:
                                      ThemeHelper().buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(100, 0, 100, 0),
                                      child: Text(
                                        'Login'.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        final user =
                                            login(name.text, password.text)
                                                .catchError((onError) => {
                                                      if (onError)
                                                        {
                                                          print("8alatttttt" +
                                                              onError),
                                                        }
                                                    })
                                                .then(
                                                  (value) =>
                                                      Navigator.of(context).pushAndRemoveUntil(_toHomePage(),(_) => false),
    
                                                  //    CupertinoAlertDialog(title: Text('login'),content: Text("Login succeful")),
                                                );
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        //   backgroundColor: Colors.black26,
                                        //   content: Text('login successfuly!!!'),
                                        // ));
    
                                      }
                                    },
                                  ),
                                ),
                               const SizedBox(height: 20.0),
                              const Text(
                                'or login with',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                               const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        height: 60,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            // ignore: prefer_const_literals_to_create_immutables
                                            boxShadow: [
                                             const BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 196, 195, 195),
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
                                                color:const Color.fromARGB(
                                                    255, 155, 151, 151)),
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
                                          imageBuilder:
                                              (context, imageProvider) => Image(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        await AuthService().signinWithGoggle().then((value){

                                          print(value);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AccountPage()


                                              ));
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            backgroundColor: Colors.black26,
                                            content: Text('login successfuly!!!'),
                                          ));

                                        });


                                      },
                                    ),
                                   const SizedBox(width: 20),
                                    InkWell(
                                      child: Container(
                                          height: 60,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // ignore: prefer_const_literals_to_create_immutables
                                              boxShadow: [
                                               const BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 196, 195, 195),
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
                                                  color:const Color.fromARGB(
                                                      255, 155, 151, 151)),
                                              color: Colors.white),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.contain,
                                            errorWidget: (context, url, error) =>
                                                Text("error"),
                                            placeholder: (context, url) =>const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                              ),
                                            ),
                                            imageUrl:
                                                'https://res.cloudinary.com/zahernajib78/image/upload/c_scale,w_68/v1645731608/Go2parts/facebook_g09ujy.png',
                                            imageBuilder:
                                                (context, imageProvider) => Image(
                                              image: imageProvider,
                                              fit: BoxFit.contain,
                                            ),
                                          )),
                                      onTap: () {
                                        print("facebook");
                                      },
                                    ),
                                   const SizedBox(width: 20),
                                    InkWell(
                                      child: Container(
                                          height: 60,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // ignore: prefer_const_literals_to_create_immutables
                                              boxShadow: [
                                               const BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 196, 195, 195),
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
                                                  color: const Color.fromARGB(
                                                      255, 155, 151, 151)),
                                              color: Colors.white),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.contain,
                                            errorWidget: (context, url, error) =>
                                               const Text("error"),
                                            placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                              ),
                                            ),
                                            imageUrl:
                                                'https://res.cloudinary.com/zahernajib78/image/upload/q_100/v1645732482/Go2parts/twitter_c9uit7.png',
                                            imageBuilder:
                                                (context, imageProvider) => Image(
                                              image: imageProvider,
                                              fit: BoxFit.contain,
                                            ),
                                          )),
                                      onTap: () {
                                        print("Twitter");
                                      },
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
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  //child: Text('Don\'t have an account? Create'),
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(text: "Don\'t have an account? "),
                                    TextSpan(
                                      text: 'Create',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).push(_toSignUp());
                                        },
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ])),
                                ),
                              ],
                            )),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
