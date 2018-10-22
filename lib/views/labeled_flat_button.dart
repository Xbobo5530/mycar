import 'package:flutter/material.dart';

class LabeledFlatButton extends StatelessWidget {
  final Widget icon;
  final GestureTapCallback onTap;
  final Widget label;

  LabeledFlatButton({this.icon, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: icon,
            ),
            label,
          ],
        ));
  }
}
