import 'package:ecommerce/features/auth/pages/splash_page.dart';
import 'package:ecommerce/features/home/pages/index_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (!snapshot.hasData)
          return SplashPage();
        else
          return IndexPage();
      },
      stream: FirebaseAuth.instance.authStateChanges(),
    );
  }
}
