import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/answer_item.dart';
import 'package:my_car/views/question_item.dart';

const tag = 'ViewQuestionPage';
final ansFun = Answer();
final fun = Functions();

class ViewQuestionPage extends StatelessWidget {
  final Question question;

  ViewQuestionPage({this.question});

  @override
  Widget build(BuildContext context) {
    var _data = fun.database
        .collection(QUESTIONS_COLLECTION)
        .document(question.id)
        .collection(ANSWERS_COLLECTION)
        .orderBy(CREATED_AT_FIELD, descending: true)
        .snapshots();

    var _questionSection = QuestionItemView(
      question: question,
      source: tag,
    );

    var _answersSection = StreamBuilder(
        stream: _data,
        builder: (_, snapshot) {
          if (!snapshot.hasData)
            return Center(child: Center(child: CircularProgressIndicator()));

          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (_, index) {
                var answer = ansFun.getAnsFromSnapshots(snapshot, index);
                return AnswerItemView(
                  answer: answer,
                );
              });
        });

//    return Scaffold(
//      body: CustomScrollView(
//        slivers: <Widget>[
//          SliverAppBar(
////                  pinned: true,
////            snap: true,
//            floating: true,
//            title: Text(questionText),
//          ),
//          SliverList(
//              delegate: SliverChildListDelegate(<Widget>[
//            Column(
//              children: <Widget>[
//                _questionSection,
//                Expanded(child: _answersSection)
//              ],
//            )
//          ])),
//          SliverFillRemaining()
//        ],
//      ),
//    );

//    return Scaffold(
//      body: NestedScrollView(
//          headerSliverBuilder: (_, innerBoxIsScrolled) {
//            return <Widget>[
//              SliverAppBar(
//                forceElevated: innerBoxIsScrolled,
////                  pinned: true,
//                snap: true,
//                floating: true,
//                title: Text(questionText),
//              ),
//              SliverFillRemaining(
//                child: _questionSection,
//              ),
//            ];
//          },
//          body: Column(
//            children: <Widget>[
//              _questionSection,
//              Expanded(child: _answersSection),
//            ],
//          )),
//    );

    return Scaffold(
        appBar: AppBar(
          title: Text(questionText),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            _questionSection,
            Expanded(child: _answersSection),
          ],
        ));
  }
}
