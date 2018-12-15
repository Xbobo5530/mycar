import 'package:my_car/models/account_model.dart';
import 'package:my_car/models/ad_model.dart';
import 'package:my_car/models/answer_model.dart';
import 'package:my_car/models/chat_model.dart';
import 'package:my_car/models/question_model.dart';
import 'package:my_car/models/tool_model.dart';
import 'package:my_car/models/ui_controller.dart';
import 'package:my_car/models/user_model.dart';
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
        AdModel {
  MainModel() {
    print('$_tag at MainModel()');
    updateLoginStatus();
  getQuestions();
  }
}
