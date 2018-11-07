import 'package:flutter/material.dart';

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
