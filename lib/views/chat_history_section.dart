import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_car/models/chat.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/views/chat_item.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatHistorySectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ScopedModelDescendant<MainModel>(
      builder: (context, child, model) => StreamBuilder<QuerySnapshot>(
            stream: model.liveChatStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                controller: model.scrollController,
                reverse: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  Chat chat = Chat.fromSnapshot(snapshot.data.documents[index]);

                  return FutureBuilder<Chat>(
                    initialData: chat,
                    future: model.refinedChat(chat),
                    builder: (context, snapshot) {
                      Chat refinedChat =
                          snapshot.data == null ? chat : snapshot.data;
                      return ChatItemView(
                          chat: refinedChat, key: Key(refinedChat.id));
                    },
                  );
                },
              );
            },
          ),
    ));
  }
}