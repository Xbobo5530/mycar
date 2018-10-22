import 'package:flutter/material.dart';
import 'package:my_car/pages/home.dart';
import 'package:my_car/values/strings.dart';

void main() => runApp(MyCar());

class MyCar extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var primaryColor = Colors.white;

    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primaryColor: primaryColor),
      home: HomePage(),
    );
  }
}
