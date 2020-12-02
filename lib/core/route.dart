import 'package:auto_route/auto_route_annotations.dart';
import 'package:ecommerce/features/auth/pages/root_page.dart';
import 'package:ecommerce/features/auth/pages/sign_in_page.dart';
import 'package:ecommerce/features/auth/pages/splash_page.dart';
import 'package:ecommerce/features/home/pages/index_page.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  SplashPage splashPage;
  SignUpPage signUpPage;
  RootPage rootPage;
  IndexPage indexPage;
}
