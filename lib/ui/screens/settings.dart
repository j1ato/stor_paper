import 'package:flutter/material.dart';
import 'package:stor_paper/ui/widgets/flushbars.dart';
import 'package:stor_paper/ui/widgets/settings_card.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:stor_paper/utils/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// settings page that holds links to website and instagram
// also allows sign out and will have privacy policy and terms of usage

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({Key key}) : super(key: key);
  static String id = 'profile';

  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    Future<void> _launchWebsiteURL() async {
      const url = 'https://www.eightonlyltd.com/bio';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    }

    Future<void> _launchInstaURL() async {
      const url = 'https://www.instagram.com/africdote/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  SettingsCard(
                    onPressed: _launchWebsiteURL,
                    text: 'Meet the creators',
                  ),
                  SettingsCard(
                    onPressed: _launchInstaURL,
                    text: 'Find us on instagram',
                  ),
                  const SettingsCard(
                    onPressed: null,
                    text: 'Terms of usage',
                  ),
                  const SettingsCard(
                    onPressed: null,
                    text: 'Privacy policy',
                  ),
                  SettingsCard(
                    onPressed: () {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              child: Text(
                                'Are you sure?',
                                style: buildTheme().textTheme.bodyText2,
                              ),
                            ),
                            actions: <Widget>[
                              RawMaterialButton(
                                constraints: const BoxConstraints(
                                    minWidth: 60, minHeight: 30),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'NO',
                                  style: buildTheme().textTheme.button,
                                ),
                              ),
                              RawMaterialButton(
                                constraints: const BoxConstraints(
                                    minWidth: 60, minHeight: 30),
                                onPressed: () async {
                                  await user.checkConnectivity();
                                  Navigator.pop(context);
                                  if (user.isConnected == true) {
                                    await user.signOut();
                                  } else {
                                    Flushbars().connetivityFlushbar(context);
                                  }
                                },
                                child: Text(
                                  'YES',
                                  style: buildTheme().textTheme.button,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    text: 'Sign out',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
