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

    _buildContactAction(String key) => ScopedModelDescendant<MainModel>(
        builder: (context, child, model) => LabeledFlatButton(
              label: Text(model.keyDecoder(key)),
              icon: model.iconDecoder(key),
              onTap: () => _handleTap(model, key),
            ));
    final _actions = ad.contact != null
        ? ButtonBar(
            children: ad.contact.keys
                .map((contactKey) => _buildContactAction(contactKey))
                .toList(),
          )
        : Container();

    return Card(
      child: Column(
        children: <Widget>[_userDetails, _imageSection, _description, _actions],
      ),
    );
  }
}
