import 'package:flutter/material.dart';
import 'package:my_car/models/answer.dart';

class AnswerItemView extends StatefulWidget {
  final Answer answer;

  AnswerItemView({this.answer});

  @override
  _AnswerItemViewState createState() => _AnswerItemViewState();
}

class _AnswerItemViewState extends State<AnswerItemView> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.answer.answer),
    );
  }
}
