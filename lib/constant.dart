import 'package:flutter/material.dart';
import 'package:smart_home/config/size_config.dart';
import 'package:smart_home/main.dart';

const kTextColor = Color(0xFF757575);
const kSecondaryColor = Color(0xFF0E65AC);
const String kotp = "incorrect PIN code";
MediaQueryData _mediaQueryData = MediaQuery.of(
  navigationKey.currentContext!,
);
final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(
    vertical: (15 / 270) * _mediaQueryData.size.width,
  ),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);
OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius:
        BorderRadius.circular((15 / 270) * _mediaQueryData.size.width),
    borderSide: BorderSide(color: kTextColor),
  );
}
