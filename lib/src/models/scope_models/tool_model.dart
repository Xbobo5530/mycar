import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_car/src/models/tool.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class ToolsModel extends Model {
  String _pdfPathCache;

  Future<String> createFileOfPdfUrl(Tool tool) async {
    if (_pdfPathCache != null) return _pdfPathCache;
    final url = tool.goToUrl;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    _pdfPathCache = file.path;
    return _pdfPathCache;
  }

  openRemoteUrl(Tool tool) {
    _launchURL(tool.goToUrl);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
