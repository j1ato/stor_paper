import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stor_paper/ui/screens/volumes.dart';
import 'package:stor_paper/ui/screens/favorite_stories.dart';
import 'package:stor_paper/ui/screens/settings.dart';
import 'package:stor_paper/ui/theme.dart';

// Bottom navigation bar with corresponding screens and
// page storage keys to keep scroll location of each page

class HomeScreen extends StatefulWidget {
  static String id = 'homescreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Key keyOne = const PageStorageKey('CollectionsCardList');
  final Key keyTwo = const PageStorageKey('FavoriteStoriesList');
  final Key keyThree = const PageStorageKey('SettingsScreen');

  int currentTabIndex = 0;

  VolumesCardList collectionsCardList;
  FavoritesScreen favoritesScreen;
  OptionsScreen optionsScreen;
  List<Widget> pages;
  Widget currentpage;

  @override
  void initState() {
    collectionsCardList = VolumesCardList(
      key: keyOne,
    );
    favoritesScreen = FavoritesScreen(
      key: keyTwo,
    );
    optionsScreen = OptionsScreen(
      key: keyThree,
    );

    pages = [collectionsCardList, favoritesScreen, optionsScreen];

    currentpage = collectionsCardList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentpage,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: buildTheme().bottomAppBarColor,
          ),
          child: BottomNavigationBar(
              selectedItemColor: Colors.white.withOpacity(0.8),
              unselectedItemColor: Colors.grey.shade700.withOpacity(0.5),
              elevation: 0,
              type: BottomNavigationBarType.shifting,
              currentIndex: currentTabIndex,
              onTap: (int index) {
                setState(() {
                  currentTabIndex = index;
                  currentpage = pages[index];
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.book,
                      size: 25,
                    ),
                    title: const Text(
                      '',
                      style: TextStyle(fontSize: 0),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.favorite,
                      size: 25,
                    ),
                    title: const Text(
                      '',
                      style: TextStyle(fontSize: 0),
                    )),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                    size: 25,
                  ),
                  title: const Text(
                    ' ',
                    style: TextStyle(fontSize: 0),
                  ),
                )
              ]),
        ));
  }
}
