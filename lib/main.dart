import 'package:flutter/material.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/pages/home.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyCar(model: MainModel()));

class MyCar extends StatelessWidget {
  final MainModel model;

  const MyCar({Key key, @required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primaryColor: Colors.blue),
        home: HomePage(),
      ),
    );
  }
}
