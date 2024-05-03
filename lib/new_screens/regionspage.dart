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
  @override
  Widget build(BuildContext context) {
    List<Ride> allRides = context.watch<RidesProvider>().allRides;
    List<String> regions = context.watch<LocationsProvider>().regions.toList(); 
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const  _AppBar(),
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
                        padding: EdgeInsets.only(left: 16.0.w, top: 16.h, bottom: 16.h),
                        child: Text(
                          'All Rides',
                          style: TextStyle(
                            color: const Color.fromRGBO(27, 27, 31, 1),
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () async => await showSearch(
                          context: context,
                          delegate: RidesSearchDelegatebyId(rides: context.read<RidesProvider>().allRides)
                        ),
                        child: _searchField),
                      Expanded(
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: ListView(
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
    );
  }

  Widget get _searchField => Container(
    margin: EdgeInsets.symmetric(horizontal: 32.w),
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
        hintText: 'Search Rides by id, location, creator...',
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

  Widget _listCard ({required String regionName, required int rideCount})=> GestureDetector(
    onTap: ()=> Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=> RidesPage(regionString: regionName) )
    ),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      margin: EdgeInsets.only(top: 20.h, bottom: 4.h, left: 24.w, right: 24.w),
      height: 100.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12.0.w),
                child: Text(
                  regionName,
                  style: const TextStyle(
                    color: Color.fromRGBO(12, 33, 74, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w400
                  ),
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
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.mainBlue,
              borderRadius: BorderRadius.circular(10)
            ),
            height: 36.h,
            alignment: Alignment.centerRight,
            child: Text(
              '$rideCount Rides Available',
              style: TextStyle(
                color: rideCount == 0 ? Colors.grey.shade200 : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ],
      ),
    ),
  );
  final _searchController = TextEditingController();
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