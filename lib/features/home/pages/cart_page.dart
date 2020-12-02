import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int count = 0;
  String uuid;

  @override
  void initState() {
    uuid = auth.currentUser.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget item({
      List<dynamic> imgUrl,
      String itemName,
      String sellerName,
      int count,
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
                  onPressed: () {},
                  color: Colors.black87,
                  child: Text(
                    '${count} in cart',
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
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uuid)
          .collection('cart')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(uuid)
        //     .get()
        //     .then((value) {
        //   setState(() {
        //     print(value.data()['count']);
        //     count = value.data()['count'];
        //   });
        // });
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: BackButton(
                color: Colors.black54,
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'My Cart',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
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
                    sellerName: doc.data()['sellerName'] ?? '',
                    count: doc.data()['count'] ?? '');
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
