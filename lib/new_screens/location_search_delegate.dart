import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../models/ride.dart';
import '../providers/rides_provider.dart';
import '../utilities/app_colors.dart';
import '../utilities/button1.dart';

class LocationSearchDelegate extends SearchDelegate {

  final List<Location> locations;
  final List<Ride> rides ;

  LocationSearchDelegate({required this.rides, super.searchFieldLabel, super.searchFieldStyle, super.searchFieldDecorationTheme, super.keyboardType, super.textInputAction, required this.locations,});
   @override
  String? get searchFieldLabel => 'Search by location, time';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
    fontSize: 12
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: ()=> query ='', 
        icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      }, 
      icon: Icon(
        Icons.arrow_back,
        color: AppColors.primary,
      )
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    List<Location> list = locations.where(
      (e) => 
      e.name.toLowerCase().contains(query.toLowerCase())
     || e.region.toLowerCase().contains(query.toLowerCase())    
    ).toList();

     return ListView(
      children: <Widget>[SizedBox(height: 12.h,)] + List.generate(
        list.length, 
        (index) => _listCard(
          list[index], 
          rides.where(
            (element) => element.from.toLowerCase() == locations[index].name.toLowerCase()
          ).toList().length
        )
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Location> list = locations.where(
      (e) => 
      e.name.toLowerCase().contains(query.toLowerCase())
     || e.region.toLowerCase().contains(query.toLowerCase())    
    ).toList();

     return ListView(
      children: <Widget>[SizedBox(height: 12.h,)] + List.generate(
        list.length, 
        (index) => _listCard(
          list[index], 
          rides.where(
            (element) => element.from.toLowerCase() == locations[index].name.toLowerCase()
          ).toList().length
        )
      ),
    );
  }

  Widget _listCard (Location loc, int rideCount)=> Container(
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
  );

  Widget joinbottomSheet(Ride ride, BuildContext context) {
    Ride x = context.watch<RidesProvider>().allRides.where((element) => element.docid == ride.docid,).toList().first;
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, -2)
          )
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: Colors.white
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
    
          Padding(          
            padding: EdgeInsets.only(left: 28.0.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 28.0.w),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Center(
                      child: Icon(
                        Icons.drag_handle,
                        color: AppColors.mainBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Text(
                      'Bus ID',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ), 
                    Container(
                      margin: EdgeInsets.only(left: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.textBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        x.id,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    )               
                  ],
                ),
                SizedBox(height: 16.h,),
                Row(
                  children: [
                    Text(
                      'From',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ), 
                    Container(
                      margin: EdgeInsets.only(left: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.textBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        x.from,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    )               
                  ],
                ),
                SizedBox(height: 16.h,),
                Row(
                  children: [
                    Text(
                      'To',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ), 
                    Container(
                      margin: EdgeInsets.only(left: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.textBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        x.to,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    )               
                  ],
                ),
                SizedBox(height: 16.h,),
                Row(
                  children: [
                    Text(
                      'Creator',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ), 
                    Container(
                      margin: EdgeInsets.only(left: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.textBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        x.creator,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    )               
                  ],
                ),
                SizedBox(height: 16.h,),
                Row(
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ), 
                    Container(
                      margin: EdgeInsets.only(left: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.textBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        x.time,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    )               
                  ],
                ),
              ],
            ),
          ),
    
          Padding(
            padding: EdgeInsets.only(
              left: 44.0.w,
              right: 44.0.w,
              top: 0.h
            ),
            child: Column(
              children: [
                Text(
                  x.remainingPassengersText ,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14
                  ),
                ),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      x.participants.length, 
                      (index) => Container(
                        height: 11.h,
                        width: 35.w,
                        decoration: BoxDecoration(
                          color: AppColors.mainBlue,
                          borderRadius: BorderRadius.circular(10)
                        ),
                      )
                    ) + List.generate(
                      7-x.participants.length, 
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
            ),
          ),
        
          Padding(
            padding: EdgeInsets.only(
              bottom: 32.0.h,
              left: 32.w,
              right: 32.w
            ),
            child: AppButton(label: 'Join @ ${x.price}', state: ButtonState.normal, height: 40.h,),
          )
        ],
      ),
    );
  }

  
}