import 'package:flutter/material.dart';
import 'package:shareride/utilities/app_colors.dart';
import 'package:shareride/utilities/app_text_styles.dart';

class AppSnackBar {
  static SnackBar error (String text)=> SnackBar(
    content: Text(
      text,
      style: AppTextStyle.snackBarError,
    )
  );

  static SnackBar normal (String text)=> SnackBar(
    backgroundColor: AppColors.snakbarBackgroungColor,
    content: Text(
      text,
      style: TextStyle(
        color: AppColors.mainBlue,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter'
      ),
    )
  );
}