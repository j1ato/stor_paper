import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stor_paper/ui/theme.dart';

// terms and conditions text that changes slightly
// depending on the screen

class TermsConditionsOptions extends StatelessWidget {
  const TermsConditionsOptions({@required this.screenType});

  final String screenType;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: screenType == 'sign up'
              ? 'By signing up you agree to our '
              : 'By signing in you agree to our ',
          style: buildTheme().textTheme.button,
          children: [
            TextSpan(
              text: 'terms of use',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = () => print('tapped'),
            ),
            const TextSpan(text: ' &'),
            TextSpan(
              text: ' privacy policy.',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = () => print('tapped'),
            )
          ]),
    );
  }
}
