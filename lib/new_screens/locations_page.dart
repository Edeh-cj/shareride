import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/new_screens/location_search_delegate.dart';
import 'package:shareride/new_screens/rides_from_location_page.dart';
import 'package:shareride/providers/locations_provider.dart';
import 'package:shareride/providers/rides_provider.dart';

import '../models/location.dart';
import '../models/ride.dart';
import '../utilities/app_colors.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  
  @override
  Widget build(BuildContext context) {

    List<Location> locations = context.watch<LocationsProvider>().locations.where(
      (element) => element.isRoute == false).toList();
    List<Ride> rides = context.watch<RidesProvider>().allRides;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 18.h, left: 16.w, right: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(
                    'All Locations',
                    style: TextStyle(
                      color: const Color.fromRGBO(27, 27, 31, 1),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400
                    ),
                  )
                ],
              ),      
              _spacing(24.h),
              GestureDetector(
                onTap: () async => await showSearch(
                  context: context,
                  delegate: LocationSearchDelegate(
                    rides: rides, 
                    locations: locations
                  )
                ),
                child: _searchField
              ),
              _spacing(24.h),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 12.h, left: 12.w, right: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundOpaque.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5.r)
                      ),
                      child: Column(
                        children: List.generate(
                          locations.length, 
                          (index) => _listCard(
                            locations[index], 
                            rides.where(
                              (element) => element.from.toLowerCase() == locations[index].name.toLowerCase()
                            ).toList().length
                          ) 
                        ),
                      ),
                    ),
                    _spacing(24.h)
                  ],
                ),
              )
              
            ],
          ),
        )
      ),
    );
  }

  Widget _spacing(double height) => SizedBox(height: height,);

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
          'Search Rides by id, location, creator...',
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 10.sp,
            fontWeight: FontWeight.w300
          ),
        )
      ],
    )
  );

  Widget _listCard (Location loc, int rideCount)=> GestureDetector(
    onTap: () => Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context)=> RidesFromLocationPage(location: loc.name)
      )
    ),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8.w),
      margin: EdgeInsets.only(top: 8.h,),
      width: double.maxFinite,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: AppColors.textBackground,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  '${loc.name}, ${loc.region}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp
                  ),
                ),
              ),
            )
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.mainBlue
            ),
            child: Text(
              '$rideCount rides',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500
              ),
            ),
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