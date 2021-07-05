import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:stor_paper/ui/widgets/popup_dialogs/error_alert_dialogs.dart';

// contains all code relevant to user log in and sign up
// extends change notifier to allow for usage with provider package
// which helps switch between login and home screens

enum Status { authenticated, authenticating, unauthenticated }

class UserRepository extends ChangeNotifier {
  UserRepository() : super();

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    getCurrentUser();
  }

  Status _status = Status.unauthenticated;
  FirebaseAuth _auth;
  User? _user;
  FacebookLogin? _login;
  GoogleSignIn _googleSignIn;
  AuthCredential _authCredential;
  FacebookAccessToken _fBookAccessToken;
  String errorMessage;
  bool _signUpError = false;
  bool _verificationSent = true;
  bool _passwordResetError;
  bool _isConnected;

  Status get status => _status;
  User? get user => _user;
  bool get signUpError => _signUpError;
  bool get isConnected => _isConnected;
  bool get verificationSent => _verificationSent;

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      _isConnected = true;
      notifyListeners();
    } else if (connectivityResult == ConnectivityResult.none) {
      _isConnected = false;
      notifyListeners();
    }
  }

  Future getCurrentUser() async {
    try {
      await _auth.currentUser().then((user) {
        if (user != null) {
          _user = user;
          _status = Status.authenticated;
          notifyListeners();
        } else {
          print('no user');
        }
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> sendVerificationEmail(BuildContext context) async {
    _user = await _auth
        .currentUser()
        .catchError((onError) => print('this is the error: ${onError.code}'));
    if (_user != null) {
      await _user.sendEmailVerification().then((onValue) {
        _verificationSent = true;
      }).catchError((onError) {
        _verificationSent = false;
        errorMessage = 'Something went wrong, try again later';
        showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(errorMessage: errorMessage);
          },
        );
      });
    } else {
      print('User is null');
    }
  }

  Future sendPasswordReset(String email, BuildContext context) async {
    if (email != null) {
      _passwordResetError = false;
      await _auth.sendPasswordResetEmail(email: email).catchError((onError) {
        _passwordResetError = true;
        switch (onError.code) {
          case 'ERROR_INVALID_EMAIL':
            errorMessage = 'The email you have entered is invalid';
            showDialog(
                context: context,
                builder: (context) {
                  return ErrorAlertDialog(errorMessage: errorMessage);
                });
            break;

          case 'ERROR_USER_NOT_FOUND':
            errorMessage = 'This account does not exist';
            showDialog(
                context: context,
                builder: (context) {
                  return ErrorAlertDialog(errorMessage: errorMessage);
                });
            break;
          default:
            errorMessage = '';
        }
      });
      if (_passwordResetError != true) {
        errorMessage = 'A password reset email has been sent';
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(errorMessage: errorMessage);
            });
      }
    } else {
      errorMessage = 'Please enter your email';
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(errorMessage: errorMessage);
          });
    }
  }

  Future signIn(
    String email,
    String password,
    FormState formKeyState,
    BuildContext context,
  ) async {
    if (formKeyState.validate()) {
      formKeyState.save();
      _status = Status.authenticating;
      notifyListeners();
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        _user = user;
        await checkEmailVerification(context);
        if (_user != null && _user.isEmailVerified) {
          await createFavorites();

          _status = Status.authenticated;
          notifyListeners();
        } else {
          print('error');
        }
      }).catchError(
        (onError) {
          _status = Status.unauthenticated;
          notifyListeners();
          print('this is the error:$onError');
          switch (onError.code) {
            case 'ERROR_INVALID_EMAIL':
              errorMessage =
                  'The email or password you have entered is invalid';
              showDialog(
                  context: context,
                  builder: (context) {
                    return ErrorAlertDialog(errorMessage: errorMessage);
                  });
              break;

            case 'ERROR_USER_NOT_FOUND':
              errorMessage = 'This account does not exist';
              showDialog(
                  context: context,
                  builder: (context) {
                    return ErrorAlertDialog(errorMessage: errorMessage);
                  });
              break;
            case 'ERROR_WRONG_PASSWORD':
              errorMessage = 'The password you entered is incorrect';
              showDialog(
                  context: context,
                  builder: (context) {
                    return ErrorAlertDialog(errorMessage: errorMessage);
                  });
              break;
            default:
              errorMessage = '';
          }
        },
      );
    } else {
      print('failed');
    }
  }

  Future<void> registerNewUser(
    String email,
    String password,
    FormState formKeyState,
    BuildContext context,
  ) async {
    if (formKeyState.validate()) {
      formKeyState.save();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        _user = user;
        _signUpError = false;
        user.sendEmailVerification();
      }).catchError((onError) {
        _signUpError = true;
        print('this is the error: $onError');
        switch (onError.code) {
          case 'ERROR_INVALID_EMAIL':
            errorMessage = 'Please enter a valid email';
            showDialog(
                context: context,
                builder: (context) {
                  return ErrorAlertDialog(errorMessage: errorMessage);
                });
            break;

          case 'ERROR_EMAIL_ALREADY_IN_USE':
            errorMessage = 'This email is already in use';
            showDialog(
                context: context,
                builder: (context) {
                  return ErrorAlertDialog(errorMessage: errorMessage);
                });
            break;

          case 'ERROR_WEAK_PASSWORD':
            errorMessage = 'Your password must be 6 characters long or more';
            showDialog(
                context: context,
                builder: (context) {
                  return ErrorAlertDialog(errorMessage: errorMessage);
                });
            break;
          default:
            errorMessage = '';
        }
      });
    }
  }

  Future<bool> signInWithFacebook() async {
    _login = FacebookLogin();
    try {
      _status = Status.authenticating;
      notifyListeners();
      final result = await _login.logInWithReadPermissions(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          _fBookAccessToken = result.accessToken;
          _authCredential = FacebookAuthProvider.getCredential(
              accessToken: _fBookAccessToken.token);
          _user = await _auth.signInWithCredential(_authCredential);

          if (_user != null) {
            await createFavorites();
            _status = Status.authenticated;
            notifyListeners();
          }

          break;
        case FacebookLoginStatus.cancelledByUser:
          _status = Status.unauthenticated;
          notifyListeners();
          break;
        case FacebookLoginStatus.error:
          _status = Status.unauthenticated;
          notifyListeners();
          break;
      }
      return true;
    } on Exception catch (e) {
      print(e);
      _status = Status.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _googleSignIn = GoogleSignIn();
    try {
      _status = Status.authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      _authCredential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      _user = await _auth.signInWithCredential(_authCredential);

      assert(!_user.isAnonymous);
      assert(await _user.getIdToken() != null);

      _user = await _auth.currentUser();

      if (_user != null) {
        await createFavorites();
        _status = Status.authenticated;
        print('this is the users email on sign up: ${_user.email}');
        notifyListeners();
      }
      return true;
    } on Exception catch (e) {
      print(e);
      _status = Status.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> checkEmailVerification(BuildContext context) async {
    _status = Status.authenticating;
    notifyListeners();
    _user =
        await _auth.currentUser();
    .catchError((onError) => print(onError.code));
    await _user.reload().catchError((onError) => print(onError.code));
    _user =
        await _auth.currentUser().catchError((onError) => print(onError.code));
    if (_user.isEmailVerified) {
      await createFavorites();
      _status = Status.authenticated;
      notifyListeners();
    } else {
      errorMessage = 'Your account has not been verified';
      return showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(errorMessage: errorMessage);
        },
      );
    }
  }

  Future<void> signOut() async {
    print(_user.email);
    await _auth.signOut();
    await _googleSignIn.signOut();
    // await _login.logOut();
    if (_user == null) {
      print('no user on sign out');
      _status = Status.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      _user = firebaseUser;
    }
    notifyListeners();
  }

  Future<void> createFavorites() async {
    if (_user != null) {
      final DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .get();

      if (!querySnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .set({'favorites': []});
      }
    } else {
      return print(
          'Something is wrong with accessing the user from '
              'the create favorites method in the user repository');
    }
  }
}
