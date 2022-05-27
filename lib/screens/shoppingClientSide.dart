// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:senior/screens/chat%20screens/chat.dart';
import 'package:senior/screens/insideItem.dart';

class ShopClientSide extends StatefulWidget {
  final String? shopId;
  const ShopClientSide(@required this.shopId);

  @override
  _ShopClientSideState createState() => _ShopClientSideState();
}

class _ShopClientSideState extends State<ShopClientSide> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isFollowing = false;
  User? user;
  void initState() {
    authChanged();
    super.initState();
  }

  authChanged() {
    if (auth.currentUser != null) {
      user = auth.currentUser;
      final userID = user!.uid;
      _isFollowing(userID);
    }
  }

  String chosen = 'All';
  bool upBarHeight = false;
  ScrollController mainListController = ScrollController();

  _isFollowing(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('following')
        .doc(widget.shopId)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        setState(() {
          isFollowing = true;
        });
      }
    });
  }

  follow(String shopId, String shopName, String shopAdress, String shopImageUrl,
      String userID, String userName) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('following')
        .doc(shopId)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color.fromARGB(255, 41, 41, 41),
          content: Text(
            'Already Following ' + shopName,
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else {
        DateTime now = new DateTime.now();
        DateTime date = new DateTime(now.year, now.month, now.day);
        final data = {
          "shopId": shopId,
          "shopname": shopName,
          "shopAdress": shopAdress,
          "userID": userID,
          "username": userName,
          "shopImage": shopImageUrl,
          "at":date,
          "userUrl":'',
          "orders":0
          // ignore: invalid_return_type_for_catch_error
        };
        WriteBatch writeBatch = FirebaseFirestore.instance.batch();
        CollectionReference userfollowRefs = FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('following');
        DocumentReference userFollowing = userfollowRefs.doc(shopId);
        writeBatch.set(userFollowing, data);
        CollectionReference shopfollowRefs = FirebaseFirestore.instance
            .collection('shopOwners')
            .doc(shopId)
            .collection('followers');
        DocumentReference ShopFollower = shopfollowRefs.doc(user!.uid);
        writeBatch.set(ShopFollower, data);

        writeBatch.commit().catchError((onError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color.fromARGB(255, 41, 41, 41),
            content: Text(
              'Unable to follow!',
              style: TextStyle(color: Colors.white),
            ),
          ));
          print(onError);
          return null;
        }).then((value) {
          setState(() {
            isFollowing = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color.fromARGB(255, 41, 41, 41),
            content: Text(
              'You are now following ' + shopName,
              style: TextStyle(color: Colors.white),
            ),
          ));
        });
      }
    });
  }

  unfollow(String shopId, String shopName) {
    WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    CollectionReference userfollowRefs = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('following');
    DocumentReference userFollowing = userfollowRefs.doc(shopId);
    writeBatch.delete(userFollowing);
    CollectionReference shopfollowRefs = FirebaseFirestore.instance
        .collection('shopOwners')
        .doc(shopId)
        .collection('followers');
    DocumentReference ShopFollower = shopfollowRefs.doc(user!.uid);
    writeBatch.delete(ShopFollower);

    writeBatch.commit().catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 41, 41, 41),
        content: Text(
          'Unable to unfollow! ',
          style: TextStyle(color: Colors.white),
        ),
      ));
      print(onError);
      return null;
    }).then((value) {
      setState(() {
        isFollowing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 41, 41, 41),
        content: Text(
          'unfollowed ' + shopName,
          style: TextStyle(color: Colors.white),
        ),
      ));
    });

    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(user!.uid)
    //     .collection('following')
    //     .doc(shopId)
    //     .delete()
    //     .catchError((onError) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     backgroundColor: Color.fromARGB(255, 41, 41, 41),
    //     content: Text(
    //       'Unable to unfollow! ',
    //       style: TextStyle(color: Colors.white),
    //     ),
    //   ));
    //   print(onError);
    //   return null;
    // }).then((value) {
    //   setState(() {
    //     isFollowing = false;
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     backgroundColor: Color.fromARGB(255, 41, 41, 41),
    //     content: Text(
    //       'unfollowed ' + shopName,
    //       style: TextStyle(color: Colors.white),
    //     ),
    //   ));
    // });
  }

  Route _toChat() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Chatpage(),
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

  setChosen(String chosen) {
    setState(() {
      this.chosen = chosen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('shopOwners')
            .doc(widget.shopId)
            .snapshots(),
        builder: (context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snap.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            final data = snap.data;
            return Scaffold(
                appBar: AppBar(
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.white,
                  toolbarHeight: 40,
                  title: AnimatedOpacity(
                    opacity: upBarHeight ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(data['shopname'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: [
                              isFollowing == false
                                  ? InkWell(
                                      onTap: () {
                                        if (user != null) {
                                          follow(
                                              data['uid'],
                                              data['shopname'],
                                              data['Address'],
                                              data['shopurl'],
                                              user!.uid,
                                              user!.displayName.toString());
                                        } else {
                                          var snackBar = SnackBar(
                                              content: Text(
                                                  'You need to sign up to follow'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 248, 190, 102),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        if (user != null) {
                                          unfollow(
                                              data['uid'], data['shopname']);
                                        } else {
                                          var snackBar = SnackBar(
                                              content:
                                                  Text('You need to sign up'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 204, 204, 204),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          'Unfollow',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(_toChat());
                                  },
                                  icon: Icon(
                                Icons.comment,
                                size: 20,
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                backgroundColor: Color.fromRGBO(247, 247, 242, 1),
                body: SafeArea(
                  child: NotificationListener(
                      onNotification: ((ScrollNotification notification) {
                        if (notification is ScrollUpdateNotification) {
                          if (notification.metrics.pixels > 60) {
                            if (upBarHeight == false) {
                              setState(() {
                                upBarHeight = true;
                              });
                            }
                          } else {
                            if (upBarHeight == true) {
                              setState(() {
                                upBarHeight = false;
                              });
                            }
                          }
                        }
                        return true;
                      }),
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        controller: mainListController,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    children: [
                                                      Text(data['shopname'],
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      SizedBox(height: 7),
                                                      Text(
                                                        data['Address'],
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      isFollowing == false
                                                          ? InkWell(
                                                              onTap: () {
                                                                if (user !=
                                                                    null) {
                                                                  follow(
                                                                      data[
                                                                          'uid'],
                                                                      data[
                                                                          'shopname'],
                                                                      data[
                                                                          'Address'],
                                                                      data[
                                                                          'shopurl'],
                                                                      user!.uid,
                                                                      user!
                                                                          .displayName.toString());
                                                                } else {
                                                                  var snackBar =
                                                                      SnackBar(
                                                                          content:
                                                                              Text('You need to sign up to follow'));
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                }
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10),
                                                                decoration: BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            248,
                                                                            190,
                                                                            102),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                child: Text(
                                                                  'Follow',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                if (user !=
                                                                    null) {
                                                                  unfollow(
                                                                      data[
                                                                          'uid'],
                                                                      data[
                                                                          'shopname']);
                                                                } else {
                                                                  var snackBar =
                                                                      SnackBar(
                                                                          content:
                                                                              Text('You need to sign up'));
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                }
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10),
                                                                decoration: BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            204,
                                                                            204,
                                                                            204),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                child: Text(
                                                                  'Unfollow',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(_toChat());
                                  },
                                  icon: Icon(
                                Icons.comment,
                                size: 20,
                              ))
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          )),
                                      //About us
                                      SizedBox(height: 7),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Text(
                                                  data['Description'],
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                SizedBox(height: 15),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 170,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          data['infoimage'],
                                                      fit: BoxFit.contain,
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Container(
                                                          height: 140,
                                                          color: Color.fromARGB(
                                                              113,
                                                              248,
                                                              229,
                                                              178),
                                                          child: Center(
                                                            child: Icon(Icons
                                                                .photo_camera_back_outlined),
                                                          ),
                                                        ),
                                                      ),
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              child: Image(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ))),
                          SizedBox(height: 15),
                          Container(
                            height: 40,
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                InkWell(
                                    onTap: (() => setChosen('All')),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: chosen == 'All'
                                                      ? Colors.black
                                                      : Colors.transparent))),
                                      alignment: Alignment.center,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: Text('All',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: data['categories'].length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: (() => setChosen(
                                              data['categories'][index]
                                                  .toString())),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 0.5,
                                                        color: chosen ==
                                                                data['categories']
                                                                        [index]
                                                                    .toString()
                                                            ? Colors.black
                                                            : Colors
                                                                .transparent))),
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: Text(
                                                data['categories'][index]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ));
                                    })
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height - 130,
                            child: Container(
                                color: Color.fromRGBO(247, 247, 242, 1),
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 20, bottom: 20),
                                child: NotificationListener(
                                    onNotification:
                                        ((ScrollNotification notification) {
                                      if (notification
                                          is ScrollStartNotification) {
                                        mainListController.animateTo(
                                            mainListController
                                                .position.maxScrollExtent,
                                            duration:
                                                Duration(milliseconds: 800),
                                            curve: Curves.ease);
                                      }
                                      if (notification
                                          is ScrollUpdateNotification) {
                                        if (notification.metrics.pixels ==
                                            notification
                                                .metrics.maxScrollExtent) {
                                          mainListController.animateTo(
                                              mainListController
                                                  .position.maxScrollExtent,
                                              duration:
                                                  Duration(milliseconds: 800),
                                              curve: Curves.ease);
                                        } else if (notification
                                                .metrics.pixels ==
                                            notification
                                                .metrics.minScrollExtent) {
                                          mainListController.animateTo(
                                              mainListController
                                                  .position.minScrollExtent,
                                              duration:
                                                  Duration(milliseconds: 800),
                                              curve: Curves.ease);
                                        }
                                      }
                                      return true;
                                    }),
                                    child: chosen == 'All'
                                        ? StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('shopOwners')
                                                .doc(widget.shopId)
                                                .collection('items')
                                                .snapshots(),
                                            builder:
                                                (context, AsyncSnapshot snap) {
                                              if (!snap.hasData) {
                                                return Column(children: [
                                                 const SizedBox(
                                                    height: 20,
                                                  ),
                                                 const CircularProgressIndicator(),
                                                ]);
                                              } else if (snap.hasError) {
                                                return Center(
                                                    child: Text('Error!'));
                                              } else {
                                                final data1 =
                                                    snap.data.docs;
                                                if (data1.length > 0) {
                                                  return AnimationLimiter(
                                                      child: GridView.builder(
                                                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                              maxCrossAxisExtent:
                                                                  180,
                                                              childAspectRatio:
                                                                  6 / 8,
                                                              crossAxisSpacing:
                                                                  0,
                                                              mainAxisSpacing:
                                                                  10),
                                                          itemCount:
                                                              data1.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return AnimationConfiguration
                                                                .staggeredList(
                                                              position: index,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          375),
                                                              child:
                                                                  SlideAnimation(
                                                                verticalOffset:
                                                                    50.0,
                                                                child:
                                                                    FadeInAnimation(
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            10,
                                                                        top:
                                                                            10),
                                                                    child:
                                                                        OpenContainer(
                                                                      closedElevation:
                                                                          5,
                                                                      closedBuilder:
                                                                          (context, VoidCallback openContainer) =>
                                                                              InkWell(
                                                                        onTap:
                                                                            openContainer,
                                                                        child: ItemIndividual(
                                                                            data1[index]['id'],
                                                                            data1[index]['url'][0],
                                                                            data1[index]['title'],
                                                                            data1[index]['price'],
                                                                            false),
                                                                      ),
                                                                      closedColor: Color.fromRGBO(
                                                                          247,
                                                                          247,
                                                                          242,
                                                                          1),
                                                                      openBuilder: (context,
                                                                              VoidCallback
                                                                                  _) =>
                                                                          InsideItem(data1[index]
                                                                              [
                                                                              'id']),
                                                                      transitionDuration:
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }));
                                                } else {
                                                  return Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                          'Shop has no items yet!'),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Icon(
                                                        Icons.info,
                                                        color: Color.fromARGB(
                                                            255, 245, 202, 147),
                                                      )
                                                    ],
                                                  );
                                                }
                                              }
                                            })
                                        : StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('shopOwners')
                                                .doc(widget.shopId)
                                                .collection('itemsCat')
                                                .doc('categories')
                                                .collection(chosen)
                                                .snapshots(),
                                            builder:
                                                (context, AsyncSnapshot snap) {
                                              if (!snap.hasData) {
                                                return CircularProgressIndicator();
                                              } else if (snap.hasError) {
                                                return Center(
                                                    child: Text('Error!'));
                                              } else {
                                                final data2 =
                                                    snap.data.docs;
                                                return AnimationLimiter(
                                                    child: GridView.builder(
                                                        gridDelegate:
                                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                                                maxCrossAxisExtent:
                                                                    180,
                                                                childAspectRatio:
                                                                    6 / 8,
                                                                crossAxisSpacing:
                                                                    0,
                                                                mainAxisSpacing:
                                                                    10),
                                                        itemCount: data2.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return AnimationConfiguration
                                                              .staggeredList(
                                                            position: index,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        375),
                                                            child:
                                                                SlideAnimation(
                                                              verticalOffset:
                                                                  50.0,
                                                              child:
                                                                  FadeInAnimation(
                                                                child:
                                                                    Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      bottom:
                                                                          10,
                                                                      top: 10),
                                                                  child:
                                                                      OpenContainer(
                                                                    closedElevation:
                                                                        5,
                                                                    closedBuilder:
                                                                        (context,
                                                                                VoidCallback openContainer) =>
                                                                            InkWell(
                                                                      onTap:
                                                                          openContainer,
                                                                      child: ItemIndividual(
                                                                          data2[index]
                                                                              [
                                                                              'id'],
                                                                          data2[index]['url']
                                                                              [
                                                                              0],
                                                                          data2[index]
                                                                              [
                                                                              'title'],
                                                                          data2[index]
                                                                              [
                                                                              'price'],
                                                                          false),
                                                                    ),
                                                                    closedColor:
                                                                        Color.fromRGBO(
                                                                            247,
                                                                            247,
                                                                            242,
                                                                            1),
                                                                    openBuilder: (context,
                                                                            VoidCallback
                                                                                _) =>
                                                                        InsideItem(data2[index]
                                                                            [
                                                                            'id']),
                                                                    transitionDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                500),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }));
                                              }
                                            }))),
                          )
                        ],
                      )),
                ));
          }
        });
  }
}

