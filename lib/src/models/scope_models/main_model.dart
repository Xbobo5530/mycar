import 'package:my_car/src/models/scope_models/account_model.dart';
import 'package:my_car/src/models/scope_models/ad_model.dart';
import 'package:my_car/src/models/scope_models/answer_model.dart';
import 'package:my_car/src/models/scope_models/chat_model.dart';
import 'package:my_car/src/models/scope_models/file_model.dart';
import 'package:my_car/src/models/scope_models/question_model.dart';
import 'package:my_car/src/models/scope_models/tool_model.dart';
import 'package:my_car/src/models/scope_models/user_model.dart';
import 'package:my_car/src/models/ui_controller.dart';
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
