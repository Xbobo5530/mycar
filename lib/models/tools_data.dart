
import 'package:flutter/material.dart';
import 'package:my_car/models/tool.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:my_car/utils/strings.dart';

final List<Tool> tools = <Tool>[
  // Tool(
  //   id: NATIVE_TOOL_FORUM,
  //   title: forumTitle,
  //   description: forumDesc,
  //   type: ToolType.native,
  //   icon:Icon(Icons.forum, size: 50.0, ),
    
  // ),
  Tool(
      title: ticketCheckTitle,
      description: ticketCheckDesc,
      icon: Icon(
        Icons.network_check,
        size: 50.0,
      ),
      goToUrl: URL_TICKET,
      type: ToolType.url),
//  Tool(
//      title: taxValuationTitle,
//      description: taxValuationDesc,
//      icon: Icon(
//        Icons.directions_car,
//        size: 50.0,
//      ),
//      goToUrl: taxUrl,
//      type: ToolType.url),
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
    type: ToolType.url,
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
