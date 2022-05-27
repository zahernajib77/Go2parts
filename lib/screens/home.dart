import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:senior/screens/account.dart';
import 'package:senior/screens/brands.dart';
import 'package:senior/screens/following.dart';
import 'package:senior/screens/login.dart';
import 'package:senior/screens/search.dart';
import 'package:senior/screens/shoppingCart.dart';
import 'package:senior/screens/shoppingClientSide.dart';

class Homepage extends StatefulWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin {
    @override
  bool get wantKeepAlive => true;
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
    List categories = [
    {
      "category": "Engines",
      "url":
          "https://cdn.pixabay.com/photo/2016/11/22/23/44/porsche-1851246_960_720.jpg"
    },
    {
      "category": "Mirrors",
      "url":
          "https://cdn.pixabay.com/photo/2016/11/22/23/44/porsche-1851246_960_720.jpg"
    },
    {
      "category": "Wheels",
      "url":
          "https://cdn.pixabay.com/photo/2016/11/22/23/44/porsche-1851246_960_720.jpg"
    },
    {
      "category": "Oils",
      "url":
          "https://cdn.pixabay.com/photo/2016/11/22/23/44/porsche-1851246_960_720.jpg"
    },
    {
      "category": "Doors",
      "url":
          "https://cdn.pixabay.com/photo/2016/11/22/23/44/porsche-1851246_960_720.jpg"
    },
    {
      "category": "Accessories",
      "url":
          "https://cdn.pixabay.com/photo/2016/11/22/23/44/porsche-1851246_960_720.jpg"
    },
    {
      "category": "Roofs",
      "url":
          "https://cdn.pixabay.com/photo/2016/11/22/23/44/porsche-1851246_960_720.jpg"
    },
    {
      "category": "Lights",
      "url":
          "https://cdn.pixabay.com/photo/2016/11/22/23/44/porsche-1851246_960_720.jpg"
    }
  ];

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

  Route _toCart() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          new ShopppingCart(),
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

  Route _toAccount() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          new AccountPage(),
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

  Route _toFollowing() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => new Following(),
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

  Route _toShopCient(String param) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          new ShopClientSide(param),
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

  Route _toCategory(String param) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          new Brands(param),
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

