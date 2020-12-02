// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ecommerce/features/auth/pages/splash_page.dart';
import 'package:ecommerce/features/auth/pages/sign_in_page.dart';
import 'package:ecommerce/features/auth/pages/root_page.dart';
import 'package:ecommerce/features/home/pages/index_page.dart';

class Router {
  static const splashPage = '/';
  static const signUpPage = '/sign-up-page';
  static const rootPage = '/root-page';
  static const indexPage = '/index-page';
  static final navigator = ExtendedNavigator();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.splashPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SplashPage(),
          settings: settings,
        );
      case Router.signUpPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SignUpPage(),
          settings: settings,
        );
      case Router.rootPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => RootPage(),
          settings: settings,
        );
      case Router.indexPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => IndexPage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
