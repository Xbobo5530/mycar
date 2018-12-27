import 'package:flutter/material.dart';
import 'package:my_car/src/models/ad.dart';
import 'package:my_car/src/utils/strings.dart';

class ViewAdPage extends StatelessWidget {
  final Ad ad;

  const ViewAdPage({Key key, this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
      ),
    );
  }
}
