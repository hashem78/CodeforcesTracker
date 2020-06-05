import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/tag_screen.dart';
import 'screens/main_screen.dart';
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
      create: (context) => StackData(),
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
          "/" :(context)=> MainScreen(),
          "/tagScreen": (context) => TagScreen(),
        },
      ),
    );
  }
}
