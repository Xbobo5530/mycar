import 'package:flutter/material.dart';
import 'package:my_car/src/models/tool.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:my_car/src/utils/strings.dart';

final List<Tool> tools = <Tool>[
  Tool(
      title: ticketCheckTitle,
      description: ticketCheckDesc,
      icon: Icon(
        Icons.network_check,
        size: 50.0,
      ),
      goToUrl: URL_TICKET,
      type: ToolType.nativeUrl),
  Tool(
      title: taxValuationTitle,
      description: taxValuationDesc,
      icon: Icon(
        Icons.directions_car,
        size: 50.0,
      ),
      goToUrl: URL_TAX,
      type: ToolType.remoteUrl),
  Tool(
      title: trafficActTitle,
      description: trafficActDesc,
      goToUrl: PDF_URL_TRAFFIC_ACT,
      icon: Icon(
        Icons.local_library,
        size: 50.0,
      ),
      type: ToolType.pdfUrl),
  Tool(
    title: insuranceInfoTitle,
    description: insuranceInfoDesc,
    goToUrl: URL_TIRA,
    icon: Icon(
      Icons.assignment,
      size: 50.0,
    ),
    type: ToolType.nativeUrl,
  ),
  Tool(
      id: NATIVE_TOOL_WARNING_SIGNS,
      title: dashboardWarningTitle,
      description: dashboardWarningDesc,
      icon: Icon(
        Icons.warning,
        size: 50.0,
      ),
      type: ToolType.native)
];
