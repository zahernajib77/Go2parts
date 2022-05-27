// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senior/screens/favourites.dart';
import 'package:senior/screens/login.dart';
import 'package:senior/screens/notifications.dart';
import 'package:senior/screens/orderhistory.dart';
import 'package:senior/screens/profile.dart';
import 'package:senior/screens/settings.dart';
import 'home.dart';
import 'map.dart';
// import 'package:go_to_parts/widgets/profile/profile.dart';

// import '../home.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  void initState() {
    authChanged();
    super.initState();
  }

  authChanged() {
    auth.authStateChanges().listen((event) {
      if (event != null) {
        setState(() {
          user = event;
        });
      }
    });
  }

    Route _toLogin() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => new loginpage(),
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

    Route _toProfile() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Profile(),
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




  @override
  Widget build(BuildContext context) {
    String displayName = '';
    String email = '';
    if (user != null) {
      displayName = user!.displayName.toString();
      email = user!.email.toString();
    }
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          toolbarHeight: 50,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
          children: [
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: MediaQuery.of(context).size.height - 40,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          InkWell(
                              onTap: () {
                                if(user!=null){
                                   Navigator.of(context).push(
                                                _toProfile()
                                              );
                                }else{
                                   Navigator.of(context).push(
                                                _toLogin()
                                              );
                                }
                              },
                              child: user != null ? Container(

                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.5, color: Colors.grey))),
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          displayName,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 51, 51, 51),
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          email,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        InkWell(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Text(
                                                  'View Profile',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(width: 1),
                                                Icon(
                                                  Icons.arrow_right,
                                                  color: Colors.red,
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                _toProfile()
                                              );
                                            }),
                                      ],
                                    ),
                                    Icon(
                                      Icons.account_circle,
                                      size: 100,
                                      color:
                                          Color.fromARGB(255, 247, 174, 78),
                                    )
                                  ],
                                ),
                              )
                              :
                              Container(

                                decoration: BoxDecoration(                              
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.5, color: Colors.grey))),
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Go to profile',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 51, 51, 51),
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        
                                        SizedBox(
                                          height: 5,
                                        ),
                                        InkWell(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Text(
                                                  'Sign in',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(width: 1),
                                                Icon(
                                                  Icons.arrow_right,
                                                  color: Colors.red,
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                _toLogin()
                                              );
                                            }),
                                      ],
                                    ),
                                    Icon(
                                      Icons.account_circle,
                                      size: 100,
                                      color:
                                          Color.fromARGB(255, 247, 174, 78),
                                    )
                                  ],
                                ),
                              )
                              ),
                          Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.5, color: Colors.grey))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Icon(Icons.settings_outlined),
                                      SizedBox(height: 5),
                                      Text('Settings')
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const settingspage()),
                                    );
                                  },
                                ),
                                InkWell(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Icon(Icons.ring_volume_outlined),
                                      SizedBox(height: 5),
                                      Text('Notifications')
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const notificationpage()),
                                    );
                                  },
                                ),
                                InkWell(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Icon(Icons.history_outlined),
                                      SizedBox(height: 5),
                                      Text('Orders')
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const orderhistory()),
                                    );
                                  },
                                ),
                                InkWell(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.favorite_border),
                                      SizedBox(height: 5),
                                      Text('Favorites')
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const favourites()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               const Text('Table bookings'),
                               const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color:const Color.fromARGB(
                                                  204, 240, 239, 239),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Icon(Icons.book_outlined,color: Colors.green,)),
                                     const SizedBox(
                                        width: 10,
                                      ),
                                    const  Text(
                                        'Become a Go2Parts shop',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const loginpage()),
                                    );
                                  },
                                ),
                               const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                204, 240, 239, 239),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child:
                                           const Icon(Icons.help_outline_outlined)),
                                   const SizedBox(
                                      width: 10,
                                    ),
                                   const Text(
                                      'Table Reservation Help',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  204, 240, 239, 239),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child:const Icon(
                                              Icons.help_outline_outlined)),
                                     const SizedBox(
                                        width: 10,
                                      ),
                                     const Text(
                                        'About',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Map_page()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: InkWell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 const Text('Account'),
                                 const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  204, 240, 239, 239),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Icon(Icons.logout_outlined,color: Colors.red,)),
                                     const SizedBox(
                                        width: 10,
                                      ),
                                     const Text(
                                        'Logout',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              onTap: () async {
                                SystemNavigator.pop();
                                await FirebaseAuth.instance.signOut();
                                print('Logout succesful');
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
          ],
        )));
  }
}
