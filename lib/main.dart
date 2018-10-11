import 'package:flutter/material.dart';
import 'package:my_car/pages/home.dart';
import 'package:my_car/values/strings.dart';

void main() => runApp(new MyCar());

class MyCar extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: APP_NAME,
      theme: new ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: new HomePage(),
    );
  }
}
