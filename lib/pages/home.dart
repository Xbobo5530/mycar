import 'package:flutter/material.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/pages/question_search.dart';
import 'package:my_car/pages/tools_page.dart';
import 'package:my_car/pages/user_profile.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/forum_page.dart';
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
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(model.currentUser.imageUrl))
                : Icon(
                    Icons.account_circle,
                    size: 30.0,
                    // color: Colors.blue,
                  ),
          );
        },
      ),
    );
    final _bottom = TabBar(
      tabs: <Widget>[
        Tab(icon: Icon(Icons.chat), text: 'Mijadala'),
        Tab(icon: Icon(Icons.forum), text: 'Maswali & Majibu'),
        Tab(icon: Icon(Icons.monetization_on), text: 'Matangazo'),
        Tab(icon: Icon(Icons.build), text: 'Vifaa')
      ],
    );

    final _body = TabBarView(
      children: <Widget>[
        Icon(Icons.directions_transit),
        ForumPageView(),
        Icon(Icons.theaters),
        ToolsPage()
      ],
    );
    final _search = <Widget>[
      ScopedModelDescendant<MainModel>(
          builder: (context, child, model) => IconButton(
                icon: Icon(Icons.search),
                onPressed: () => showSearch(
                    delegate: QuestionsSearch(questionsList: model.questions),
                    context: context),
              ))
    ];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            leading: _currentUserProfileSection,
            title: Text(APP_NAME),
            centerTitle: true,
            bottom: _bottom,
            actions: _search,
          ),
          body: _body //ToolsPage(),
          ),
    );
  }
}
