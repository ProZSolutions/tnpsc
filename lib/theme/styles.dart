import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnpsc/theme/colors.dart';
import 'package:tnpsc/theme/fonts.dart';
import 'dart:ui' as prefix;

class Styles {
  static double _textSizLarge = 25.0;
  static double _textSizSmall = 16.0;
  static double _textSizDefault = 16.0;
  static double textSizTwenty = 20.0;
  static double textSizRegular = 15.0;
  static double textSiz = 12.0;
  static double reviewTextSize = 11.0;
  static double packageExpandTextSiz = 12.0;
  static double loginBtnFontSize = 13.0;
  static double packageHeadOpacityLevel = 0.5;
  static double packageSubOpacityLevel = 1.0;
  static double textSizeSmall = 14.0;
  static double textSizeSeventeen = 17.0;
  static String fontMulti = 'Muli';
  static final navBarStyle = TextStyle(fontFamily: fontMulti);

  static final headerLarge = TextStyle(
      fontSize: _textSizLarge,
      color: ColorData.primaryTextColor,
      fontFamily: fontMulti);
  static final headerMedium = TextStyle(
      fontSize: textSizTwenty,
      color: ColorData.primaryTextColor,
      fontFamily: fontMulti);
  static final headerSmall = TextStyle(
      fontSize: _textSizSmall,
      color: ColorData.primaryTextColor,
      fontFamily: fontMulti);
  static final headerLargeWithColor = TextStyle(
      fontSize: FontSizeData.fontLargeSize,
      color: ColorData.blueColor,
      fontFamily: fontMulti);

  static final textDefault =
      TextStyle(fontSize: _textSizDefault, color: ColorData.primaryTextColor);
  static final textDefaultRegular =
      TextStyle(fontSize: _textSizDefault, color: ColorData.primaryTextColor);
  static final textSmall = TextStyle(
      fontSize: textSiz,
      color: ColorData.primaryTextColor,
      fontWeight: FontWeight.w700);
  static final textDefaultWithWhiteColor =
      TextStyle(fontSize: _textSizDefault, color: ColorData.whiteColor);

  static final textDefaultWithGreyColor =
      TextStyle(fontSize: _textSizDefault, color: ColorData.primaryTextColor);

  static final textFacilityHeader = TextStyle(
      fontSize: textSizTwenty,
      color: ColorData.primaryTextColor,
      fontWeight: FontWeight.bold);

  static final textFacilityName = TextStyle(
    fontSize: textSiz,
    color: ColorData.primaryTextColor,
  );
  static final textFacilityNameSelected = TextStyle(
      fontSize: textSiz,
      color: ColorData.primaryTextColor,
      fontWeight: FontWeight.bold);

  static final failureUIStyle = TextStyle(
    fontSize: textSizeSmall,
    color: ColorData.primaryTextColor,
  );
}