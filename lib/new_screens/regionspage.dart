import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/providers/locations_provider.dart';
import 'package:shareride/providers/rides_provider.dart';
import 'package:shareride/screens/search_delegate.dart';
import 'package:shareride/utilities/app_colors.dart';

import '../models/ride.dart';
import 'ridespage.dart';

class RegionsPage extends StatefulWidget {
  const RegionsPage({super.key});

  @override
  State<RegionsPage> createState() => _RegionsPageState();
}

class _RegionsPageState extends State<RegionsPage> {
  Widget _spacing(double height) => SizedBox(height: height,);
  @override
  Widget build(BuildContext context) {
    List<Ride> allRides = context.watch<RidesProvider>().allRides;
    List<String> regions = context.watch<LocationsProvider>().regions.toList(); 
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              _spacing(18.h),
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
                    'All Rides',
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
                  delegate: RidesSearchDelegatebyId(rides: context.read<RidesProvider>().allRides)
                ),
                child: _searchField
              ),
              _spacing(24.h),
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 12.h, left: 12.w, right: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundOpaque.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5.r)
                      ),
                      child: Column(
                        children: List.generate(
                          regions.length, 
                          (index) => _listCard(
                            regionName: regions[index],
                            rideCount: allRides.where(
                              (element) => element.region.toLowerCase() == regions[index].toLowerCase()
                              ).length
                          )
                        ),
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }

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

  Widget _listCard ({required String regionName, required int rideCount})=> GestureDetector(
    onTap: ()=> Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=> RidesPage(regionString: regionName) )
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      margin: EdgeInsets.only(top: 12.h),
      height: 85.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                regionName,
                style: TextStyle(
                  color: const Color.fromRGBO(12, 33, 74, 1),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400
                ),
              ),
              Icon(
                Icons.more_horiz,
                color: AppColors.mainBlue,
              )
            ],
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(83, 130, 218, 0.925),
              borderRadius: BorderRadius.circular(10.r)
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              '$rideCount Rides Available',
              style: TextStyle(
                color: rideCount == 0 ? Colors.grey.shade200 : Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ],
      ),
    ),
  );
  // final _searchController = TextEditingController();
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    super.key
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
  }
}