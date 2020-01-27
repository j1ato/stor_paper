import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/ui/screens/favorite_stories.dart';
import 'package:stor_paper/ui/screens/home.dart';
import 'package:stor_paper/ui/screens/login.dart';
import 'package:stor_paper/ui/screens/settings.dart';
import 'package:stor_paper/ui/screens/register_screen.dart';
import 'package:stor_paper/ui/screens/volume_wallpaper_download.dart';
import 'package:stor_paper/ui/screens/stories.dart';
import 'package:stor_paper/ui/screens/verify_email_screen.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:stor_paper/ui/screens/read_screen.dart';
import 'package:stor_paper/ui/screens/volumes.dart';
import 'package:stor_paper/utils/user_repository.dart';
import 'package:stor_paper/ui/screens/sign_up_options.dart';

// main screen that contains changeNotifierProvider
// also contains page routes 

void main() => runApp(
      StorPaperApp(),
    );

class StorPaperApp extends StatefulWidget {
  @override
  _StorPaperAppState createState() => _StorPaperAppState();
}

class _StorPaperAppState extends State<StorPaperApp> {
  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    return ChangeNotifierProvider<UserRepository>(
      create: (context) => UserRepository.instance(),
      child: MaterialApp(
        theme: buildTheme(),
        title: 'StorPaper',
        home: Consumer(
          builder: (context, UserRepository user, _) {
            switch (user.status) {
              case Status.authenticating:
              case Status.unauthenticated:
                currentScreen = SignUpOptionsScreen();
                break;
              case Status.authenticated:
                currentScreen = HomeScreen();
                break;
            }
            return currentScreen;
          },
        ),
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          SignUpOptionsScreen.id: (context) => SignUpOptionsScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          VerifyEmailScreen.id: (context) => const VerifyEmailScreen(),
          VolumesCardList.id: (context) => const VolumesCardList(),
          StoriesScreen.id: (context) => const StoriesScreen(),
          ReadStory.id: (context) => const ReadStory(),
          DownloadWallpaper.id: (context) => const DownloadWallpaper(),
          FavoritesScreen.id: (context) => const FavoritesScreen(),
          OptionsScreen.id: (context) => const OptionsScreen(),
        },
      ),
    );
  }
}
