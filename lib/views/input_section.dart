import 'package:flutter/material.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

class InputSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    return Material(
      elevation: 4,
      child: Container(
        color: Colors.blue,
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) =>
              model.isLoggedIn
                  ? TextField()
                  : ListTile(
                    onTap: ()=> model.goToLoginPage(context),
                      title: Text(
                      loginText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    )),
        ),
      ),
    );
  }
}
