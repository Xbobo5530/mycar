import 'package:flutter/material.dart';
import 'package:my_car/src/models/ad.dart';
import 'package:my_car/src/models/main_model.dart';
import 'package:my_car/src/utils/colors.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/my_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateAdPage extends StatefulWidget {
  @override
  CreateAdPageState createState() {
    return new CreateAdPageState();
  }
}

class CreateAdPageState extends State<CreateAdPage> {
  final _descriptionController = TextEditingController();
  final _cotactPhoneController = TextEditingController();
  final _contactEmailcontroller = TextEditingController();
  final _contactWebcontroller = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _cotactPhoneController.dispose();
    _contactEmailcontroller.dispose();
    _contactWebcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width / 1.2;
    final _appBar = AppBar(
      title: Text(createAdText),
    );
    final _imageSection =ScopedModelDescendant<MainModel>(builder:(_,__,model)=> Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      width: _width,
      height: 200,
      child: InkWell(
        onTap: ()=>model.getFile(AddFileItem.image),
        child: Icon(
          Icons.add_photo_alternate,
          size: 100,
          color: Colors.black12,
        ),
      )
      
      
      
     
    ));
    final _descriptionSection = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          width: _width,
          decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
          child: TextField(
            maxLines: null,
            controller: _descriptionController,
            decoration: InputDecoration(
                hintText: enterDescHintText, border: InputBorder.none),
          ),
        ));
    _buildContactItem(String label, String hint,
            TextEditingController controller, TextInputType inputType) =>
        Container(
            width: _width,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('$label:'),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: inputType,
                    decoration: InputDecoration(hintText: hint),
                  ),
                )
              ],
            ));
    final _contactSection = Column(
      children: <Widget>[
        _buildContactItem(
            phoneText, phoneHint, _cotactPhoneController, TextInputType.phone),
        _buildContactItem(emailAcionText, emailHint, _contactEmailcontroller,
            TextInputType.emailAddress),
        _buildContactItem(
            webText, webHint, _contactWebcontroller, TextInputType.url)
      ],
    );

    _submitAd(BuildContext context, MainModel model) async {
      final description = _descriptionController.text.trim();
      final phone = _cotactPhoneController.text.trim();
      final email = _contactEmailcontroller.text.trim();
      final web = _contactWebcontroller.text.trim();
      if (description.isEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(emptyDescMessage),
        ));
        return null;
      }
      final Ad ad = Ad(
          description: description,
          contact: {
            KEY_CONTACT_PHONE: phone.isNotEmpty ? phone : null,
            KEY_CONTACT_EMAIL: email.isNotEmpty ? email : null,
            KEY_CONTACT_WEB: web.isNotEmpty ? web : null

          },
          imageStatus: model.imageFile != null ? FILE_STATUS_UPLOADING : FILE_STATUS_NO_FILE,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          createdBy: model.currentUser.id);

      final status = await model.submitAd(ad);
      if (status == StatusCode.failed) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
        ));
        return null;
      }
      if (model.imageFile != null) {
        model.uploadFile(FileUploadFor.ad, ad);
      }
      Navigator.pop(context);
    }

    final _actions = ButtonBar(
      children: <Widget>[
        ScopedModelDescendant<MainModel>(
          builder: (_, __, model) {
            return RaisedButton(
              color: darkColor,
              onPressed: () => model.submittingAdStatus == StatusCode.waiting
                  ? null
                  : _submitAd(context, model),
              child: model.submittingAdStatus == StatusCode.waiting
                  ? MyProgressIndicator(
                      size: 15.0,
                      color: Colors.white,
                    )
                  : Text(submitText, style: TextStyle(color: Colors.white)),
            );
          },
        )
      ],
    );
    final _body = ListView(
      children: <Widget>[
        _imageSection,
        _descriptionSection,
        _contactSection,
        _actions
      ],
    );
    return Scaffold(
      appBar: _appBar,
      body: _body,
    );
  }
}
