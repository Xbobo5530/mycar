import 'package:flutter/material.dart';
import 'package:my_car/models/warning_sign.dart';

class WarningSignsPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildListItem(WarningSign sign) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
//              Container(
//                  height: 40.0,
//                  width: 80.0,
//                  child: Image.network(sign.imageUrl)),

              CircleAvatar(
                backgroundColor: Colors.black12,
                backgroundImage: NetworkImage(sign.imageUrl, scale: 4.0),
                radius: 45.0,
              ),
              Expanded(
                child: ListTile(
                  title: Text(sign.title),
                  subtitle: Text(sign.description),
                ),
              ),
            ],
          ),
        );
    return ListView(
      children: warningSigns.map(_buildListItem).toList(),
    );
  }
}
