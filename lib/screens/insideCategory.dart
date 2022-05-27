// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/screens/insideItem.dart';
import 'package:senior/screens/search.dart';
import 'package:senior/screens/shoppingCart.dart';
import 'package:senior/screens/shoppingClientSide.dart';

class insidecategory extends StatefulWidget {
  final String? category;
  final String? brand;
  const insidecategory(@required this.category,@required this.brand);

  @override
  _insidecategoryState createState() => _insidecategoryState();
}

class _insidecategoryState extends State<insidecategory> {
  Route _toSearch() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Search(),
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
    final WIDTH = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 247, 242, 1),
        body: SafeArea(
            child: RefreshIndicator(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                        shadowColor: Colors.transparent,
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        pinned: true,
                        floating: true,
                        forceElevated: true,
                        titleSpacing: 7.5,
                        title: Container(
                          height: 50,
                          width: WIDTH,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Center(
                                child: Text(
                                  widget.category as String,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              )),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(_toCart());
                                    },
                                    icon:const Icon(Icons.shopping_basket_rounded,
                                        color:
                                            Color.fromARGB(255, 31, 31, 31))),
                              )
                            ],
                          ),
                        ),
                        bottom: PreferredSize(
                          child: Container(
                              width: WIDTH,
                              height: 55,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              color: Colors.white,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(_toSearch());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 250, 249, 249),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 0.5,
                                          color:const Color.fromARGB(
                                              255, 141, 140, 140))),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.search_outlined,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                     const Text(
                                        'Search for...',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                          preferredSize: Size.fromHeight(55),
                        )),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: Container(
                    //       height: 30,
                    //       margin: const EdgeInsets.only(top: 7.5, bottom: 15),
                    //       padding: const EdgeInsets.only(left: 10),
                    //       child: ListView.builder(
                    //           shrinkWrap: true,
                    //           scrollDirection: Axis.horizontal,
                    //           itemCount: 10,
                    //           itemBuilder: (context, index) {
                    //             return GestureDetector(
                    //               child: Container(
                    //                 padding: const EdgeInsets.only(
                    //                     left: 10, right: 10),
                    //                 margin: const EdgeInsets.only(right: 7.5),
                    //                 decoration: BoxDecoration(
                    //                     color: Colors.white,
                    //                     border: Border.all(
                    //                         width: 0.5,
                    //                         color: Color.fromARGB(
                    //                             255, 141, 140, 140)),
                    //                     borderRadius: BorderRadius.circular(5)),
                    //                 child: Center(
                    //                     child: Text(
                    //                   'test',
                    //                   style: TextStyle(fontSize: 12),
                    //                 )),
                    //               ),
                    //               onTap: () {
                    //                 print("Tapped on container");
                    //               },
                    //             );
                    //           })),
                    // ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('items')
                          .where('category', isEqualTo: widget.category).where('brand',isEqualTo: widget.brand)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snap) {
                        if (!snap.hasData) {
                          return const SliverToBoxAdapter(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snap.hasError) {
                          return const SliverToBoxAdapter(
                            child: Center(child: Text('error!')),
                          );
                        } else {
                          final data = snap.data.docs;
                          return AnimationLimiter(
                              child: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 180,
                                    childAspectRatio: 6 / 8,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 20),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                                          child: OpenContainer(
                                      closedElevation: 5,
                                      closedBuilder: (context,
                                                VoidCallback openContainer) =>
                                            InkWell(
                                              onTap: openContainer,
                                              child: ItemIndividual(
                                                data[index]['id'],
                                                data[index]['url'][0],
                                                data[index]['title'],
                                                data[index]['price'],
                                                false),
                                            ),
                                      closedColor:
                                          const Color.fromRGBO(247, 247, 242, 1),
                                      openBuilder: (context, VoidCallback _) =>
                                            InsideItem(data[index]['id']),
                                      transitionDuration:const Duration(milliseconds: 500),
                                    ),
                                        )),
                                  ),
                                );
                              },
                              childCount: data.length,
                            ),
                          ));
                        }
                      },
                    )
                  ],
                ),
                color: Colors.red,
                onRefresh: () async {})));
  }
}
