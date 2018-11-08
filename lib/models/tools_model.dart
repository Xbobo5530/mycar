import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_car/models/tools.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class ToolsModel extends Model {
  String _pdfPathCache;

  List<Tool> get tools => _tools;
  final List<Tool> _tools = <Tool>[
    Tool(
        title: ticketCheckTitle,
        description: ticketCheckDesc,
        icon: Icon(
          Icons.network_check,
          size: 50.0,
        ),
        goToUrl: ticketUrl),
    Tool(
        title: taxValuationTitle,
        description: taxValuationDesc,
        icon: Icon(
          Icons.directions_car,
          size: 50.0,
        ),
        goToUrl: taxUrl),
    Tool(
        title: trafficActTitle,
        description: trafficActDesc,
        goToUrl: trafficActPdfUrl,
        isPdf: true,
        icon: Icon(
          Icons.local_library,
          size: 50.0,
        )),
    Tool(
      title: insuranceInfoTitle,
      description: insuranceInfoDesc,
      goToUrl: tiraUrl,
      icon: Icon(
        Icons.assignment,
        size: 50.0,
      ),
    )
  ];

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
