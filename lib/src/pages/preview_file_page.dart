import 'package:flutter/material.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:my_car/src/utils/strings.dart';

class PreviewFilePage extends StatelessWidget {
  final AddFileItem contentType;

  const PreviewFilePage({Key key, this.contentType, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
      ),
    );
  }
}
