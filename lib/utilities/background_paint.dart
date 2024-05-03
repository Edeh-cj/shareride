 import 'package:flutter/material.dart';
import 'package:shareride/utilities/app_colors.dart';

class BackgroundPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    double width = size.width;
    double height = size.height;
    Paint paint = Paint()
    ..style = PaintingStyle.fill
    ..color = AppColors.backgroundPaint;

    Path path = Path()
    ..moveTo(width, 0.4 * height)
    ..quadraticBezierTo(width*0.4, height*0.47, width* 0.21, height* 0.68)
    ..lineTo(0, 0.824*height)
    ..lineTo(0, height)
    ..lineTo(width, height)
    ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
   
 }