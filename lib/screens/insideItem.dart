// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animations/animations.dart';
import 'package:senior/screens/shoppingCart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'insideCategory.dart';

class InsideItem extends StatefulWidget {
  final String? itemId;
  const InsideItem(@required this.itemId);

  @override
  _InsideItemState createState() => _InsideItemState();
}

class _InsideItemState extends State<InsideItem> {
  Container MyParts(String, imageVal) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: CachedNetworkImage(
          imageUrl: String,
          fit: BoxFit.contain,
          errorWidget: (context, url, error) =>const Center(
              child: FittedBox(
            child: Text("Something went wrong!"),
          )),
          placeholder: (context, url) =>const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          ),
          imageBuilder: (context, imageProvider) => Image(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ));
  }

    Route _toCart() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ShopppingCart(),
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
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          toolbarHeight: 50,
          actions:[
            IconButton(
                      onPressed: () {
                        Navigator.of(context).push(_toCart());
                      },
                      icon: Icon(
                        Icons.shopping_basket_rounded,
                        color: Color.fromARGB(157, 0, 0, 0),
                      )),
          ]
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('items')
              .doc(widget.itemId)
              .snapshots(),
          builder: (context, AsyncSnapshot snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snap.hasError) {
              return Center(
                child: Text('Error!'),
              );
            } else {
              final data = snap.data;
              return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                    height: 250,
                                    padding: const EdgeInsets.all(0),
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: PageView.builder(
                                      itemCount: data['url'].length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return MyParts(data['url'][index], "");
                                      },
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 17.5, right: 17.5),
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data['title'],
                                        style: TextStyle(
                                            fontSize: 22,
                                            color:
                                                Color.fromARGB(255, 48, 48, 48),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      data['url'].length > 1
                                          ? Icon(Icons.swipe_outlined)
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 17.5, right: 17.5),
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   'Description',
                                      //   style: TextStyle(
                                      //       fontSize: 18,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                      // SizedBox(
                                      //   height: 5,
                                      // ),
                                      Text(
                                        data['price'] + ' USD',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orangeAccent),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 17.5, right: 17.5),
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  height: 70,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   'Description',
                                      //   style: TextStyle(
                                      //       fontSize: 18,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                      // SizedBox(
                                      //   height: 5,
                                      // ),
                                      Text(
                                        data['description'],
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 17.5, right: 17.5),
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Icon(Icons.favorite_outline_rounded,
                                              color: Colors.red),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('8')
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons
                                                .star_border_purple500_outlined,
                                            color: Colors.green,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('3.8')
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    width: MediaQuery.of(context).size.width -
                                        32.5,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(104, 192, 192, 192)
                                                  .withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: Offset(0.5,
                                              0.5), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['shopId'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'shop location',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.mode_comment_outlined,
                                          color: Colors.orangeAccent,
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  enableDrag: true,
                                                  elevation: 5,
                                                  context: context,
                                                  builder: (context) {
                                                    return OrderPopUp(
                                                        data['id'],
                                                        data['title'],
                                                        double.parse(
                                                            data['price']),
                                                        'Wheels#1Shop');
                                                  });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: const Color.fromARGB(
                                                    255, 46, 46, 46),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  75,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(
                                                  top: 15, bottom: 15),
                                              child: const Text(
                                                'Add To Cart',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                            )),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.5, right: 2.5),
                                          child: Icon(
                                              Icons.favorite_outline_rounded,
                                              color: Colors.red,
                                              size: 30),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ));
            }
          },
        )));
  }
}

class OrderPopUp extends StatefulWidget {
  final String itemId;
  final String itemTitle;
  final double itemPrice;
  final String shopName;
  const OrderPopUp(@required this.itemId, @required this.itemTitle,
      @required this.itemPrice, @required this.shopName);

  @override
  State<OrderPopUp> createState() => _OrderPopUpState();
}

class _OrderPopUpState extends State<OrderPopUp> {
  int quantity = 1;
  double totalPrice = 0;
  SharedPreferences? prefs;
  addToCart() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString("username", "naresh");
  }

  @override
  Widget build(BuildContext context) {
    totalPrice = widget.itemPrice * quantity;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      height: MediaQuery.of(context).size.height / 3,
      decoration:const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'Quantity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuantityCounter((int value) {
                setState(() {
                  quantity = value;
                });
              }),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  width: 85,
                  child: FittedBox(
                    child: Text(
                      totalPrice.toString() + ' usd',
                      style:
                         const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: ()=>
                    addToCart()
                  ,
                  child:const Text(
                    'Add to cart',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      primary:const Color.fromARGB(255, 46, 46, 46)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child:const Text(
                'Item will be added to shopping cart',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuantityCounter extends StatefulWidget {
  final Function(int) callback;
  const QuantityCounter(@required this.callback);

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  int quantity = 1;

  addOne() {
    if (quantity < 50) {
      setState(() {
        quantity++;
      });
      widget.callback(quantity);
    } else {
      return null;
    }
  }

  removeOne() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      widget.callback(quantity);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 255, 229, 196)),
                onPressed: () => removeOne(),
                child:const Icon(
                  Icons.remove,
                  size: 18,
                )),
          ),
         const SizedBox(
            width: 10,
          ),
          Container(
            width: 60,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border:
                    Border.all(width: 0.5, color:const Color.fromARGB(96, 0, 0, 0))),
            child: Center(
              child: FittedBox(
                child: Text(quantity.toString()),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          // ignore: sized_box_for_whitespace
          Container(
              height: 30,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 255, 229, 196)),
                  onPressed: () => addOne(),
                  child:const Icon(
                    Icons.add,
                    size: 18,
                  ))),
        ],
      ),
    );
  }
}
