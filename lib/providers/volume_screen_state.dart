import 'package:flutter/material.dart';

class VolumeScreenState extends ChangeNotifier {
  double _offset;
  double _page;

  VolumeScreenState(PageController pageController) {
    pageController.addListener(
      () {
        _offset = pageController.offset;
        _page = pageController.page;
        notifyListeners();
      },
    );
  }

  double get offset => _offset;
  double get page => _page;
}
