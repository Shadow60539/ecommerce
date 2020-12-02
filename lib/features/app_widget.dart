import 'package:ecommerce/core/colors/colors.dart';
import 'package:ecommerce/core/route.gr.dart';
import 'package:ecommerce/core/utils/all_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AllProvider(),
      child: MaterialApp(
        initialRoute: Router.rootPage,
        onGenerateRoute: Router.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Bookshelf',
        theme: ThemeData.light().copyWith(
          textTheme: GoogleFonts.nunitoTextTheme(),
        ),
      ),
    );
  }
}
