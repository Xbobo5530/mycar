import 'package:flutter/material.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/models/main_scopped_model.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/values/strings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

const tag = 'UserProfilePage:';
final _loginFun = LoginFunctions();

class UserProfilePage extends StatelessWidget {
  final User user;
  final bool isCurrentUser;

  UserProfilePage({this.user, this.isCurrentUser});
  @override
  Widget build(BuildContext context) {
    _logout(MainModel model) {
      _loginFun.logout();
      model.getLoginStatus();
      model.getCurrentUser();
      Navigator.pop(context);
    }

    var _basicInfoSection = ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.imageUrl),
        backgroundColor: Colors.black12,
      ),
      title: Text(user.name),
      subtitle: user.bio != null ? Text(user.bio) : null,
    );

    _sendEmail() async {
      print('$tag at send email');
      const url = emailUrl;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    var _logoutSection = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        model.checkIsCurrentUser(user.id);

        if (isCurrentUser != null && isCurrentUser)
          return ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(logoutText),
            onTap: () => _logout(model),
          );
        else
          return Container();
      },
    );

    var _appInfoSection = ListTile(
      leading: Icon(Icons.info),
      title: Text(APP_NAME),
      subtitle: Text(devByText),
      trailing: Icon(Icons.email),
      onTap: () => _sendEmail(),
    );

    return Scaffold(
      body: ListView(
        children: <Widget>[
          _basicInfoSection,
          Divider(),
          _logoutSection,
          _appInfoSection,
        ],
      ),
    );
  }
}
