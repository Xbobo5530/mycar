import 'package:flutter/material.dart';
import 'package:my_car/src/models/ad.dart';
import 'package:my_car/src/pages/login.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class NavModel extends Model {
  int _currentNavItem = 0;

  int get currentNavItem => _currentNavItem;

  updateSelectedNavItem(int selectedItem) {
    _currentNavItem = selectedItem;
    notifyListeners();
  }

  goToLoginPage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return LoginPage();
        });
  }

  final _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;
  updateListViewPosition() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  String keyDecoder(String key) {
    switch (key) {
      case KEY_CONTACT_PHONE:
        return callText;
      case KEY_CONTACT_EMAIL:
        return emailText;
      case KEY_CONTACT_WEB:
        return visitSiteText;
      default:
        return key;
    }
  }

  Widget iconDecoder(String key) {
    switch (key) {
      case KEY_CONTACT_PHONE:
        return Icon(Icons.call);
      case KEY_CONTACT_EMAIL:
        return Icon(Icons.email);
      case KEY_CONTACT_WEB:
        return Icon(Icons.web);
      default:
        return Icon(Icons.person);
    }
  }

  Future<StatusCode> onTapDecoder(String key, Ad ad) async {
    switch (key) {
      case KEY_CONTACT_PHONE:
        return await _launchUrl('tel:${ad.contact[key]}');
      case KEY_CONTACT_EMAIL:
        return await _launchUrl('mailto:${ad.contact[key]}');
      case KEY_CONTACT_WEB:
        return await _launchUrl(ad.contact[key]);
      default:
        return StatusCode.failed;
    }
  }

  Future<StatusCode> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      return StatusCode.success;
    } else {
      return StatusCode.failed;
    }
  }
}
