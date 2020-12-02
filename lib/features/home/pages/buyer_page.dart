import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/route.gr.dart';
import 'package:ecommerce/core/utils/all_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';

class BuyerPage extends StatefulWidget {
  @override
  _BuyerPageState createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  int count = 0;
  String uuid;

  @override
  void initState() {
    uuid = auth.currentUser.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uuid)
        .collection('cart')
        .get()
        .then((value) {
      setState(() {
        count = value.docs.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget item({
      List<dynamic> imgUrl,
      String itemName,
      String sellerName,
    }) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              LimitedBox(
                maxHeight: 200,
                maxWidth: 200,
                child: PageView.builder(
                  itemCount: imgUrl.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(itemName),
              SizedBox(
                height: 10,
              ),
              Text(sellerName),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      count = count + 1;
                    });
                    Provider.of<AllProvider>(context, listen: false)
                        .updateCount(count);
                    int itemcount = 0;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(uuid)
                        .collection('cart')
                        .get()
                        .then((value) {
                      setState(() {
                        itemcount = value.docs.length;
                      });
                    });
                    itemcount = itemcount + 1;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(uuid)
                        .collection('cart')
                        .add({
                      'name': itemName,
                      'sellerName': sellerName,
                      'url': imgUrl,
                      'count': itemcount
                    });

                    key.currentState.showSnackBar(
                      SnackBar(
                        content: Text('Item Added to cart'),
                        duration: const Duration(milliseconds: 1500),
                        action: SnackBarAction(
                            label: 'View Cart',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (
                                      BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                    ) =>
                                        CartPage(),
                                    transitionsBuilder: (
                                      BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      Widget child,
                                    ) =>
                                        SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  ));
                            }),
                      ),
                    );
                  },
                  color: Colors.black87,
                  child: Text(
                    'Add to cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('items').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            key: key,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  icon: Transform.rotate(
                    angle: pi,
                    child: FaIcon(
                      FontAwesomeIcons.signOutAlt,
                      color: Colors.black54,
                      size: 14,
                    ),
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          content: Text(
                            'Are you sure you want to logout',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Warning',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                            ),
                          ),
                          actions: <Widget>[
                            CupertinoButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            CupertinoButton(
                                child: Text('Yes'),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacementNamed(
                                      context, Router.rootPage);
                                }),
                          ],
                        );
                      },
                    );
                  }),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Explore',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (
                            BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                          ) =>
                              CartPage(),
                          transitionsBuilder: (
                            BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child,
                          ) =>
                              SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.cartPlus,
                          size: 18,
                          color: Colors.black87,
                        ),
                        Positioned(
                          top: -5,
                          right: -5,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            height: 15,
                            width: 15,
                            alignment: Alignment.center,
                            child: Text(
                              count.toString(),
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            body: StaggeredGridView.countBuilder(
              padding: EdgeInsets.symmetric(horizontal: 10)
                  .copyWith(bottom: 10, top: 20),
              itemCount: snapshot.data.docs.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final doc = snapshot.data.docs[index];
                final List<dynamic> imgUrls = doc.data()['url'] ?? [];
                return item(
                    imgUrl: imgUrls,
                    itemName: doc.data()['name'] ?? '',
                    sellerName: doc.data()['sellerName'] ?? '');
              },
              staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              crossAxisCount: 2,
            ),
          );
        } else
          return CircularProgressIndicator();
      },
    );
  }
}
