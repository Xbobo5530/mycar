import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_car/models/chat.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/views/chat_item.dart';
import 'package:my_car/views/input_section.dart';
import 'package:scoped_model/scoped_model.dart';

class LiveChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _chatHistorySection = Expanded(
        child: ScopedModelDescendant<MainModel>(
      builder: (context, child, model) => StreamBuilder<QuerySnapshot>(
            stream: model.liveChatStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => ChatItemView(
                    chat: Chat.fromSnapshot(snapshot.data.documents[index]),
                    key: Key(
                        Chat.fromSnapshot(snapshot.data.documents[index]).id)),
              );
            },
          ),
    ));

    return Column(
      children: <Widget>[_chatHistorySection, InputSectionView()],
    );
  }
}
