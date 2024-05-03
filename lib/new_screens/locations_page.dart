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

    return OrientationBuilder(
      
      builder: (context, orientation) =>  ScreenUtilInit(
        designSize: orientation == Orientation.portrait? const Size(360, 800) : const Size(800, 300),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _appbar,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16.0.w, top: 16.h, bottom: 16.h),
                                child: Text(
                                  'All Locations',
                                  style: TextStyle(
                                    color: const Color.fromRGBO(27, 27, 31, 1),
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ],
                          ),
          
                          GestureDetector(
                            onTap: () async => await showSearch(
                              context: context,
                              delegate: LocationSearchDelegate(
                                rides: rides, 
                                locations: locations
                              )
                            ),
                            child: _searchField),
                          Expanded(
                            child: ListView(
                              children: List.generate(
                                locations.length, 
                                (index) => _listCard(
                                  locations[index], 
                                  rides.where(
                                    (element) => element.from.toLowerCase() == locations[index].name.toLowerCase()
                                  ).toList().length
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
            )
          ),
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
  Widget get _searchField => Container(
    margin: EdgeInsets.only(
      bottom: 10,
      left: 32.w,
      right: 32.w
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 4,
          color: Colors.black.withOpacity(0.1)
        )
      ]
    ),
    child: TextField(
      controller: _searchController,
      enabled: false,
      decoration: InputDecoration(
        constraints: BoxConstraints.tight(Size(double.maxFinite, 40.h)),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search by name',
        hintStyle: TextStyle(
          fontSize: 10.sp,
          color: const Color.fromRGBO(124, 124, 124, 1)
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Color.fromRGBO(124, 124, 124, 1)
        ),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none
        ),
      ),
    ),
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
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 24.w),
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
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
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

  final _searchController = TextEditingController();
}