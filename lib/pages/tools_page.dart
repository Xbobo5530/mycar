import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:my_car/utils/consts.dart';
import 'package:path_provider/path_provider.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class ToolsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Tool> tools = <Tool>[
      Tool(
          title: 'Ticket Check',
          description: 'Check whether your Licence or Vehicle has a ticket',
          icon: Icon(
            Icons.network_check,
            size: 50.0,
          ),
          goToUrl: ticketUrl),
//      Tool(
//          title: 'Vehicle Tax Valuation',
//          description: 'Check the Tax Valuation for importing a vehicle',
//          icon: Icon(
//            Icons.directions_car,
//            size: 50.0,
//          ),
//          goToUrl: taxUrl),
      Tool(
          title: 'The Road Traffic Act',
          description:
              'The road traffic act for the United Republic of Tanzania',
          goToUrl: trafficActPdfUrl,
          isPdf: true,
          icon: Icon(
            Icons.local_library,
            size: 50.0,
          ))
    ];

    Future<String> _createFileOfPdfUrl(Tool tool) async {
      final url = tool.goToUrl;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File('$dir/$filename');
      await file.writeAsBytes(bytes);
      return file.path;
    }

    _handlePdf(Tool tool) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FutureBuilder(
                  future: _createFileOfPdfUrl(tool),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Scaffold(
                          appBar: AppBar(
                            title: Text(tool.title),
                          ),
                          body: Center(child: CircularProgressIndicator()));
                    final pathPDF = snapshot.data;
                    return PDFViewerScaffold(
                        appBar: AppBar(
                          title: Text(tool.title),
                        ),
                        path: pathPDF);
                  })));
    }

    return GridView.builder(
        itemCount: tools.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_, index) {
          final tool = tools[index];
          return InkWell(
            onTap: tool.isPdf
                ? () => _handlePdf(tool)
                : () =>

                    /*flutterWebviewPlugin.launch(tool
                    .goToUrl)*/
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WebviewScaffold(
                                withJavascript: true,
                                url: tool.goToUrl,
                                headers: {'User-Agent': 'Mozilla/5.0'},
                                userAgent: kAndroidUserAgent,
                                appBar: AppBar(
                                  title: Text(tool.title),
                                ),
                              ),
                        )),
            child: Column(
              children: <Widget>[
                tool.icon,
                ListTile(
                  title: Text(tool.title),
                  subtitle: Text(tool.description),
                )
              ],
            ),
          );
        });
  }
}

class Tool {
  String title, description, imageUrl, goToUrl;
  Icon icon;
  bool isPdf;

  Tool(
      {@required this.title,
      @required this.description,
      this.imageUrl,
      @required this.icon,
      @required this.goToUrl,
      this.isPdf = false})
      : assert(title != null),
        assert(description != null),
        assert(goToUrl != null);
}
