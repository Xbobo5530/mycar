import 'package:flutter/material.dart';
import 'package:my_car/pages/login.dart';
import 'package:scoped_model/scoped_model.dart';

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
}
