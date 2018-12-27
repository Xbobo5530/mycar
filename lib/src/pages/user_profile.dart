import 'package:flutter/material.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/models/user.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

const _tag = 'UserProfilePage:';

class UserProfilePage extends StatelessWidget {
  final User user;

  const UserProfilePage({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _logout(MainModel model) async {
      final StatusCode logoutStatusCode = await model.logout();

      switch (logoutStatusCode) {
        case StatusCode.failed:
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage)));
          break;
        case StatusCode.success:
          Navigator.pop(context);
          break;
        default:
          print('$_tag login status code is $logoutStatusCode');
      }
    }

    final _basicInfoSection = ListTile(
      leading: user.imageUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl),
              backgroundColor: Colors.black12,
            )
          : Icon(
              Icons.account_circle,
              size: 18.0,
            ),
      title: Text(user.name),
      subtitle: user.bio != null ? Text(user.bio) : null,
    );

    _sendEmail() async {
      print('$_tag at send email');
      const url = emailUrl;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    final _logoutSection = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        if (!model.isLoggedIn) return Container();

        bool isCurrentUser = user.id == model.currentUser.id;

        if (!isCurrentUser) return Container();
        return ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text(logoutText),
          onTap: () => _logout(model),
        );
      },
    );

    _buildAppInfoSection() {
      return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) => 
        !snapshot.hasData 
        ? Center(child:CircularProgressIndicator()):
        ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(ASSETS_APP_ICON),
                backgroundColor: Colors.blue,
              ),
              title: Text('${snapshot.data.appName} v${snapshot.data.version}'),
              subtitle: Text(devByText),
              trailing: Icon(Icons.email),
              onTap: () => _sendEmail(),
            ),
      );
    }

    return Scaffold(
      body: ListView(
        children: <Widget>[
          _basicInfoSection,
          Divider(),
          _logoutSection,
          _buildAppInfoSection(),
        ],
      ),
    );
  }
}
