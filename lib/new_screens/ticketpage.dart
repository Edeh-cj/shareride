import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// import 'package:shareride/new_screens/alt_button.dart';
import 'package:shareride/providers/rides_provider.dart';
import 'package:shareride/utilities/app_colors.dart';
import 'package:shareride/utilities/button1.dart';

import '../models/ride.dart';
import '../providers/service_time_provider.dart';
import '../providers/user_provider.dart';
import '../utilities/app_snackbar.dart';
import '../utilities/app_text_styles.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key, required this.ride});
  final Ride ride;

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  ButtonState buttonState = ButtonState.normal;
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
      backgroundColor: AppColors.backgroundOpaque,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.maxFinite,),
            _spacing(24.h),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0.w),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 12.sp,
                      child: Icon(Icons.arrow_back_ios, color: const Color.fromRGBO(27, 27, 31, 1),size: 16.sp,)),
                  ),
                ),
              ],
            ),
            
            InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(0),
              maxScale: 1.5,
              minScale: 1.0,
              scaleEnabled: true,
              panEnabled: true,

              child: Column(
                children: [
                  const SizedBox(width: double.maxFinite,),
                  _spacing(24.h),
                  _ticketWrap(),
                  _spacing(32.h),
                ],
              )
            ),
              
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: ride.isLocked? 
              _lockededButton : 
              GestureDetector(
                onTap: ()=> cancelRideFunction(ride),
                child: AppButton(label: 'Cancel Ticket', state: buttonState, height: 40.h,)),
            )
              
          ],
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

  Widget _spacing(double height) => SizedBox(height: height,);

  Widget get _circleStuff => Container(
    height: 12,
    width: 10,
    decoration: BoxDecoration(
      color: AppColors.backgroundOpaque,
      borderRadius: BorderRadius.circular(10)
    ),
    // child: ,
  );

  Widget get _ticketTop => SizedBox(
    width: double.maxFinite,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(19, (index) => _circleStuff),
    ),
  );

  Widget get _ticketBody {
    Ride ride = context.watch<RidesProvider>().allRides.where(
      (element) => element.docid == widget.ride.docid).toList().first;
    return Container(
      width: double.maxFinite,
      // height: 371,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.square(
                dimension: 40,
                child: Image.asset('assets/shareridelogo.png')
              ),
              const Text(
                'Bus Pass',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w300
                ),
              )
            ],
          ),
          _spacing(12),
          _busProgress(7-ride.participants.length, ride.remainingPassengersText),
          _spacing(12),
          _ticketDetails(ride)
    
        ],
      ),
    );
  }

  Widget _ticketDetails (Ride ride)=> Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          CustomPaint(
            painter: DashedLine(),
            child: const SizedBox(
              height: 1,
              width: double.maxFinite,
            ),
          ),
          _spacing(12),
          _detailText('Coming from', '${ride.from}, ${ride.region}'),
          _spacing(12),
          _detailText('Going to', ride.to),
          _spacing(12),
          _detailText('Bus id', ride.id),
          _spacing(12),
          _detailText('Ticket id', context.read<UserProvider>().user.uid.characters.take(5).toString().toUpperCase()),
          _spacing(12),
          _detailText('Time/Schedule', context.read<ServiceTimeProvider>().getTimeFormat(ride.time.toLowerCase()),),
          _spacing(12),
          _spacing(50),
          _spacing(12),
          CustomPaint(
            painter: DashedLine(),
            child: const SizedBox(
              height: 1,
              width: double.maxFinite,
            ),
          ),
          _spacing(12),
          ticketNb(context.read<ServiceTimeProvider>().getTimeFormat(ride.time.toLowerCase()))

        ],
      ),
    ),
  );

  Widget ticketNb(String serviceTime)=> Text(
    "NB: Bus arrives $serviceTime, leaves 10mins later without delay. Incomplete Bus rides would be cancelled and fully refunded. Bus passes lock 30mins to the scheduled time if Bus is up to specified minimum number of commuters before time, tickets won't be refunded in that case.",
    overflow: TextOverflow.clip,
    style: const TextStyle(
      fontSize: 10,
      fontFamily: 'Roboto',
      color: Color.fromRGBO(0, 0, 0, 0.5),
      fontWeight: FontWeight.w400
    ),
  );

  Widget _detailText(String title, String data)=> Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(0, 0, 0, 0.7)
        ),
      ),
      Text(
        data,
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(0, 0, 0, 1)
        ),
      )
    ],
  );

  Widget get _circularIndicatorFilled => CircleAvatar(
    radius: 5,
    backgroundColor: AppColors.mainBlue,
  );

  Widget get _circularIndicatorOutlined => Container(
    height: 10,
    width: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(        
        color: const Color.fromRGBO(217, 217, 217, 1)
      )
    ),
  );

  Widget _busProgress(int remainingPassengers, String text) => SizedBox(
    height: 30,
    width: 118,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: AppColors.mainBlue,
            fontSize: 10
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7-remainingPassengers, (index) => _circularIndicatorFilled)+ List.generate(remainingPassengers, (index) => _circularIndicatorOutlined),
        )
      ],
    ),
  );

  Widget _ticketWrap() => SizedBox(
    width: 282,
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:6.0),
          child: _ticketBody,
        ),
        _ticketTop
      ]
    ),
  );

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
  
  Widget get _lockededButton => Container(
    margin: EdgeInsets.only(top: 15),
    height: 40.h,
    width: double.maxFinite,
    decoration: BoxDecoration(
      color: AppColors.mainBlue.withOpacity(0.2),
      borderRadius: BorderRadius.circular(5)
    ),
    child: Center(
      child: Text(
        'Cancel Ticket (Locked)',
        style: AppTextStyle.button1,
      ),
    ),
  );
}

class DashedLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    List<Offset> offsets = [];
    int step = 3;
    for (var i = 0; i < size.width; i=i+step) {
      offsets.add(Offset(i.toDouble(), 0));
    }
    canvas.drawPoints(
      PointMode.lines,
      offsets, 
      Paint()
      ..strokeWidth = 0.5
      ..color = const Color.fromRGBO(158, 158, 158, 0.5)
      
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
  
}
