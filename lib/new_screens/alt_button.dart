import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shareride/utilities/app_colors.dart';

enum ButtonState {inactive, loading, error, success, normal}

class AltButton extends StatelessWidget {
  const AltButton({
    super.key, required this.state, required this.isLocked,
  });

  final ButtonState state;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return switch(state){
      ButtonState.loading => loading,
      ButtonState.error => error,
      ButtonState.success => normal,
      ButtonState.normal => normal,
      ButtonState.inactive => normal
    };
  }
  Widget get normal => Container(
    margin: EdgeInsets.only(
      left: 16.w,
      right: 16.w,
    ),
    height: 35.h,
    width: double.maxFinite,
    decoration: BoxDecoration(
      color: isLocked? const Color.fromRGBO(161, 238, 255, 0.2): const Color.fromRGBO(161, 238, 255, 1),
      borderRadius: BorderRadius.circular(50)
    ),
    alignment: Alignment.center,
    child: isLocked? 
    Icon(
      Icons.lock,
      color: AppColors.mainBlue,
    )
    :Text(
      'Cancel Ticket',
      style: TextStyle(
        color: AppColors.mainBlue,
        fontSize: 14.sp,
        fontFamily: 'Inter'

      ),
    ),
  );

  Widget get loading => Container(
    margin: EdgeInsets.only(
      left: 16.w,
      right: 16.w,
    ),
    height: 35.h,
    width: double.maxFinite,
    decoration: BoxDecoration(
      color: const Color.fromRGBO(161, 238, 255, 1),
      borderRadius: BorderRadius.circular(50)
    ),
    alignment: Alignment.center,
    child: SizedBox(
      height: 30,
      width: 30,
      child: CircularProgressIndicator(
        color: AppColors.mainBlue,
      ),
    )
  );
  
  Widget get error => Container(
    margin: EdgeInsets.only(
      left: 16.w,
      right: 16.w,
    ),
    height: 35.h,
    width: double.maxFinite,
    decoration: BoxDecoration(
      color: AppColors.backgroundGrey,
      borderRadius: BorderRadius.circular(50)
    ),
    alignment: Alignment.center,
    child: const Icon(
      Icons.error,
      color: Colors.white,
    )
  );
}
