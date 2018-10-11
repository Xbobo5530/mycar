import 'package:flutter/material.dart';
import 'package:my_car/values/strings.dart';

class WelcomeCardView extends StatelessWidget {
  var welcomeCard = Dismissible(
    child: Card(
      child: Wrap(
        children: <Widget>[
          ListTile(
            title: Text(welcomeText),
            subtitle: Text(introductionText),
          ),
        ],
      ),
    ),
    key: Key('welcome card'),
  );

  @override
  Widget build(BuildContext context) {
    return welcomeCard;
  }
}
