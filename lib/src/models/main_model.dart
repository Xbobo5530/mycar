import 'package:my_car/src/models/account_model.dart';
import 'package:my_car/src/models/ad_model.dart';
import 'package:my_car/src/models/answer_model.dart';
import 'package:my_car/src/models/chat_model.dart';
import 'package:my_car/src/models/file_model.dart';
import 'package:my_car/src/models/question_model.dart';
import 'package:my_car/src/models/tool_model.dart';
import 'package:my_car/src/models/ui_controller.dart';
import 'package:my_car/src/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';


const _tag = 'MyCarModel';

class MainModel extends Model
    with
        AccountModel,
        UserModel,
        QuestionModel,
        AnswerModel,
        NavModel,
        ToolsModel,
        ChatModel,
        AdModel,
        FileModel {
  MainModel() {
    print('$_tag at MainModel()');
    updateLoginStatus();
  getQuestions();
  }
}
