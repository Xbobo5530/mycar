import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_car/src/models/ad.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/models/user.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/ad_item_view.dart';
import 'package:scoped_model/scoped_model.dart';

class UserAdsPage extends StatelessWidget {
  final User user;

  const UserAdsPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(adsText),
        ),
        body: ScopedModelDescendant<MainModel>(
            builder: (context, child, model) => StreamBuilder<QuerySnapshot>(
                  stream: model.userAdStream(user),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    if (snapshot.data.documents.length == 0)
                      return Center(
                        child: Text(noAdsText),
                      );

                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) => FutureBuilder<Ad>(
                              future: model.refineUserAds(
                                  snapshot.data.documents[index].documentID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return Container();
                                Ad ad = snapshot.data;
                                return ad == null
                                    ? Container()
                                    : AdItemView(
                                        ad: ad,
                                        key: Key(ad.id),
                                      );
                              },
                            ));
                  },
                )));
  }
}