  Route _toSearch() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => new Search(),
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
    final WIDTH = MediaQuery.of(context).size.width;
    String uid = '';
    if (user != null) {
      uid = auth.currentUser!.uid;
    }
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 247, 242, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          titleSpacing: 10,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: true,
                      elevation: 5,
                      context: context,
                      builder: (context) {
                        return const LocationSearch();
                      });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 35,
                        height: 35,
                        child:  IconButton(
                          padding:  EdgeInsets.all(0.0),
                          color: Color.fromARGB(178, 0, 0, 0),
                          icon:
                              const Icon(Icons.location_on_outlined, size: 30),
                          onPressed: () => {},
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                       const Text('Hrar',
                            style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.none,
                                color: Color.fromARGB(178, 0, 0, 0),
                                fontWeight: FontWeight.bold)),
                       const Text('Main-Street',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                                color: Color.fromARGB(178, 0, 0, 0))),
                      ],
                    ),
                   const Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(_toSearch());
                      },
                      icon: const Icon(
                        Icons.search_rounded,
                        size: 28,
                        color: Color.fromARGB(157, 0, 0, 0),
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(_toCart());
                      },
                      icon: const Icon(
                        Icons.shopping_basket_rounded,
                        color: Color.fromARGB(157, 0, 0, 0),
                        size: 28,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(_toAccount());
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey,
                      ),
                      child: const Text(
                        'Ab',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 10,
                // ),
                // Container(
                //     height: 180,
                //     width: WIDTH,
                //     padding:
                //         const EdgeInsets.only(top: 10, left: 10, right: 10),
                //     child: CachedNetworkImage(
                //       fit: BoxFit.contain,
                //       imageUrl:
                //           'https://cdn.pixabay.com/photo/2016/11/22/23/44/porsche-1851246_960_720.jpg',
                //       errorWidget: (context, url, error) => Text("error"),
                //       placeholder: (context, url) => Center(
                //         child: CircularProgressIndicator(
                //           color: Colors.black,
                //         ),
                //       ),
                //       imageBuilder: (context, imageProvider) => ClipRRect(
                //         borderRadius: BorderRadius.circular(5),
                //         child: Image(
                //           image: imageProvider,
                //           width: WIDTH,
                //           height: 180,
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     )),
              const Padding(
                  padding: EdgeInsets.only(left: 10, top: 30, bottom: 15),
                  child: Text('Common cars parts',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(178, 0, 0, 0))),
                ),
                // Container(
                //   height: 45,
                //   child: ListView.builder(
                //       scrollDirection: Axis.horizontal,
                //       physics: BouncingScrollPhysics(),
                //       padding: const EdgeInsets.only(
                //           left: 12.5, top: 15, right: 12.5),
                //       // ignore: prefer_const_literals_to_create_immutables
                //       itemCount: 10,
                //       itemBuilder: (context, index) => GestureDetector(
                //             child: Container(
                //               padding:
                //                   const EdgeInsets.only(left: 10, right: 10),
                //               margin: const EdgeInsets.only(right: 7.5),
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   border: Border.all(
                //                       width: 0.5,
                //                       color:
                //                           Color.fromARGB(255, 141, 140, 140)),
                //                   borderRadius: BorderRadius.circular(5)),
                //               child: Center(
                //                   child: Text(
                //                 'BMW',
                //                 style: TextStyle(fontSize: 12),
                //               )),
                //             ),
                //             onTap: () {
                //               print("Tapped on container");
                //             },
                //           )),
                // ),
                Container(
                  height: 220,
                  margin: const EdgeInsets.only(top: 5),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(_toCategory('Mirrors'));
                                },
                                child: Container(
                                  height: 60,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      boxShadow: [
                                       const BoxShadow(
                                          color: Color.fromARGB(
                                              255, 240, 239, 239),
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
                                  child: Image.asset(
                                    'images/disc.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: FittedBox(
                                  child: Text(categories[index]['category']
                                      .toString()),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ),
                user != null
                    ? StreamBuilder<Object>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('following')
                            .limit(5)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snap) {
                          if (!snap.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.black),
                            );
                          } else if (snap.hasError) {
                            return const Center(child: Text('Error'));
                          } else {
                            final data = snap.data.docs;
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                    const Text('Followed shops',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  178, 0, 0, 0))),
                                      data.length > 0
                                          ? InkWell(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(_toFollowing());
                                              },
                                              child:const Text(
                                                'See all',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 68, 171, 255)),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                                Container(
                                  width: WIDTH,
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  height: 200,
                                  child: data.length > 0
                                      ? Swiper(
                                          duration: 1000,
                                          loop: false,
                                          index: 1,
                                          autoplayDisableOnInteraction: true,
                                          autoplay: true,
                                          pagination: const SwiperPagination(),
                                          control: const SwiperControl(
                                              iconNext: null,
                                              iconPrevious: null),
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            return CachedNetworkImage(
                                                imageUrl: data[index]
                                                    ['shopImage'],
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Container(
                                                      width: WIDTH - 10,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              width: 0.5,
                                                              color:const Color
                                                                  .fromARGB(
                                                                      255,
                                                                      155,
                                                                      151,
                                                                      151))),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      height: 100,
                                                      child:const Center(
                                                        child:
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                placeholder: (context, url) =>
                                                   const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                imageBuilder: (context,
                                                        imageProvider) =>
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(_toShopCient(
                                                                data[index][
                                                                    'shopId']));
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            colorFilter:
                                                                 ColorFilter
                                                                        .mode(
                                                                    Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                                    BlendMode
                                                                        .dstATop),
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.black,
                                                          border: Border.all(
                                                              width: 0.5,
                                                              color:const Color
                                                                  .fromARGB(
                                                                      255,
                                                                      155,
                                                                      151,
                                                                      151)),
                                                        ),
                                                        margin: const EdgeInsets
                                                            .only(right: 0),
                                                        width: (WIDTH - 10),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data[index][
                                                                    'shopname'],
                                                                style:const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Text(
                                                                data[index][
                                                                    'shopAdress'],
                                                                style:const TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            178,
                                                                            236,
                                                                            235,
                                                                            235),
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ));
                                          })
                                      : Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadiusDirectional
                                                    .circular(10),
                                            color: Colors.white,
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
                                          ),
                                          child: Center(
                                              child: Column(
                                            children: [
                                            const  SizedBox(
                                                height: 25,
                                              ),
                                              Container(
                                                width: 140,
                                                child: Image.asset(
                                                  'images/pablo-977.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            const  SizedBox(
                                                height: 5,
                                              ),
                                             const Text(
                                                'No followings yet!',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                        ),
                                ),
                              ],
                            );
                          }
                        })
                    : const SizedBox(),
               const Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Text('Shops near you',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(178, 0, 0, 0))),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('shopOwners')
                          .snapshots(),
                      builder: (context, AsyncSnapshot snap) {
                        if (snap.hasData) {
                          final shops = snap.data.docs;
                          return ListView.builder(
                              padding:const EdgeInsets.only(top: 10),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: shops.length,
                              itemBuilder: (context, index) => (Container(
                                  width: 100,
                                  height: 295,
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(10),
                                    color: Colors.white,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    boxShadow: [
                                     const BoxShadow(
                                        color:
                                            Color.fromARGB(255, 196, 195, 195),
                                        offset: Offset(
                                          0.5,
                                          0.5,
                                        ),
                                        blurRadius: 2.0,
                                        spreadRadius: 1.0,
                                      )
                                    ],
                                  ),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            _toShopCient(shops[index]['uid']));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: 180,
                                              child: ClipRRect(
                                                  borderRadius:
                                                     const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.contain,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                           const Text("error"),
                                                    placeholder:
                                                        (context, url) =>
                                                           const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    imageUrl: shops[index]
                                                        ['shopurl'],
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Image(
                                                      image: imageProvider,
                                                      width: WIDTH,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ))),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        shops[index]
                                                            ['shopname'],
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 2.5,
                                                              bottom: 2.5),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                              shops[index]
                                                                      ['rating']
                                                                  .toString(),
                                                              style:const TextStyle(
                                                                  fontSize:
                                                                      16)),
                                                         const Icon(
                                                            Icons
                                                                .star_border_outlined,
                                                            color: Colors.green,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                               const SizedBox(height: 2.5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(shops[index]
                                                        ['Address']),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, bottom: 10),
                                                  child: Container(
                                                      height: 1,
                                                      color: const Color.fromARGB(
                                                          162, 158, 158, 158)),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.card_travel_sharp,
                                                      color: Color.fromARGB(
                                                          255, 255, 109, 64),
                                                    ),
                                                   const SizedBox(width: 10),
                                                    Text(
                                                        'Something interresting about the shop',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300))
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )))));
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                )
              ],
            ))
          ],
        ));
  }
}

