import 'package:flutter/material.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/pages/ad_page.dart';
import 'package:my_car/src/pages/ask.dart';
import 'package:my_car/src/pages/create_ad_page.dart';
import 'package:my_car/src/pages/live_chat.dart';
import 'package:my_car/src/pages/question_search.dart';
import 'package:my_car/src/pages/tools_page.dart';
import 'package:my_car/src/pages/user_profile.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/forum_page.dart';
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

    _goToAddQuestionPage(MainModel model) => model.isLoggedIn
        ? Navigator.push(context, MaterialPageRoute(builder: (_) => AskPage()))
        : model.goToLoginPage(context);

    _goToAddAdPage(MainModel model) => model.isLoggedIn
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CreateAdPage(), fullscreenDialog: true))
        : model.goToLoginPage(context);
    _handleAdd(MainModel model, AddMenuItem item) {
      switch (item) {
        case AddMenuItem.question:
          model.isLoggedIn
              ? _goToAddQuestionPage(model)
              : model.goToLoginPage(context);
          break;
        case AddMenuItem.ad:
          model.isLoggedIn
              ? _goToAddAdPage(model)
              : model.goToLoginPage(context);
          break;
      }
    }

    final _currentUserProfileSection = Padding(
      padding: const EdgeInsets.all(8.0),
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return IconButton(
            onPressed: model.isLoggedIn
                ? () => _goToProfilePage()
                : () => model.goToLoginPage(context),
            icon: model.currentUser != null &&
                    model.currentUser.imageUrl != null
                ? CircleAvatar(
                    radius: 12.0,
                    backgroundColor: Colors.white70,
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
        Tab(icon: Icon(Icons.chat), text: chatText),
        Tab(icon: Icon(Icons.forum), text: forumText),
        Tab(icon: Icon(Icons.monetization_on), text: adsText),
        Tab(icon: Icon(Icons.build), text: toolsText)
      ],
    );

    final _body = TabBarView(
      children: <Widget>[LiveChatPage(), ForumPage(), AdPage(), ToolsPage()],
    );
    final _add = ScopedModelDescendant<MainModel>(
      builder: (context, child, model) => PopupMenuButton<AddMenuItem>(
            onSelected: (selectedItem) => _handleAdd(model, selectedItem),
            icon: Icon(Icons.add_circle),
            itemBuilder: (context) => <PopupMenuEntry<AddMenuItem>>[
                  PopupMenuItem(
                    value: AddMenuItem.question,
                    child: Text(addQuestionText),
                  ),
                  PopupMenuItem(
                    value: AddMenuItem.ad,
                    child: Text(addAdText),
                  )
                ],
          ),
    );
    final _search = ScopedModelDescendant<MainModel>(
        builder: (context, child, model) => IconButton(
              icon: Icon(Icons.search),
              onPressed: () => showSearch(
                  delegate: QuestionsSearch(
                      questionsList: model.questions, adsList: model.ads),
                  context: context),
            ));
    final _actions = <Widget>[_search, _add];
    final _appBar = AppBar(
      leading: _currentUserProfileSection,
      title: Text(APP_NAME),
      centerTitle: true,
      bottom: _bottom,
      actions: _actions,
    );

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: _appBar,
        body: _body,
      ),
    );
  }
}
