import 'package:flutter/material.dart';
import 'package:my_car/models/ad.dart';
import 'package:my_car/utils/consts.dart';

class AdItemView extends StatelessWidget {
  final Ad ad;

  const AdItemView({Key key, this.ad}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _userDetails = Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.blue,
          backgroundImage: ad.userImageUrl != null
              ? NetworkImage(ad.userImageUrl)
              : AssetImage(ASSETS_APP_ICON),
        )
      ],
    );
    final _imageSection =
        ad.imageUrl != null ? Image.network(ad.imageUrl) : Container();
    final _description = ad.description !=  null ? ListTile(title: Text(ad.description,softWrap: true,),): Container();
    return Card(
      child: Column(
        children: <Widget>[_userDetails, _imageSection, _description, _actions],
      ),
    );
  }
}
