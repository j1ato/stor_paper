import 'package:flutter/material.dart';
import 'package:stor_paper/model/database_models.dart';

class VolumeScreenState extends ChangeNotifier {
  double _offset;
  double _page;
  String _volumeTitle;

  void updateVolumeScreenState(PageController pageController) {
    pageController.addListener(
      () {
        _offset = pageController.offset;
        _page = pageController.page;
        notifyListeners();
      },
    );
  }

  void updateVolumeTitle(Volume currentVolume) {
    _volumeTitle = currentVolume.volumeTitle;
    // notifyListeners();
  }

  double get offset => _offset;
  double get page => _page;
  String get volumeTitle => _volumeTitle;
}

class StoriesScreenState extends ChangeNotifier {
  double _favoritesScreenOffset = 0;
  double _volumeStoriesOffset = 0;

  void updateFavoriteStoriesScreenState(ScrollController scrollController) {
    scrollController.addListener(
      () {
        print(scrollController.offset);
        _favoritesScreenOffset = scrollController.offset;
        notifyListeners();
      },
    );
  }

  void updateVolumeStoriesScreenState(ScrollController scrollController) {
    scrollController.addListener(
      () {
        print(scrollController.offset);
        _volumeStoriesOffset = scrollController.offset;
        notifyListeners();
      },
    );
  }

  void initialVolumeStoriesScrollState(double scrollOffset) {
    _volumeStoriesOffset = scrollOffset;
  }

  double get favoritesScreenOffset => _favoritesScreenOffset;
  double get volumeStoriesOffset => _volumeStoriesOffset;
}
