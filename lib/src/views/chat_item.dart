import 'package:flutter/material.dart';
import 'package:my_car/src/models/chat.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatItemView extends StatelessWidget {
  final Chat chat;
  final bool isMe;

  const ChatItemView({
    Key key,
    this.chat,
    this.isMe,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bg = !isMe ? Colors.white : Colors.lightBlueAccent.shade100;
    final align = !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final radius = !isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );

    final _userImageAndName = Row(
      children: <Widget>[
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.blue,
          backgroundImage: chat.userImageUrl != null
              ? NetworkImage(chat.userImageUrl)
              : null,
          child: chat.userImageUrl == null ? Icon(Icons.account_circle) : null,
        ),
        chat.username != null
            ? Text(
                chat.username,
                style: TextStyle(color: Colors.black38, fontSize: 12),
              )
            : Container()
      ],
    );

    final _imageSection = Container(
      child: chat.fileType == FILE_TYPE_IMAGE
          ? chat.fileUrl != null
              ? Image.network(chat.fileUrl)
              : Center(
                  child: Icon(
                    Icons.cloud_download,
                    size: 60,
                    color: Colors.black12,
                  ),
                )
          : Container(),
    );
    final _userDetailsSection = !isMe ? _userImageAndName : Container();

    final _messageSection = chat.message != null
        ? Padding(
            padding: EdgeInsets.only(right: 48.0),
            child: Linkify(
              onOpen: (url) async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              text: chat.message,
              // style: TextStyle(color: Colors.yellow),  
              linkStyle: TextStyle(color: Colors.red),
            ))
        : Container();

    final _metaSection = Positioned(
      bottom: 0.0,
      right: 0.0,
      child: Row(
        children: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (context, child, model) => Text(model.chatMetaData(chat),
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 10.0,
                )),
          ),
          // SizedBox(width: 3.0),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[_messageSection, _metaSection],
          ),
        ),
        _imageSection,
        _userDetailsSection
      ],
    );
  }
}
