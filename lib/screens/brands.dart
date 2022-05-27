import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:senior/screens/insideCategory.dart';
import 'package:senior/screens/search.dart';
import 'package:senior/screens/shoppingCart.dart';
import 'home.dart';

class Brands extends StatefulWidget {
  final String? category;
  const Brands(@required this.category);

  @override
  State<Brands> createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
  List brands = [
    {"brand": "Rover", "url": "https://cdn.pixabay.com/photo/2020/11/04/13/41/car-5712395_960_720.jpg"},
    {"brand": "Tesla", "url": "https://www.nerdwallet.com/assets/blog/wp-content/uploads/2020/05/david-von-diemar-ZBWn5DvO0hg-unsplash-1920x1152.jpg"},
    {"brand": "BMW", "url": "https://cloudfront-us-east-2.images.arcpublishing.com/reuters/U6DU4EGVOZNXPHXTMIPF7B5C64.jpg"},
    {"brand": "Honda", "url": "https://cdn.carbuzz.com/gallery-images/840x560/743000/500/743560.jpg"},
    {"brand": "Porche", "url": "https://files.porsche.com/filestore/image/usa/none/PressReleases-XLe/normal/c1f013b0-0b52-11e4-8b02-001a64c55f5c/porsche-normal.jpg"},
    {"brand": "Renault", "url": "https://www.btgunlugu.com/wp-content/uploads/2021/01/Renault-Logo-2_1200x600.jpg"},
    {"brand": "Toyota", "url": "https://images.unsplash.com/photo-1581862142388-23e1c52ca091?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dG95b3RhfGVufDB8fDB8fA%3D%3D&w=1000&q=80"},
    {"brand": "Mercedes", "url": "https://di-uploads-pod7.dealerinspire.com/mercedesbenzofwarwickredesign/uploads/2020/07/Mercedes-Benz-Logo.png"}
  ];
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

  Route _toInsideCategory(String param, String param2) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          new insidecategory(param, param2),
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
        backgroundColor: Color.fromRGBO(247, 247, 242, 1),
        body: SafeArea(
            child: RefreshIndicator(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                        shadowColor: Colors.transparent,
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                                    icon: Icon(Icons.shopping_basket_rounded,
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
                                          color: Color.fromARGB(
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
                                      Text(
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
                    SliverToBoxAdapter(
                      child: const SizedBox(
                        height: 10,
                      ),
                    ),

                    SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 4 / 3.8,
                            mainAxisSpacing: 0),
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(_toInsideCategory(
                                  widget.category.toString(),
                                  brands[index]['brand']));
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: brands[index]['url'],
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 140,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          colorFilter: new ColorFilter.mode(
                                              Colors.black.withOpacity(0.6),
                                              BlendMode.dstATop),
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        color: Color.fromARGB(255, 41, 41, 41),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(103, 90, 90, 90),
                                            spreadRadius: 5,
                                            blurRadius: 9,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(brands[index]['brand'],
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white)),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Text("error"),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }, childCount: brands.length)),
                        SliverToBoxAdapter(child: SizedBox(height: 30,),)
                  ],
                ),
                color: Colors.red,
                onRefresh: () async {})));
  }
}
