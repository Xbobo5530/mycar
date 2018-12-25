import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_car/src/models/ad.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/views/ad_item_view.dart';
import 'package:scoped_model/scoped_model.dart';

class AdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<MainModel>(
        builder: (context, child, model) => StreamBuilder<QuerySnapshot>(
              stream: model.adStream(),
              builder: (context, snapshot) => !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        Ad ad = Ad.fromSnapshot(snapshot.data.documents[index]);
                        return FutureBuilder<Ad>(
                          initialData:
                              ad,
                          future:
                              model.refineAd(ad),
                          builder: (_, snapshot) => AdItemView(
                              ad: snapshot.data, key: Key(snapshot.data.id)),
                        );
                      },
                    ),
            ),
      ),
    );
  }
}
