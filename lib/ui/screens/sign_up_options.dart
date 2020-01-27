import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/ui/screens/login.dart';
import 'package:stor_paper/ui/screens/register_screen.dart';
import 'package:stor_paper/ui/widgets/flushbars.dart';
import 'package:stor_paper/ui/widgets/terms_privacy_button.dart';
import 'package:stor_paper/utils/user_repository.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../theme.dart';

// gives options for user to either sign in with google
// facebook or through creating an account by email 

class SignUpOptionsScreen extends StatefulWidget {
  static String id = 'register options';
  @override
  _SignUpOptionsScreenState createState() => _SignUpOptionsScreenState();
}

class _SignUpOptionsScreenState extends State<SignUpOptionsScreen> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    Column _buildLogo() {
      return Column(
        children: <Widget>[
          Image.asset(
            'images/ig.jpg',
            width: 180,
            height: 180,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: user.status == Status.authenticating
            ? Center(
                child: SpinKitPulse(
                  size: 150,
                  color: Colors.white.withOpacity(0.6),
                ),
              )
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 80),
                      _buildLogo(),
                      const SizedBox(
                        height: 80,
                      ),
                      SignInButton(
                        Buttons.Google,
                        text: 'Continue with Google',
                        onPressed: () async {
                          try {
                            await user.checkConnectivity();
                            if (user.isConnected == true) {
                              await user.signInWithGoogle();
                            } else {
                              Flushbars().connetivityFlushbar(context);
                            }
                          } on Exception catch (e) {
                            print(e);
                          }
                        },
                      ),
                      SignInButton(Buttons.Facebook,
                          text: 'Continue with Facebook', onPressed: () async {
                        await user.checkConnectivity();
                        if (user.isConnected == true) {
                          await user.signInWithFacebook();
                        } else {
                          Flushbars().connetivityFlushbar(context);
                        }
                      }),
                      SignInButton(
                        Buttons.Email,
                        text: 'Sign up with Email',
                        onPressed: () =>
                            Navigator.pushNamed(context, RegisterScreen.id),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FlatButton(
                        child: Text(
                          'Already have an account? Sign in here.',
                          style: buildTheme().textTheme.button,
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, LoginScreen.id),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const TermsConditionsOptions(
                        screenType: 'sign up',
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
