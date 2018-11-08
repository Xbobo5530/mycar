import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/tools.dart';
import 'package:scoped_model/scoped_model.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class ToolsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _handlePdf(MainModel model, Tool tool) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FutureBuilder<String>(
                      future: model.createFileOfPdfUrl(tool),
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

    _openUrl(Tool tool) {
      /*flutterWebviewPlugin.launch(tool
                      .goToUrl)*/
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                WebviewScaffold(
                  withJavascript: true,
                  url: tool.goToUrl,
                  headers: {'User-Agent': 'Mozilla/5.0'},
                  userAgent: kAndroidUserAgent,
                  appBar: AppBar(
                    title: Text(tool.title),
                  ),
                ),
          ));
    }

    return ScopedModelDescendant<MainModel>(
      builder: (_, __, model) {
        return GridView.builder(
            itemCount: model.tools.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (_, index) {
              final tool = model.tools[index];
              return InkWell(
                onTap: tool.isPdf
                    ? () => _handlePdf(model, tool)
                    : () => _openUrl(tool),
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
      },
    );
  }
}
