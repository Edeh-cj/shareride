import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/models/ride.dart';
import 'package:shareride/utilities/app_colors.dart';
import '../new_screens/join_bottom_sheet.dart';
import '../providers/rides_provider.dart';
import '../utilities/button1.dart';

class RidesSearchDelegate extends SearchDelegate {
  final List<Ride> rides ;

RidesSearchDelegate({required this.rides});
  @override
  String? get searchFieldLabel => 'Search by location, time';

  @override
  TextStyle? get searchFieldStyle => const TextStyle();

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
    List<Ride> list = rides.where((e) => e.time.toLowerCase().contains(query.toLowerCase())
     || e.from.toLowerCase().contains(query.toLowerCase())).toList();
     return ListView(
      children: <Widget>[SizedBox(height: 12.h,)] + List.generate(
        list.length, 
        (index) => _listCard(list[index])),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Ride> list = rides.where((e) => e.time.toLowerCase().contains(query.toLowerCase())
     || e.from.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(
      children: <Widget>[SizedBox(height: 12.h,)] + List.generate(
        list.length, 
        (index) => _listCard(list[index])),
    );
  }

  Widget _listCard (Ride ride)=> Builder(
    builder: (context) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          showBottomSheet(
            context: context, 
            builder: (context) => JoinBottomSheet(ride: ride, context: context)
          );
        },
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
          child: AppButton(label: 'Join @ ${x.price}', state: ButtonState.normal),
        )
      ],
    ),
  );
  }


  
}

class RidesSearchDelegatebyId extends SearchDelegate {
  final List<Ride> rides ;

RidesSearchDelegatebyId({super.searchFieldDecorationTheme, super.keyboardType, super.textInputAction, required this.rides});
  @override
  String? get searchFieldLabel => 'Search by id, location, creator...';

  @override
  TextStyle? get searchFieldStyle => const TextStyle();

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
    List<Ride> list = rides.where((e) => e.creator.toLowerCase().contains(query.toLowerCase())
     || e.from.toLowerCase().contains(query.toLowerCase())
     || e.to.toLowerCase().contains(query.toLowerCase())
     || e.id.toLowerCase().contains(query.toLowerCase())
     || e.region.toLowerCase().contains(query.toLowerCase())
    
    ).toList();
     return ListView(
      children: <Widget>[SizedBox(height: 12.h,)] + List.generate(
        list.length, 
        (index) => _listCard(list[index])),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Ride> list = rides.where((e) => e.creator.toLowerCase().contains(query.toLowerCase())
     || e.from.toLowerCase().contains(query.toLowerCase())
     || e.to.toLowerCase().contains(query.toLowerCase())
     || e.id.toLowerCase().contains(query.toLowerCase())
     || e.region.toLowerCase().contains(query.toLowerCase())
    
    ).toList();
    return ListView(
      children: <Widget>[SizedBox(height: 12.h,)] + List.generate(
        list.length, 
        (index) => _listCard(list[index])),
    );
  }

  Widget _listCard (Ride ride)=> Builder(
    builder: (context) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          showBottomSheet(
            context: context, 
            builder: (context) => JoinBottomSheet(ride: ride, context: context)
          );
        },
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
}

