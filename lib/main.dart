import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/tag_screen.dart';
import 'constants.dart';

import 'widgets/important_data.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
  //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ImportantData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => TagScreen(),
        },
      ),
    );
  }
}