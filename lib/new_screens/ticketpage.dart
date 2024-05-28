import 'package:dart_casing/dart_casing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/new_screens/alt_button.dart';
import 'package:shareride/providers/rides_provider.dart';
import 'package:shareride/utilities/app_colors.dart';

import '../models/ride.dart';
import '../providers/service_time_provider.dart';
import '../providers/user_provider.dart';
import '../utilities/app_snackbar.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key, required this.ride});
  final Ride ride;

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  var buttonState = ButtonState.normal;
  toggleButtonState(ButtonState state){
    setState(() {
      buttonState = state;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    Ride ride = context.watch<RidesProvider>().allRides.where(
      (element) => element.docid == widget.ride.docid).toList().first;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _appbar,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, -4.h),
                      blurRadius: 4.h
                    )
                  ]
                ),
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(left: 16.0.w, top: 20.h, ),
                      //   child: Text(
                      //     'Your Ticket',
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 17.sp,
                      //       fontWeight: FontWeight.w500
                      //     ),
                      //   ),
                      // ), 
                      // SizedBox(height: 60.h,),
                      _fromTo(
                        from: Casing.titleCase(ride.from),
                        to: ride.to
                      ),
                      // SizedBox(height: 64.h,),
                      _timeID,
                      // SizedBox(height: 64.h,),
                      _passengerBar,
                      // SizedBox(height: 64.h,),
                      GestureDetector(
                        onTap: () {
                          cancelRideFunction(ride);
                        },
                        child: AltButton(state: buttonState, isLocked: ride.isLocked)
                      ),
                      // SizedBox(height: 64.h,)
                                  
                    ],
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
  Widget get _appbar => SizedBox(
    height: 80.h,
    width: double.maxFinite,
    child: Row(
      children: [
        IconButton(
          onPressed: ()=> Navigator.pop(context), 
          icon: Icon(
            Icons.arrow_back,
            size:  24.sp,
            color: Colors.black,
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Image.asset('assets/shareridelogo.png'),
        )
      ],
    ),
  );

  Widget _fromTo ({required String from, required String to})=> Padding(
    padding: EdgeInsets.only(left: 16.w, right: 16.w),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(161, 161, 161, 1)
                ),
              ),
              Text(
                from,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter'
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 16.h,),
        const Divider(
          thickness: 1,
          color: Color.fromRGBO(210, 210, 210, 1),
        ),
        SizedBox(height: 16.h,),
        SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  // letterSpacing: 1.sp,
                  color: const Color.fromRGBO(161, 161, 161, 1)
                ),
              ),
              Text(
                to,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.sp,
                  // letterSpacing: 1.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter'
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );

  Widget get _timeID => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Time',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                // letterSpacing: 1.sp,
                color: const Color.fromRGBO(161, 161, 161, 1)
              ),
            ),
            const SizedBox(height: 4,),
            Text(
              context.read<ServiceTimeProvider>().getServiceTime(widget.ride.time.toLowerCase()),
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.sp,
                // letterSpacing: 1.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter'
              ),
            ),
  
            Text(
              '${DateTime.now().day} ${monthString(DateTime.now().month)}, ${DateTime.now().year}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: const Color.fromRGBO(160, 160, 160, 1)
              ),
            )
  
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bus ID',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(161, 161, 161, 1)
              ),
            ),
            const SizedBox(height: 4,),
            Text(
              widget.ride.id,
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter'
              ),
            ),
  
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Ticket ID',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(161, 161, 161, 1)
              ),
            ),
            const SizedBox(height: 4,),
            Text(
              context.read<UserProvider>().user.uid.characters.take(5).toString().toUpperCase(),
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter'
              ),
            ),
  
          ],
        )
      ],
    ),
  );

  Widget get _passengerBar {
    Ride ride = context.watch<RidesProvider>().allRides.where(
      (element) => element.docid == widget.ride.docid
    ).toList().first;
    return SizedBox(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              ride.participants.length, 
              (index) => Container(
                height: 30.w,
                width: 30.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.mainBlue
                ),
              )
            ) + List.generate(
              7- ride.participants.length, 
              (index) => Container(
                height: 30.w,
                width: 30.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(217, 217, 217, 1)
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              )
            ),
          ),
          const SizedBox(height: 6,),
          Text(
            ride.remainingPassengersText,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(77, 77, 77, 1)
            ),
          ),          
  
        ]
      ),
    ),
  );
  }

  cancelRideFunction(Ride ride,) async{
    if (buttonState != ButtonState.loading && !ride.isLocked) {
      toggleButtonState(ButtonState.loading);
        await context.read<RidesProvider>().cancelRide(
          ride: ride, 
          userid: context.read<UserProvider>().user.uid
        ).then((value) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar.normal('Your Ticket to Ride "${ride.id}" cancelled successfully!')
          );        
        }        
        ).catchError((e){
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar.error(e)
          );
          toggleButtonState(ButtonState.error);
          Future.delayed(const Duration(milliseconds: 1500)).then((value) => toggleButtonState(ButtonState.normal));
        }
      );
    }
  }

  monthString(int val)=> switch (val) {
    1 => 'January',
    2 => 'Febuary',
    3 => 'March',
    4 => 'April',
    5 => 'May',
    6 => 'June',
    7 => 'July',
    8 => 'August',
    9 => 'September',
    10 => 'October',
    11 => 'November',
    12 => 'December',
    // TODO: Handle this case.
    int() => null,
  };
}
