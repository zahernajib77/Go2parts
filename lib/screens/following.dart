import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/screens/login.dart';
import 'package:senior/screens/shoppingClientSide.dart';

class Following extends StatefulWidget {
  const Following({Key? key}) : super(key: key);

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  void initState() {
    authChanged();
    super.initState();
  }

  authChanged() {
    if (auth.currentUser != null) {
      user = auth.currentUser;
    } else {
      Navigator.of(context).push(_toLogin());
    }
  }

  Route _toLogin() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const loginpage(),
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
           ShopClientSide(param),
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
    String uid = auth.currentUser!.uid.toString();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 247, 242, 1),
      appBar: AppBar(
        title: const Text(
          'Following',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(onPressed: () {}, icon:const Icon(Icons.settings_outlined))
        ],
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: Center(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('following')
                .snapshots(),
            builder: (ontext, AsyncSnapshot snap) {
              if (snap.hasData) {
                final data = snap.data.documents;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(_toShopCient(data[index]['shopId']));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  width: 0.5,
                                  color:const Color.fromARGB(255, 141, 140, 100))),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: ListTile(
                            leading: SizedBox(
                              width: 60,
                              height: 50,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                   const Text("error"),
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                                imageUrl: data[index]['shopImage'],
                                imageBuilder: (context, imageProvider) =>
                                    ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(data[index]['shopname']),
                            subtitle: Text(data[index]['shopAdress']),
                            trailing: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.notifications)),
                          ),
                        ),
                      );
                    });
              } else if (snap.hasError) {
                return const Center(
                  child: Text('Something went wrong!'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
            }),
      )),
    );
  }
}
