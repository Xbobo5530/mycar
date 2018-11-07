import 'package:scoped_model/scoped_model.dart';

abstract class NavModel extends Model {
  int _currentNavItem = 0;

  int get currentNavItem => _currentNavItem;

  updateSelectedNavItem(int selectedItem) {
    _currentNavItem = selectedItem;
    notifyListeners();
  }
}
