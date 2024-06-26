import 'package:dart_casing/dart_casing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/new_screens/join_bottom_sheet.dart';
import 'package:shareride/providers/locations_provider.dart';
import 'package:shareride/providers/rides_provider.dart';
import 'package:shareride/screens/search_delegate.dart';

import '../models/ride.dart';
import '../utilities/app_colors.dart';
import 'create_ride_sheet.dart';

class RidesFromLocationPage extends StatefulWidget {
  const RidesFromLocationPage({super.key, required this.location});
  final String location;

  @override
  State<RidesFromLocationPage> createState() => _RidesFromLocationPageState();
}

class _RidesFromLocationPageState extends State<RidesFromLocationPage> {

  @override
  Widget build(BuildContext context) {
    List<Ride> rides = context.watch<RidesProvider>().allRides.where(
      (element) => element.from.toLowerCase() == widget.location.toLowerCase()
    ).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 18.h, left: 16.w, right: 16.w),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 12.sp,
                      child: Icon(Icons.arrow_back_ios, color: const Color.fromRGBO(27, 27, 31, 1),size: 16.sp,)),
                  ),
                  SizedBox(width: 8.w,),
                  Expanded(
                    child: Text(
                      Casing.titleCase(widget.location),
                      style: TextStyle(
                        color: const Color.fromRGBO(27, 27, 31, 1),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  createButton
                ],
              ),
              _spacing(20.h),        
              GestureDetector(
                onTap: () async => await showSearch(
                  context: context,
                  delegate: RidesSearchDelegate(rides: rides)
                ),
                child: _searchField),
              _spacing(24.h),
              Expanded(
                child: rides.isEmpty? Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No Active Rides Here',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,                              
                      color: AppColors.emptyListText
                    ),
                  ),
                )
                :
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundFaint,
                        borderRadius: BorderRadius.circular(5.r)
                      ),
                      child: Column(
                        children: List.generate(
                          rides.length, 
                          (index) => _listCard(rides[index]),),
                      ),
                    ),
                    _spacing(24.h)
                  ],
                ),
              ))
            ],
          ),
        )
      ),
    );
  }

  Widget _spacing(double height)=> SizedBox(height: height,);

  Widget get createButton => Builder(
    builder: (context) {
      return GestureDetector(
        onTap: () => showBottomSheet(
          backgroundColor: Colors.transparent,
          enableDrag: true,
          context: context, 
          builder: (context)=> CreateRideFormSheet(
            locations: context.read<LocationsProvider>().locations.where(
              (element) => element.name.toLowerCase() == widget.location.toLowerCase()
            ).toList(),
          )
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(230, 238, 254, 1),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: AppColors.mainBlue,
                size: 14.sp,
              ),
              SizedBox(width: 4.w,),
              Text(
                'Create New',
                style: TextStyle(
                  color: AppColors.mainBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp
                  
                ),
              )
            ],
          ),
        ),
      );
    }
  ) ;

  Widget get _searchField => Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
    margin: EdgeInsets.symmetric(horizontal: 4.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: AppColors.backgroundOpaque.withOpacity(0.7),
    ),
    child: Row(
      children: [
        Icon(
          Icons.search_rounded,
          color: Colors.black.withOpacity(0.5),
          size: 20,
        ),
        SizedBox(width: 8.w,),
        Text(
          'Search Rides by location, time...',
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 10.sp,
            fontWeight: FontWeight.w300
          ),
        )
      ],
    )
  );

  Widget _listCard (Ride ride)=> Builder(
    builder: (context) {
      return GestureDetector(
        onTap: ()=> showBottomSheet(
          backgroundColor: Colors.transparent,
          context: context, 
          builder: (context) => JoinBottomSheet(ride: ride, context: context,)
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
                          'From',
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
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      children: [
                        Text(
                          'To',
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
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      children: [
                        Text(
                          'Time',
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
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        ride.participants.length, 
                        (index) => Container(
                          height: 11.h,
                          width: 35.w,
                          decoration: BoxDecoration(
                            color: AppColors.mainBlue,
                            borderRadius: BorderRadius.circular(10)
                          ),
                        )
                      ) + List.generate(
                        7 - ride.participants.length, 
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

