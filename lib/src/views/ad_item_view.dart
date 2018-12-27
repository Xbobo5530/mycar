import 'package:flutter/material.dart';
import 'package:my_car/src/models/ad.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/labeled_flat_button.dart';
import 'package:scoped_model/scoped_model.dart';

class AdItemView extends StatelessWidget {
  final Ad ad;

  const AdItemView({Key key, @required this.ad})
      : assert(ad != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final _userDetails = ad.username != null
        ? Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                  backgroundImage: ad.userImageUrl != null
                      ? NetworkImage(ad.userImageUrl)
                      : AssetImage(ASSETS_APP_ICON),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    ad.username,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              )
            ],
          )
        : Container();
    final _imageSection =
        ad.imageUrl != null ? Image.network(ad.imageUrl) : Container();
    final _description = ad.description != null
        ? ListTile(
            title: Text(
              ad.description,
              softWrap: true,
            ),
          )
        : Container();
    _handleTap(MainModel model, String key) async {
      final status = await model.onTapDecoder(key, ad);
      if (status == StatusCode.failed)
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
    }

    final _deleteButton = ScopedModelDescendant<MainModel>(
      builder: (context, child, model) =>
          model.isLoggedIn && ad.createdBy == model.currentUser.id
              ? ButtonBar(
                alignment: MainAxisAlignment.center,
                children:  <Widget>[
                  LabeledFlatButton(
                    label: Text(deleteText),
                    icon: Icon(Icons.delete),
                    onTap: () => model.deleteAd(ad),
                  ),
                ])
              : Container(),
    );

    _buildContactAction(String key) => ScopedModelDescendant<MainModel>(
        builder: (context, child, model) => ad.contact[key] != null
            ? LabeledFlatButton(
                label: Text(model.keyDecoder(key)),
                icon: model.iconDecoder(key),
                onTap: () => _handleTap(model, key),
              )
            : Container());
    final _actions = Column(
      children: <Widget>[
        ad.contact != null
            ? ButtonBar(
                alignment: MainAxisAlignment.center,
                children: ad.contact.keys
                    .map((contactKey) => _buildContactAction(contactKey))
                    .toList(),
              )
            : Container(),
        _deleteButton
      ],
    );

    return Card(
      child: Column(
        children: <Widget>[_userDetails, _imageSection, _description, _actions],
      ),
    );
  }
}
