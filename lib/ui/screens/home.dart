import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/model/database_services.dart';
import 'package:stor_paper/model/volume_class.dart';
import 'package:stor_paper/ui/screens/volumes.dart';
import 'package:stor_paper/ui/screens/favorite_stories.dart';
import 'package:stor_paper/ui/screens/settings.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:stor_paper/utils/user_repository.dart';

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

  VolumesCardList volumesCardList;
  FavoritesScreen favoritesScreen;
  OptionsScreen optionsScreen;
  List<Widget> pages;
  Widget currentpage;

  @override
  void initState() {
    volumesCardList = VolumesCardList(
      key: keyOne,
    );
    favoritesScreen = FavoritesScreen(
      key: keyTwo,
    );
    optionsScreen = OptionsScreen(
      key: keyThree,
    );

    pages = [volumesCardList, favoritesScreen, optionsScreen];

    currentpage = volumesCardList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseUser currentUser = Provider.of<UserRepository>(context).user;
    final DatabaseServices db = DatabaseServices();

    return MultiProvider(
      providers: [
        StreamProvider<List<Volume>>.value(
          value: db.streamVolumes(),
          catchError: (context, error) => null,
        ),
        StreamProvider<UserFavorites>.value(
            value: db.streamFavorites(currentUser),
            catchError: (context, error) {
              print(
                  'this is the user favorites' 
                  ' stream error ${error.toString()}');
              return UserFavorites.fromFirestore({
                'favorites': ['']
              });
            }),
      ],
      child: Scaffold(
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
          )),
    );
  }
}
