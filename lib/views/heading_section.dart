import 'package:flutter/material.dart';

class HeadingSectionView extends StatelessWidget {
  final String imageUrl, heading;

  HeadingSectionView({this.imageUrl, this.heading});

  @override
  Widget build(BuildContext context) {
    final _userIcon = Icon(
      Icons.account_circle,
      color: Colors.grey,
      size: 40.0,
    );
    return ExpansionTile(
      leading: imageUrl != null
          ? CircleAvatar(
              backgroundColor: Colors.black12,
              backgroundImage: NetworkImage(imageUrl),
            )
          : _userIcon,
      title: Text(
          heading.length >= 35 ? '${heading.substring(0, 35)}...' : heading),
      children: <Widget>[
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              heading,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ),
        )
      ],
    );
  }
}
