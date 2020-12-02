import 'package:ecommerce/core/colors/colors.dart';
import 'package:ecommerce/features/home/pages/buyer_page.dart';
import 'package:ecommerce/features/home/pages/seller_page.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  ValueNotifier<int> _pageNumberNotifier = ValueNotifier<int>(0);
  List<Widget> _widgets = <Widget>[
    BuyerPage(),
    SellerPage(),
  ];

  void _onItemTapped(int index) {
    _pageNumberNotifier.value = index;
  }

  @override
  void dispose() {
    super.dispose();
    _pageNumberNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageNumberNotifier.value != 0) {
          _pageNumberNotifier.value = 0;
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: ValueListenableBuilder(
          builder: (BuildContext context, pageNumber, Widget child) {
            return Scaffold(
                body: IndexedStack(
                  index: _pageNumberNotifier.value,
                  children: _widgets,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: pageNumber,
                  onTap: _onItemTapped,
                  selectedItemColor: kDarkBlue,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(
                        pageNumber == 0
                            ? FontAwesomeIcons.solidMoneyBillAlt
                            : FontAwesomeIcons.moneyBillAlt,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Buy",
                          style: TextStyle(
                              //fontSize: 12,  default value
                              fontSize: 12),
                        ),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.sellcast
                          //size: 20,
                          ),
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Sell',
                          style: TextStyle(fontSize: 12
                              //fontSize: 12,
                              ),
                        ),
                      ),
                    ),
                  ],
                ));
          },
          valueListenable: _pageNumberNotifier,
        ),
      ),
    );
  }
}
