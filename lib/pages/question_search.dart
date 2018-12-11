import 'package:flutter/material.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/pages/view_question.dart';
import 'package:my_car/views/heading_section.dart';

class QuestionsSearch extends SearchDelegate<Question> {
  final List<Question> questionsList;
  QuestionsSearch({this.questionsList});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = questionsList.where((question) =>
        question.question.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: results
          .map<HeadingSectionView>((result) => HeadingSectionView(
              heading: result.question,
              imageUrl: result.createdBy,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewQuestionPage(question: result, key: Key(result.id),),
                  ))))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = questionsList.where((question) =>
        question.question.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: results
          .map<HeadingSectionView>((result) => HeadingSectionView(
              heading: result.question,
              imageUrl: result.createdBy,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewQuestionPage(question: result, key: Key(result.id),),
                  ))))
          .toList(),
    );
  }
}
