import 'package:flutter/material.dart';

class PageState with ChangeNotifier {
  TextEditingController controller = TextEditingController();
  bool offstageOfTextField = true;

  void toggleButton() {
    offstageOfTextField = false;
    notifyListeners();
  }


}