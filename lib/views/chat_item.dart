import 'package:flutter/material.dart';
import 'package:my_car/models/chat.dart';

class ChatItemView extends StatelessWidget {
  final Chat chat;

  const ChatItemView({Key key, this.chat}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(
          chat.message,
          textAlign: TextAlign.center,
        ),
        subtitle: Chip(
          label: Text(chat.username),
          avatar: chat.userImageUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(chat.userImageUrl),
                  backgroundColor: Colors.black12,
                )
              : null,
        ),
      ),
    );
  }
}
