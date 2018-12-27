import 'package:flutter/material.dart';
import 'package:my_car/src/models/ad.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/ad_item_view.dart';

class UserAdsPage extends StatelessWidget {
  final List<Ad> adsList;

  const UserAdsPage({Key key, this.adsList}) : super(key: key); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(adsText),
      ),
      body: ListView.builder(
        itemCount: adsList.length,
        itemBuilder: (context, index)=> AdItemView(
          ad: adsList[index],
          key: Key(adsList[index].id),
        ),
      ),
      
    );
  }
}