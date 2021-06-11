import 'package:flutter/material.dart';

var listView = ViewType.List;
var gridView = ViewType.Grid;

enum ViewType { List, Grid }

class ViewModifier extends ChangeNotifier {
  ViewType currentView = gridView;

  setView(ViewType themeType) {
    if (themeType == ViewType.List) {
      currentView = listView;
      return notifyListeners();
    } else if (themeType == ViewType.Grid) {
      currentView = gridView;
      return notifyListeners();
    }
  }
}