import 'package:flutter/material.dart';
import 'package:my_car/src/utils/strings.dart';

class WelcomeCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    return welcomeCard;
  }
}
