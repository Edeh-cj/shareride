import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/new_screens/create_ride_sheet.dart';
import 'package:shareride/new_screens/locations_page.dart';
import 'package:shareride/new_screens/regionspage.dart';
import 'package:shareride/new_screens/ticketpage.dart';
import 'package:shareride/providers/rides_provider.dart';
import 'package:shareride/providers/whatsapp_provider.dart';
import 'package:shareride/screens/deposit_page.dart';
import 'package:shareride/utilities/app_colors.dart';
import '../models/ride.dart';
import '../providers/locations_provider.dart';
import '../providers/service_time_provider.dart';
import '../providers/user_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    String uid = context.read<UserProvider>().uid!;
    context.read<UserProvider>().beginStreamAppUser(uid);
    context.read<LocationsProvider>().beginStreamLocations();
    context.read<RidesProvider>().beginStreamAllrides();
    context.read<ServiceTimeProvider>().beginStreamServiceTime();
    context.read<WhatsappProvider>().beginStreamkey();
    // AppConnectionState().initialise(context);
    super.initState();
  }
  _spacing(double height) => SizedBox(height: height,);

  @override
  Widget build(BuildContext context) {
    String uid = context.read<UserProvider>().uid!;
    List<Ride> userRides = context.watch<RidesProvider>().userRides(uid);

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: AppColors.backgroundFaint,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${context.read<UserProvider>().user.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: AppColors.black,                      
                    ),
                  ),
                  _spacing(24.h),
                  profileCard,
                  _spacing(24.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 24.w
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gridCard(
                          'Join Ride', 
                          'assets/join_ride_icon.png',
                          Icons.group_add,
                          ()=> Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context)=> const RegionsPage())
                          )
                        ),
                        Builder(
                          builder: (context) {
                            return gridCard(
                              'Create New Ride', 
                              'assets/create_ride_icon.png',
                              Icons.add_circle_rounded,
                              () => showBottomSheet(
                                backgroundColor: Colors.transparent,
                                enableDrag: true,
                                context: context, 
                                builder: (context)=> CreateRideFormSheet(
                                  locations: context.read<LocationsProvider>().locations
                                )
                              )
                            );
                          }
                        ),
                        gridCard(
                          'Locations', 
                          'assets/find_locations_icon.png', 
                          Icons.location_on_rounded,
                          ()=> Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LocationsPage())
                          )
                        ),
                      ],
                    ),
                  ),
                  _spacing(24.h),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Divider(
                          color: AppColors.divider,
                          thickness: 0.5,
                        )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                        child: Text(
                          'tickets',
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.divider
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Divider(
                          color: AppColors.divider,
                          thickness: 0.5,
                        )),
                    ],
                  ),
                  _spacing(24.h),
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: FractionallySizedBox(
                              widthFactor: 1,
                              heightFactor: 1,
                              child: userRides.isEmpty ? 
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'No Active Tickets',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,                              
                                    color: AppColors.emptyListText
                                  ),
                                ),
                              )
                              : ListView(
                                children: List.generate(
                                  userRides.length, 
                                  (index) => _listCard(userRides[index])
                                )
                              ),
                            )
                          )
                        ],
                      ),
                    )
                  )
                          
                ],
              ),
            ),
          ),
        ) 
      ),
    );
    
  }

  Widget get profileCard=> Container(
    padding: EdgeInsets.symmetric(horizontal :10.w, vertical: 10.h),
    width: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.25),
          offset: const Offset(0, 4),
          blurRadius: 4
        )
      ],
      gradient:const LinearGradient(
        colors: [
          Color.fromRGBO(12, 33, 74, 1),
          Color.fromRGBO(29, 78, 176, 1)
        ]
      )
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Available Balance',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white
          ),          
        ),
        _spacing(14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'N${context.watch<UserProvider>().user.balance.toString()}.00',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DepositPage()
                )
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Text(
                  '+ Add Money',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500
            
                  ),
                ),
              ),
            )
          ],
        )
      ],
    ),
  );

  Widget gridCard (String text, String assetname, IconData icondata, Function() ontap)=> GestureDetector(
    onTap: ontap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(161, 238, 255, 0.5),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Icon(
            icondata,
            size: 20.sp,
            color: const Color.fromRGBO(83, 130, 218, 0.92),
          ),
        ),
        SizedBox(height: 9.h,),
        SizedBox(
          width: 75.w,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.black,             
              fontWeight: FontWeight.w500
            ),
          ),
        )
      ],
    ),
  );

  Widget _listCard (Ride ride)=> Builder(
    builder: (context) {
      return GestureDetector(
        onTap: ()=> Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)=> TicketPage(ride: ride)
          )
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: EdgeInsets.only(top: 8.h),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Coming from',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11.sp,
                            color: Colors.black
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w),
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: AppColors.textBackground,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                            '${ride.from}, ${ride.region}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 11.sp
                            ),
                          ),
                        )
                      ],
                    ),
                    _spacing(8.h),
                    Row(
                      children: [
                        Text(
                          'Going to',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11.sp,
                            color: Colors.black
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w),
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: AppColors.textBackground,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                            ride.to,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 11.sp
                            ),
                          ),
                        )
                      ],
                    ),
                    _spacing(8.h),
                    Row(
                      children: [
                        Text(
                          'Schedule',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11.sp,
                            color: Colors.black
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w),
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: AppColors.textBackground,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                            ride.time,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 11.sp
                            ),
                          ),
                        )
                      ],
                    ),
                    _spacing(8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        ride.participants.length, 
                        (index) => Container(
                          height: 10.h,
                          width: 35.w,
                          decoration: BoxDecoration(
                            color: AppColors.mainBlue,
                            borderRadius: BorderRadius.circular(10)
                          ),
                        )
                      ) + List.generate(
                        7 - ride.participants.length, 
                        (index) => Container(
                          height: 10.h,
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
                )
              ),
              Icon(
                Icons.more_horiz,
                color: AppColors.mainBlue,
              )
            ],
          ),
        ),
      );
    }
  );


}