import 'package:flutter/material.dart';
import 'package:my_car/src/utils/status_code.dart';

class Tool {
  int id;
  String title, description, imageUrl, goToUrl;
  Icon icon;
  ToolType type;

  Tool({
    this.id,
    @required this.title,
    @required this.description,
    this.imageUrl,
    @required this.icon,
    @required this.type,
    this.goToUrl,
  })  : assert(title != null),
        assert(description != null),
        assert(type != null);
}
