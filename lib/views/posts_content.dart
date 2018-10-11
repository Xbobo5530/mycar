import 'package:flutter/material.dart';
import 'package:my_car/values/strings.dart';

class PostsPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var commentsButton = FlatButton(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.comment,
            size: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '3',
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
      onPressed: () {},
    );

    var shareButton = FlatButton(
        onPressed: () {},
        child: Row(
          children: <Widget>[
            Icon(
              Icons.share,
              size: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                shareText,
                style: TextStyle(fontSize: 12.0),
              ),
            )
          ],
        ));

    return ExpansionTile(
      title: Column(
        children: <Widget>[
          Text('nijinsigani naweza kubadilisha oil ya Suzuki yangu?'),
          Row(
            children: <Widget>[
              commentsButton,
              shareButton,
            ],
          ),
        ],
      ),
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                commentsText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        _buildComment('aiseee hilo swali gumu', 'Mike66'),
        _buildComment('umejaribu oilu gani sof ar', 'Simon'),
        _buildComment(
            '''sasa the very furst thing inabidi uchekci aina ya gari yako, hapo naona umesema suzuki alakini inabidi utuambie ni suzuki yaaina gani otherwise hamna namnaya kujua oili ipi itakusaidia
              ''', 'Simon'),
      ],
    );
  }

  _buildComment(String comment, String username) {
    return ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),
          Container(
              child: Text(
            comment,
            textAlign: TextAlign.start,
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.account_circle, size: 25.0, color: Colors.cyan),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                ),
                child: Text(
                  username,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