class LocationSearch extends StatefulWidget {
  const LocationSearch({Key? key}) : super(key: key);

  @override
  _LocationSearchState createState() => _LocationSearchState();
}
class _LocationSearchState extends State<LocationSearch> {
  var client = MeiliSearchClient('http://18.206.151.219/', 'masterKey');
  List? searchs;

  List suggestedPlaces = [
    {"place": "beirut", "region": "South"},
    {"place": "Sayda", "region": "South"},
    {"place": "Halba", "region": "North"},
    {"place": "Tripoli", "region": "North"},
    {"place": "Qalamoun", "region": "North"},
  ];

  searchItems(String searched) async {
    var search = await client.getIndex('places');
    setState(() {
      search.search(searched, limit: 8).then((value) => searchs = value.hits);
    });
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
      child: Container(
        padding: const EdgeInsets.only(top: 5),
        height: MediaQuery.of(context).size.height / 1.5,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14), topRight: Radius.circular(14))),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              title: const Text('Your place'),
              actions: [
                IconButton(
                  icon:const Icon(Icons.location_on_outlined),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.5),
                child: TextFormField(
                  onChanged: (change) {
                    searchItems(change);
                  },
                  decoration: const InputDecoration(
                    contentPadding:
                         EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(),
                    hintText: 'Search place',
                  ),
                ),
              ),
            ),
            searchs == null
                ? const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 12.5, right: 10, top: 15, bottom: 0),
                      child: Text(
                        'Sugested',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : const SizedBox(),
            searchs != null
                ? SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ListTile(
                        title: Text(
                          searchs![index]['place'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          searchs![index]['region'],
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.change_circle_outlined)),
                      );
                    }, childCount: searchs!.length),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ListTile(
                        title: Text(
                          suggestedPlaces[index]['place'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          suggestedPlaces[index]['region'],
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.change_circle_outlined)),
                      );
                    }, childCount: suggestedPlaces.length),
                  )
          ],
        ),
      ),
    );
  }
}
