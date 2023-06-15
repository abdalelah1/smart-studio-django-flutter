import 'package:flutter/material.dart';

import 'http/http.dart';
import 'layout/homePage.dart';


void main() {
  checkConnection().then((connected) => 
  {
    if (connected) runApp(const MyApp())
    else print('error on connection')
  });
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
