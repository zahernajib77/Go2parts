import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShopppingCart extends StatefulWidget {
  const ShopppingCart({ Key? key }) : super(key: key);

  @override
  State<ShopppingCart> createState() => _ShopppingCartState();
}

class _ShopppingCartState extends State<ShopppingCart> {
  late SharedPreferences prefs;
  late String text = '';
  void initState() {
    retrieveStringValue();
    super.initState();
  }

  retrieveStringValue() async {
    prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString("username");
    text = value.toString();
  }
  @override
  Widget build(BuildContext context) {
        final WIDTH = MediaQuery.of(context).size.width;
        List items = [];
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 242, 1),
      body: RefreshIndicator(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
                pinned: true,
                floating: true,
                forceElevated: true,
                titleSpacing: 0,
                title: Container(
                  height: 50,
                  width: WIDTH,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Shopping Cart'+text,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                     const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 15, right: 15, top: 5, bottom: 5),
                  height: 0.2,
                  color: Color.fromARGB(220, 158, 158, 158),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snap) {
                    if (snap.hasData) {
                      final data = snap.data!.snapshot.value;
                      if (items.length == 0) {
                        data.forEach((key, item) => {items.add(item)});
                      }
                      return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return Column(
                          children: [
                            ListTile(
                    leading:CachedNetworkImage(
                        // imageUrl:
                        //     items[index]['url'],
                        imageUrl: 'https://cdn.pixabay.com/photo/2016/11/22/23/44/porsche-1851246_960_720.jpg',
                        errorWidget: (context, url, error) => Text("error"),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        imageBuilder: (context, imageProvider) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(image: imageProvider,width: 50,height: 50,fit: BoxFit.cover,),
                        ))   ,
                    // title: Text(items[index]['id'],style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                    // subtitle: Text(items[index]['id'],style: TextStyle(color: Theme.of(context).colorScheme.primary,)),
                    title: Text('B-m20 Engine'),
                    subtitle: Text('Bahsas-Shop'),
                    trailing: Text('12 \nusd',textAlign: TextAlign.center,style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                  ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 5, bottom: 5),
                              height: 0.2,
                              color: Color.fromARGB(220, 158, 158, 158),
                            )
                          ],
                        );
                      }, childCount: items.length));
                    } else {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: LinearProgressIndicator(),
                        ),
                      );
                    }
                  }),
              SliverToBoxAdapter(
                child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) =>const BottomSheetOrder());
                    },
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 16, 247, 255),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                          child: Text(
                        'Checkout + number of orders for followers website',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    )),
              )
            ],
          ),
          color: Colors.red,
          onRefresh: () async {}),
    );
  }
}

class BottomSheetOrder extends StatefulWidget {
  const BottomSheetOrder({Key? key}) : super(key: key);

  @override
  _BottomSheetOrderState createState() => _BottomSheetOrderState();
}

class _BottomSheetOrderState extends State<BottomSheetOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      padding: const EdgeInsets.only(top: 30,left: 15,right: 15,bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Are you sure you wanna proceed?',style: Theme.of(context).textTheme.titleMedium,),
         const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: (){}, child: Text('No',style: Theme.of(context).textTheme.titleMedium)),
              ElevatedButton(onPressed: (){}, child: Text('Yes',style: Theme.of(context).textTheme.titleMedium))

            ],
          )
        ],
      )
    );
  }
}
