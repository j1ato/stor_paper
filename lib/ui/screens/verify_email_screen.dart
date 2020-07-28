import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/utils/user_repository.dart';

import '../theme.dart';

// once account is created user is sent an email to account
// user must click on link to prove email is genuine
// the then proceed to homepage

class VerifyEmailScreen extends StatefulWidget {
 const VerifyEmailScreen({
    this.email,
  });
  final String email;
  static String id = 'verify';
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {

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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 80),
                _buildLogo(),
                const SizedBox(
                  height: 40,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  color: Colors.grey.shade800.withOpacity(0.2),
                  child: Center(
                    child: Text(
                      'Resend verification email',
                      style: buildTheme().textTheme.button,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await user.sendVerificationEmail(context).then((result) {
                        if (user.verificationSent) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  child: Text(
                                    'Verification email has been resent!',
                                    style: buildTheme().textTheme.bodyText2,
                                  ),
                                ),
                                actions: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        }
                      });
                    } on Exception catch (e) {
                      print(e);
                    }
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  color: Colors.grey.shade800.withOpacity(0.2),
                  child: Center(
                    child: Text(
                      'Check account verification',
                      style: buildTheme().textTheme.button,
                    ),
                  ),
                  onPressed: () async {
                    
                      await user.checkEmailVerification(context);
                      if (user.status == Status.authenticated) {
                        Navigator.pop(context);
                      }
                    
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
