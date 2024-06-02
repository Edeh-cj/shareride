import 'package:dart_casing/dart_casing.dart';
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
import 'package:shareride/utilities/app_snackbar.dart';
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

  @override
  Widget build(BuildContext context) {
    String uid = context.read<UserProvider>().uid!;
    List<Ride> userRides = context.watch<RidesProvider>().userRides(uid);
    Size screensize = MediaQuery.of(context).size;
    return OrientationBuilder(
      // builder: (BuildContext context, Orientation orientation) {  },
      builder: (context, orientation)=> ScreenUtilInit(
        designSize: orientation == Orientation.portrait? const Size(360, 800) : const Size(800, 300),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              height: orientation == Orientation.portrait? screensize.height : screensize.width,
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: _appbar,
                    ),
                    SizedBox(height: 4.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 12.w),
                      child: profileCard(
                        context.read<UserProvider>().user.name, 
                        context.watch<UserProvider>().user.balance.toString()
                      ),
                    ),
                    SizedBox(height: 8.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.0.w),
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
                                'Create Ride', 
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
                          gridCard(
                            'Top-Up Account', 
                            'assets/topup_icon.png', 
                            Icons.monetization_on,
                            (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context)=> const DepositPage()
                              )
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,                        
                        children: [
                          gridCard(
                            'Customer Support', 
                            'assets/customer_support_icon.png', 
                            Icons.mark_chat_unread_sharp,
                            () async{
                              ScaffoldMessenger.of(context).showSnackBar(
                                AppSnackBar.normal('Switching to WhatsApp')
                              );                              
                              await context.read<WhatsappProvider>().switchtoWhatsapp().catchError(
                                (e){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    AppSnackBar.normal('failed to switch to whatsapp')
                                  );
                                }
                              );
                            }),
                          // gridCard('Log Out', '', Icons.power_settings_new, () => null)
                        ],
                      ),
                    ),
              
                    SizedBox(height: 16.h,),
                    Expanded(
                      child: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(249, 249, 249, 1),
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Your Rides/Tickets',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(27, 27, 31, 1),
                                  ),
                                ),
                              ),
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
                        ),
                      )
                    )
              
                  ],
                ),
              ),
            ),
          ) 
        ),
      ),
    );
  }

  final Widget _appbar = SizedBox(
    height: 80.h,
    width: double.maxFinite,
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Image.asset('assets/shareridelogo.png'),
        )
      ],
    ),
  );

  Widget profileCard(String name, String balance)=> Container(
    padding: EdgeInsets.symmetric(horizontal :12.w, vertical: 12.h),
    margin: const EdgeInsets.symmetric(horizontal: 16),
    // height: 94.h,
    width: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.25),
          offset: const Offset(0, 4),
          blurRadius: 4
          // spreadRadius: 4,
        )
      ],
      gradient:const LinearGradient(
        colors: [
          Color.fromRGBO(12, 33, 74, 1),
          Color.fromRGBO(27, 78, 176, 1)
        ]
      )
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, $name',
          style: TextStyle(
            fontSize: 24.sp,
            // letterSpacing: 1.sp,
            fontWeight: FontWeight.w300,
            color: Colors.white
          ),          
        ),
        SizedBox(height: 4,),
        Text(
          'Balance: NGN $balance',
          style: TextStyle(
            fontSize: 18.sp,
            // letterSpacing: 1.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white
          ),
        )
      ],
    ),
  );

  Widget gridCard (String text, String assetname, IconData icondata, Function() ontap)=> GestureDetector(
    onTap: ontap,
    child: SizedBox(
      width: 75.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 50.w,
            width: 50.w,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(161, 238, 255, 0.5),
              borderRadius: BorderRadius.circular(10)
            ),
            child: SizedBox(
              // child: Image.asset(
              //   assetname,              
              // ),
              child: Icon(
                icondata,
                size: 24,
                color: AppColors.mainBlue,
              ),
            ),
          ),
          SizedBox(height: 9.h,),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
    
              color: Colors.black,             
              fontWeight: FontWeight.w400
            ),
          )
        ],
      ),
    ),
  );

  Widget _listCard(Ride ride)=> GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=> TicketPage(ride: ride)
      )
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 16
      ),
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.h),
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 14,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4  
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'From:  ',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                          ),
                          children: [
                            TextSpan(
                              text: Casing.titleCase(ride.from),
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                              ),
                            )
                          ]
                        )
                      ),
                      const SizedBox(height: 12,),
                      Text.rich(
                        TextSpan(
                          text: 'To:  ',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                          ),
                          children: [
                            TextSpan(
                              text: ride.to,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                              ),
                            )
                          ]
                        )
                      ),
                    ]
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.mainBlue,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    height: 35.h,
                    width: 50.w,
                    alignment: Alignment.center,
                    child: Text(
                      ride.time,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                  child: Icon(
                  Icons.more_horiz,
                  color: AppColors.mainBlue,
                )
              ),
              
            ],
          ),
          const SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              ride.participants.length, 
              (index) => Container(
                height: 18.w,
                width: 18.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.mainBlue
                ),
              )
            ) + List.generate(
              7- ride.participants.length, 
              (index) => Container(
                height: 18.w,
                width: 18.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: const Color.fromRGBO(217, 217, 217, 1))
                ),
              )
            ),
          )
        ],
      ),
    ),
  );

}