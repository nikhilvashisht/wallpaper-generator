import 'package:flutter/material.dart';
import 'screens/loadingscreen.dart';
import 'package:flutter/services.dart';


void main()  {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      home: LoadingScreen(),
    );
  }
}

// List<int> mylist = <int>[1,2,3];