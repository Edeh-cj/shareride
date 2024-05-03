import 'package:flutter/material.dart';
import 'package:shareride/utilities/app_colors.dart';

class AppTextStyle {
  static TextStyle get button2 => const TextStyle(
    fontFamily: 'Spartan',
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 15
  );
  static TextStyle get button1 => const TextStyle(
    fontFamily: 'Spartan',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: Colors.white,
  );
  static TextStyle get appBar => const TextStyle(
    fontFamily: 'Spartan',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: Colors.black
  );
  static TextStyle get authnb => TextStyle(
    fontFamily: 'Spartan',
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.primary
  );
  static TextStyle get cardnb => const TextStyle(
    fontFamily: 'Spartan',
    fontSize: 10,
    fontWeight: FontWeight.w400
  );
  static TextStyle get cardDetail => const TextStyle(
    fontFamily: 'Spartan',
    fontSize: 11,
    fontWeight: FontWeight.w300
  );
  static TextStyle get cardAlert => TextStyle(
    fontFamily: 'Spartan',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.primary

  );
  static TextStyle get cardId => const TextStyle(
    fontFamily: 'Spartan',
    fontSize: 15,
    fontWeight: FontWeight.w500
  );
  static TextStyle get cardTime => const TextStyle(
    fontFamily: 'Spartan',
    fontSize: 15,
    fontWeight: FontWeight.w500
  );
  static TextStyle get formLabel => const TextStyle(
    fontFamily: 'Spartan',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: Colors.black
  );
  static TextStyle get snackBarError => const TextStyle(
    color: Colors.white
  );
}