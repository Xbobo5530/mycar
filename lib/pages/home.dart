import 'package:flutter/material.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/pages/ask.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/pages/tools_page.dart';
import 'package:my_car/pages/user_profile.dart';
import 'package:my_car/pages/view_question.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/question_item.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'HomePage:';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _scrollViewController = ScrollController();

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

    _goToAskQuestionPage() {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => AskPage(), fullscreenDialog: true));
    }

    final _askQuestionSection = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return IconButton(
            icon: Icon(Icons.add),
            onPressed: model.isLoggedIn
                ? () => _goToAskQuestionPage()
                : () => _goToLoginPage());
      },
    );

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

    final _forumView = ScopedModelDescendant<MainModel>(
      builder: (_, __, model) {
        return StreamBuilder(
            stream: model.questionsStream(),
            builder: (_, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    final document = snapshot.data.documents[index];
                    final question = Question.fromSnapshot(document);
                    return QuestionItemView(
                      question: question,
                      onTap: () =>
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ViewQuestionPage(question: question))),
                    );
                  });
            });
      },
    );

    final _bodySection =
    ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      switch (model.currentNavItem) {
        case NAV_ITEM_HOME:
          return _forumView;
          break;
        case NAV_ITEM_TOOLS:
          return ToolsPage();
          break;
        default:
          print('$_tag selected nav item is ${model.currentNavItem}');
      }
    });

    return Scaffold(
      body: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                forceElevated: innerBoxIsScrolled,
                snap: true,
                floating: true,
                leading: _askQuestionSection,
                title: Text(APP_NAME),
                actions: <Widget>[
                  _currentUserProfileSection,
                ],
              )
            ];
          },
          body: _bodySection),
      bottomNavigationBar: ScopedModelDescendant<MainModel>(
        builder: (context, child, model) {
          return BottomNavigationBar(
            onTap: (selectedItem) => model.updateSelectedNavItem(selectedItem),
            currentIndex: model.currentNavItem,
            fixedColor: Colors.blue,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  title: Text(homeText), icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  title: Text(toolsText), icon: Icon(Icons.settings)),
            ],
          );
        },
      ),
    );
  }
}
