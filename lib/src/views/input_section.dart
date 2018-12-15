import 'package:flutter/material.dart';
import 'package:my_car/src/models/main_model.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';

class InputSectionView extends StatefulWidget {
  @override
  InputSectionViewState createState() {
    return InputSectionViewState();
  }
}

class InputSectionViewState extends State<InputSectionView> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildLoginView(MainModel model) => ListTile(
        onTap: () => model.goToLoginPage(context),
        title: Text(
          loginText,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        ));
    _handleSendMessage(MainModel model) async {
      final message = _controller.text.trim();
      if (message.isEmpty) return null;
      // StatusCode status = await model.sendMessage(message, model.currentUser);
      model.sendMessage(message, model.currentUser);
      // if (status == StatusCode.failed) _showErrorMessage();

      _controller.text = '';
      model.updateListViewPosition();
    }

    _handleAdd(MainModel model, AddFileItem item) {
      //TODO: handle adding a file
    }

    _buildSendButton(MainModel model) => IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.white,
          ),
          onPressed: () => _handleSendMessage(model),
        );

    _buildAddIcon(MainModel model) => PopupMenuButton<AddFileItem>(
          icon: Icon(
            Icons.add_circle,
            color: Colors.white,
          ),
          onSelected: (item) => _handleAdd(model, item),
          itemBuilder: (context) => <PopupMenuEntry<AddFileItem>>[
                PopupMenuItem(
                  value: AddFileItem.camera,
                  child: Text(cameraText),
                ),
                PopupMenuItem(
                  value: AddFileItem.image,
                  child: Text(imageText),
                ),
              ],
        );

    _buildField(MainModel model) => TextField(
          controller: _controller,
          maxLines: null,
          cursorColor: Colors.white,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
              hintText: sendMessageHint,
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
              suffixIcon: _buildSendButton(model),
              prefixIcon: _buildAddIcon(model)),
        );
    return Material(
      elevation: 4,
      child: Container(
        color: Colors.blue,
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) =>
              model.isLoggedIn ? _buildField(model) : _buildLoginView(model),
        ),
      ),
    );
  }
}
