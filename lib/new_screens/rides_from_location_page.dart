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
    Size screensize = MediaQuery.of(context).size;
    return Scaffold(
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:16.0.w,
                          vertical: 16.h
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screensize.width/2,
                              child: Text(
                                Casing.titleCase(widget.location),
                                style: TextStyle(
                                  color: const Color.fromRGBO(27, 27, 31, 1),
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            Builder(
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: AppColors.mainBlue,
                                        ),
                                        SizedBox(width: 8.w,),
                                        Text(
                                          'Create New',
                                          style: TextStyle(
                                            color: AppColors.mainBlue,
                                            fontWeight: FontWeight.w600
                                            
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                            )
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () async => await showSearch(
                          context: context,
                          delegate: RidesSearchDelegate(rides: rides)
                        ),
                        child: _searchField),
                      Expanded(child: rides.isEmpty? 
                        Align(
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
                      ListView(
                        children: List.generate(
                          rides.length, 
                          (index) => _listCard(rides[index]),),
                      ))
                      

                    ],
                  ),
                ),
              )
            )
          ],
        )
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
    margin: EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 32.w),
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
      enabled: false,
      controller: _searchController,
      decoration: InputDecoration(
        constraints: BoxConstraints.tight(Size(double.maxFinite, 40.h)),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search by location, time',
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

  Widget _listCard (Ride ride)=> Builder(
    builder: (context) {
      return GestureDetector(
        onTap: ()=> showBottomSheet(
          context: context, 
          builder: (context) => JoinBottomSheet(ride: ride, context: context,)
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 24.w),
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

  final _searchController = TextEditingController();
}

