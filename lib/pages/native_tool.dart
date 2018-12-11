import 'package:flutter/material.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/tools.dart';
import 'package:my_car/pages/ask.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/pages/question_search.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/forum_page.dart';
import 'package:my_car/views/warning_signs_page.dart';
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
        return ForumPageView();
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
    // final _searchSection = Builder(
    //   builder: (context) => ScopedModelDescendant<MainModel>(
    //     builder: (_,__,model){

    //       return IconButton(
    //         icon: Icon(Icons.search),
    //         onPressed: () async {
    //           List<Question> questions = await model.getQuestions();
    //            await showSearch(
    //               context: context, delegate: QuestionsSearch(questions));
    //         });} ,
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(tool.title),
        actions: tool.id == NATIVE_TOOL_FORUM
        ? <Widget>[
              _askQuestionSection,
              // _searchSection,
            ]
            : [Container()]
      ),
      body: _buildNativeToolView(),
    );
  }
}
