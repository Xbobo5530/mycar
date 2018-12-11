import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/tool.dart';
import 'package:my_car/models/tools_data.dart';
import 'package:my_car/pages/native_tool.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'ToolsPage';
const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class ToolsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildPdfPage(MainModel model, Tool tool) => FutureBuilder<String>(
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
          },
        );

    _handlePdf(MainModel model, Tool tool) {
      print('$_tag at _handlePdf');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => _buildPdfPage(model, tool),
              fullscreenDialog: true));
    }

    _openUrl(Tool tool) {
      print('$_tag at _openUrl');
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
              fullscreenDialog: true));
    }

    _openNativeTool(Tool tool) {
      print('$_tag at _openNativeTool');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => NativeToolPage(tool: tool),
              fullscreenDialog: true));
    }

    _openToolPage(MainModel model, Tool tool) {
      print('$_tag at _openToolPage');
      switch (tool.type) {
        case ToolType.nativeUrl:
          _openUrl(tool);
          break;
        case ToolType.pdfUrl:
          _handlePdf(model, tool);
          break;
        case ToolType.native:
          _openNativeTool(tool);
          break;
        case ToolType.remoteUrl:
          model.openRemoteUrl(tool);
          break;
        default:
          print('$_tag the unknown tool type is ${tool.type}');
      }
    }

    return ScopedModelDescendant<MainModel>(
      builder: (_, __, model) {
        return GridView.builder(
            itemCount: tools.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (_, index) {
              final tool = tools[index];
              return InkWell(
                onTap: () => _openToolPage(model, tool),
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
