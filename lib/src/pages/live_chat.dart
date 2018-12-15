import 'package:flutter/material.dart';
import 'package:my_car/src/views/chat_history_section.dart';
import 'package:my_car/src/views/input_section.dart';

class LiveChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[ChatHistorySectionView(), InputSectionView()],
    );
  }
}
