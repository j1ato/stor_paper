import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:stor_paper/ui/widgets/flushbars.dart';
import 'package:stor_paper/ui/widgets/terms_privacy_button.dart';
import 'package:stor_paper/utils/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/ui/widgets/text_form_field.dart';

// login page that allows login only if user already has an account
// also allows pass word reset email to be sent

class LoginScreen extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  String _email;
  String _password;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 40),
                        _buildLogo(),
                        const SizedBox(
                          height: 30,
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
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          obscure: true,
                          onChanged: (input) {
                            _password = input;
                          },
                          hint: 'Password',
                          validator: (input) => input.isEmpty
                              ? '*Please enter your password'
                              : null,
                          controller: _passwordController,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          color: Colors.grey.shade800.withOpacity(0.2),
                          child: Text(
                            'Login',
                            style: buildTheme().textTheme.button,
                          ),
                          onPressed: () async {
                            try {
                              await user.checkConnectivity();
                              if (user.isConnected == true) {
                                await user.signIn(_email, _password,
                                    _formKey.currentState, context);
                                if (user.status == Status.authenticated) {
                                  Navigator.pop(context);
                                }
                              } else {
                                Flushbars()
                                    .connetivityFlushbar(context);
                              }
                            } on Exception catch (e) {
                              print(e);
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            'Forgot Password?',
                            style: buildTheme().textTheme.button,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Container(
                                    child: Text(
                                      'Reset Password?',
                                      style: buildTheme().textTheme.body2,
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
                                        await user.sendPasswordReset(
                                            _email, context);
                                        Navigator.pop(context);
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
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const TermsConditionsOptions(
                          screenType: 'login',
                        )
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
