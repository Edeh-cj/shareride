import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/providers/user_provider.dart';
import 'package:shareride/utilities/app_snackbar.dart';

import '../models/ride.dart';
import '../providers/rides_provider.dart';
import '../utilities/app_colors.dart';
import '../utilities/button1.dart';

class JoinBottomSheet extends StatefulWidget {
  const JoinBottomSheet({
    super.key,
    required this.ride,
    required this.context,
  });

  final Ride ride;
  final BuildContext context;

  @override
  State<JoinBottomSheet> createState() => _JoinBottomSheetState();
}

class _JoinBottomSheetState extends State<JoinBottomSheet> {
  var buttonState = ButtonState.normal;
  toggleButtonState (ButtonState state) {
    setState(() {
      buttonState = state;
    });
  }
  @override
  Widget build(BuildContext context) {
    Ride x = context.watch<RidesProvider>().allRides.where((element) => element.docid == widget.ride.docid,).toList().first;
    return Container(
    height: 400.h,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 2,
          offset: const Offset(0, -2)
        )
      ],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      color: Colors.white
    ),
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Padding(
          padding: EdgeInsets.only(top: 8.0.h, right: 28.0.w, left: 28.w),
          child: SizedBox(
            width: double.maxFinite,
            child: Center(
              child: Icon(
                Icons.drag_handle,
                color: AppColors.mainBlue,
              ),
            ),
          ),
        ),
  
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(          
                  padding: EdgeInsets.only(left: 28.0.w),
                  child: Column(
                    children: [
                      
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Text(
                            'Bus ID',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ), 
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.textBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              x.id,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          )               
                        ],
                      ),
                      SizedBox(height: 16.h,),
                      Row(
                        children: [
                          Text(
                            'From',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ), 
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.textBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              x.from,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          )               
                        ],
                      ),
                      SizedBox(height: 16.h,),
                      Row(
                        children: [
                          Text(
                            'To',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ), 
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.textBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              x.to,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          )               
                        ],
                      ),
                      SizedBox(height: 16.h,),
                      Row(
                        children: [
                          Text(
                            'Creator',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ), 
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.textBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              x.creator,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          )               
                        ],
                      ),
                      SizedBox(height: 16.h,),
                      Row(
                        children: [
                          Text(
                            'Time',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ), 
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.textBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              x.time,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          )               
                        ],
                      ),
          
                      
                    ],
                  ),
                ),
          
                SizedBox(height: 16.h,),
            
                Padding(
                  padding: EdgeInsets.only(
                    left: 44.0.w,
                    right: 44.0.w,
                    top: 0.h
                  ),
                  child: Column(
                    children: [
                      Text(
                        x.remainingPassengersText ,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                            x.participants.length, 
                            (index) => Container(
                              height: 11.h,
                              width: 35.w,
                              decoration: BoxDecoration(
                                color: AppColors.mainBlue,
                                borderRadius: BorderRadius.circular(10)
                              ),
                            )
                          ) + List.generate(
                            7-x.participants.length, 
                            (index) => Container(
                              height: 11.h,
                              width: 35.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(158, 158, 158, 1)
                                ),
                                borderRadius: BorderRadius.circular(10)
                              ),
                            )
                          ),
                      )
                    ],
                  ),
                ),
          
                SizedBox(height: 16.h,),
                
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 32.0.h,
                    left: 32.w,
                    right: 32.w
                  ),
                  child: GestureDetector(
                    onTap: () async{
                      toggleButtonState(ButtonState.loading);
                      await context.read<RidesProvider>().joinRide(              
                        ride: widget.ride, 
                        userid: context.read<UserProvider>().user.uid, 
                        name: context.read<UserProvider>().user.name, 
                        phonenumber: context.read<UserProvider>().user.phonenumber
                      ).then(
                        (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppSnackBar.normal('Joined Bus "${widget.ride.id}" Successfully!')
                          );
                          Navigator.of(context).pop();
                        }
                      ).catchError((e){
                        toggleButtonState(ButtonState.error);
                        ScaffoldMessenger.of(context).showSnackBar(
                          AppSnackBar.error(e.toString())
                        );
                        Future.delayed(const Duration(milliseconds: 1500)).then((value) => toggleButtonState(ButtonState.normal));
                      });
                      
                    },
                    child: AppButton(label: 'Join @ ${x.price}', state: buttonState)),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
  }
}