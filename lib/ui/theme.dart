import 'package:flutter/material.dart';

// theme for components within the app

ThemeData buildTheme() {
  final ThemeData base = ThemeData();

  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
          fontFamily: 'Notable',
          fontSize: 55,
          color: const Color(0xF042444F),
          fontWeight: FontWeight.bold),
      headline2: base.headline2.copyWith(
          fontFamily: 'Notable',
          fontSize: 22,
          color: Color(0xF042444F),
          fontWeight: FontWeight.bold),
      subtitle1: base.subtitle1.copyWith(
          fontFamily: 'OpenSans',
          fontSize: 17,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.bold),
      bodyText1: base.bodyText1.copyWith(
        fontFamily: 'OpenSans',
        fontSize: 16,
        color: Colors.white.withOpacity(0.8),
      ),
      bodyText2: base.bodyText2.copyWith(
          fontFamily: 'OpenSans',
          fontSize: 12,
          color: Colors.white.withOpacity(0.8),
          textBaseline: TextBaseline.ideographic),
      caption: base.caption.copyWith(
        fontFamily: 'OpenSans',
        fontSize: 12,
        color: Colors.white.withOpacity(0.8),
      ),
      button: base.button.copyWith(
        fontFamily: 'OpenSans',
        fontSize: 15,
        color: Colors.white.withOpacity(0.8),
        fontWeight: FontWeight.w800,
      ),
    );
  }

  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    appBarTheme: AppBarTheme(
      color: Colors.grey,
      elevation: 0,
    ),
    dialogBackgroundColor: const Color(0xF0111114).withOpacity(0.8),
    bottomAppBarColor: const Color(0xF0D7D9E1),
    scaffoldBackgroundColor:
        // Color(0xF042444F)
        const Color(0xF0DADBDF),
    buttonColor: const Color(0xF0111114).withOpacity(0.03),
    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xF0111114),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
      size: 20,
    ),
  );
}
