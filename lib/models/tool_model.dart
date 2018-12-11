import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_car/models/tool.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';

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
}
