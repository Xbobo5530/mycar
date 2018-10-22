import 'package:flutter/material.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/values/strings.dart';

final loginFunctions = LoginFunctions();
final userFun = User();

class UserProfilePage extends StatefulWidget {
  final User user;

  UserProfilePage({this.user});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isLoggedIn;
  bool _isCurrentUser;

  @override
  Widget build(BuildContext context) {
    loginFunctions.isLoggedIn().then((isLoggedIn) {
      setState(() {
        _isLoggedIn = isLoggedIn;
      });
    });

    if (_isLoggedIn)
      userFun.getCurrentUserId().then((userId) {
        userId == widget.user.id
            ? setState(() {
          _isCurrentUser = true;
        })
            : setState(() {
          _isCurrentUser = false;
        });
      });

    _logout() {
      loginFunctions.logout();
      Navigator.pop(context);
    }

    var basicInfoSection = ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.imageUrl),
        backgroundColor: Colors.black12,
      ),
      title: Text(widget.user.name),
      subtitle: widget.user.bio != null ? Text(widget.user.bio) : null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(myProfileText),
        actions: <Widget>[
          IconButton(
            icon: _isLoggedIn && _isCurrentUser
                ? Icon(Icons.exit_to_app)
                : Container(),
            onPressed: () => _logout(),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          basicInfoSection,
        ],
      ),
    );
  }
}
