import 'package:flutter/material.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/models/tool.dart';
import 'package:my_car/src/pages/ask.dart';
import 'package:my_car/src/pages/login.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/forum_page.dart';
import 'package:my_car/src/views/warning_signs_page.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'NativeToolPage:';

class NativeToolPage extends StatelessWidget {
  final Tool tool;

  NativeToolPage({this.tool});

  @override
  Widget build(BuildContext context) {
    Widget _buildNativeToolView() {
      switch (tool.id) {
        case NATIVE_TOOL_FORUM:
          return ForumPage();
        case NATIVE_TOOL_WARNING_SIGNS:
          return WarningSignsPageView();
          break;
        default:
          print('$_tag tool id is $NATIVE_TOOL_WARNING_SIGNS');
          return Container(
            child: Center(child: Text(errorMessage)),
          );
      }
    }

    _goToAskQuestionPage() {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => AskPage(), fullscreenDialog: true));
    }

    _goToLoginPage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return LoginPage();
          });
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

    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          title: Text(tool.title),
          actions: tool.id == NATIVE_TOOL_FORUM
              ? <Widget>[
                  _askQuestionSection,
                  // _searchSection,
                ]
              : [Container()]),
      body: _buildNativeToolView(),
    );
  }
}
