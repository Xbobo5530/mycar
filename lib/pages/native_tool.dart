import 'package:flutter/material.dart';
import 'package:my_car/models/tools.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/warning_signs_page.dart';

const _tag = 'NativeToolPage:';

class NativeToolPage extends StatelessWidget {
  final Tool tool;

  NativeToolPage({this.tool});

  @override
  Widget build(BuildContext context) {
    Widget _buildNativeToolView() {
      switch (tool.id) {
        case NATIVE_TOOL_WARNING_SIGNS:
          return WarningSignsPageView();
          break;
        default:
          print('$_tag tool id is $NATIVE_TOOL_WARNING_SIGNS');
          return Container(
            child: Center(child: Text(errorMessage)),
          );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tool.title),
      ),
      body: _buildNativeToolView(),
    );
  }
}
