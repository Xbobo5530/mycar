import 'package:flutter/material.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/pages/tools_page.dart';
import 'package:my_car/pages/user_profile.dart';
import 'package:my_car/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'HomePage:';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _goToProfilePage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return UserProfilePage(user: model.currentUser);
              },
            );
          });
    }

    _goToLoginPage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return LoginPage();
          });
    }

    final _currentUserProfileSection = Padding(
      padding: const EdgeInsets.all(8.0),
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return IconButton(
            onPressed: model.isLoggedIn
                ? () => _goToProfilePage()
                : () => _goToLoginPage(),
            icon: model.currentUser != null &&
                    model.currentUser.imageUrl != null
                ? CircleAvatar(
                    radius: 12.0,
                    backgroundColor: Colors.black12,
                    backgroundImage: NetworkImage(model.currentUser.imageUrl))
                : Icon(
                    Icons.account_circle,
                    size: 30.0,
                    color: Colors.grey,
                  ),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: _currentUserProfileSection,
        title: Text(APP_NAME),
      ),
      body: ToolsPage(),
    );
  }
}