class ItemIndividual extends StatefulWidget {
  final String itemId;
  final String url;
  final String title;
  final String price;
  final bool liked;

  const ItemIndividual(@required this.itemId, @required this.url,
      @required this.title, @required this.price, @required this.liked);

  @override
  _ItemIndividualState createState() => _ItemIndividualState();
}

class _ItemIndividualState extends State<ItemIndividual> {
  // Route _toInsideItem(String param) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) =>
  //         new InsideItem(param),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       const begin = Offset(1, 0);
  //       const end = Offset.zero;
  //       const curve = Curves.ease;

  //       var tween =
  //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final WIDTH = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(157, 158, 158, 158),
            offset: const Offset(
              0,
              4,
            ),
            blurRadius: 2.0,
            spreadRadius: 1.0,
          )
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
              height: 115,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Text("error"),
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
                imageUrl: widget.url,
                imageBuilder: (context, imageProvider) => ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  child: Image(
                    image: imageProvider,
                    width: WIDTH,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(widget.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 2.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.logo_dev,
                        color: Colors.blueGrey,
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      widget.price,
                      style: TextStyle(fontSize: 15),
                    ),
                    widget.liked == false
                        ? Icon(
                            Icons.favorite_outline_rounded,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_rounded,
                            color: Colors.red,
                          )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
