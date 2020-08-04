import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/ui/screens/signup_login/verify_email_screen.dart';
import 'package:stor_paper/ui/widgets/popup_dialogs/flushbars.dart';
import 'package:stor_paper/ui/widgets/authentication/text_form_field.dart';
import 'package:stor_paper/providers/user_repository.dart';

import '../../theme.dart';

// registers new users and allows them to create account.

class RegisterScreen extends StatefulWidget {
  static String id = 'register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email;
  String _password;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    Text _buildLogo() {
      return Text('Sign up', style: buildTheme().textTheme.headline1,);
          }


    //could add container here to help with adding padding

    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 80),
                        Center(child: _buildLogo()),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomTextField(
                    validator: (input) =>
                        input.isEmpty ? '*Please enter your email' : null,
                    onChanged: (input) {
                      _email = input;
                      print(_email);
                    },
                    hint: 'Email',
                    controller: _emailController,
                    // validator: emailValidator,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    obscure: true,
                    onChanged: (input) {
                      _password = input;
                      print(_password);
                    },
                    hint: 'Password',
                    validator: (input) =>
                        input.isEmpty ? '*Please enter your password' : null,
                    controller: _passwordController,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    color: Colors.grey.shade800.withOpacity(0.2),
                    child: Text(
                      'Create account',
                      style: buildTheme().textTheme.button,
                    ),
                    onPressed: () async {
                      try {
                        await user.checkConnectivity();
                        if (user.isConnected == true) {
                          await user
                              .registerNewUser(_email, _password,
                                  _formKey.currentState, context)
                              .then((onValue) {
                            if (user.signUpError == false &&
                                _email != null &&
                                _password != null) {
                              Navigator.pushReplacementNamed(
                                  context, VerifyEmailScreen.id);
                            }
                          });
                        } else {
                          Flushbars().connetivityFlushbar(context);
                        }
                      } on Exception catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
