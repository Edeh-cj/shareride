// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:shareride/new_screens/locations_page.dart';
// import 'package:shareride/providers/locations_provider.dart';
// import 'package:shareride/providers/rides_provider.dart';

// import '../models/region_location.dart';
// import '../utilities/app_colors.dart';

// class RegionLocationsPage extends StatefulWidget {
//   const RegionLocationsPage({super.key});

//   @override
//   State<RegionLocationsPage> createState() => _RegionLocationsPageState();
// }

// class _RegionLocationsPageState extends State<RegionLocationsPage> {
//   @override
//   Widget build(BuildContext context) {
//     List<RegionLocation> regionLocations = context.watch<LocationsProvider>().locationByRegion;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _appbar,
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: AppColors.backgroundGrey,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       offset: Offset(0, -4.h),
//                       blurRadius: 4.h
//                     )
//                   ]
//                 ),
//                 child: FractionallySizedBox(
//                   widthFactor: 1,
//                   heightFactor: 1,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(left: 16.0.w, top: 20.h, bottom: 24.h),
//                         child: Text(
//                           'All Rides',
//                           style: TextStyle(
//                             color: const Color.fromRGBO(27, 27, 31, 1),
//                             fontSize: 17.sp,
//                             fontWeight: FontWeight.w600
//                           ),
//                         ),
//                       ),

//                       // GestureDetector(
//                       //   onTap: () async => await showSearch(
//                       //     context: context,
//                       //     delegate: RidesSearchDelegatebyId(rides: context.read<RidesProvider>().allRides)
//                         // ),
//                       //   child: _searchField),
//                       // Expanded(
//                       //   child: FractionallySizedBox(
//                       //     widthFactor: 1,
//                       //     heightFactor: 1,
//                       //     child: ListView(
//                       //       children: List.generate(
//                       //         regionR.length, 
//                       //         (index) => _listCard(regionRides[index])
//                       //       ),
//                       //     ),
//                       //   )
//                       // )
//                     ],
//                   ),
//                 ),
//               )
//             )
//           ],
//         )
//       ),
//     );
//   }

//   Widget get _appbar => SizedBox(
//     height: 80.h,
//     width: double.maxFinite,
//     child: Row(
//       children: [
//         IconButton(
//           onPressed: ()=> Navigator.pop(context), 
//           icon: Icon(
//             Icons.arrow_back,
//             size:  24.sp,
//             color: Colors.black,
//           )
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: 8.w),
//           child: Image.asset('assets/shareridelogo.png'),
//         )
//       ],
//     ),
//   );

//   Widget get _searchField => Container(
//     margin: EdgeInsets.symmetric(horizontal: 32.w),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(50),
//       boxShadow: [
//         BoxShadow(
//           offset: const Offset(0, 4),
//           blurRadius: 4,
//           color: Colors.black.withOpacity(0.1)
//         )
//       ]
//     ),
//     child: TextField(
//       controller: _searchController,
//       enabled: false,
//       decoration: InputDecoration(
//         constraints: BoxConstraints.tight(Size(double.maxFinite, 40.h)),
//         filled: true,
//         fillColor: Colors.white,
//         hintText: 'Search Rides by id, location, creator...',
//         hintStyle: TextStyle(
//           fontSize: 10.sp,
//           color: const Color.fromRGBO(124, 124, 124, 1)
//         ),
//         prefixIcon: const Icon(
//           Icons.search,
//           color: Color.fromRGBO(124, 124, 124, 1)
//         ),
        
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(50),
//           borderSide: BorderSide.none
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(50),
//           borderSide: BorderSide.none
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(50),
//           borderSide: BorderSide.none
//         ),
//       ),
//     ),
//   );

//   Widget _listCard (RegionLocation regionLocation)=> GestureDetector(
//     onTap: ()=> Navigator.of(context).push(
//       MaterialPageRoute(builder: (context)=> LocationsPage() )
//     ),
//     child: Container(
//       padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
//       margin: EdgeInsets.only(top: 20.h, bottom: 4.h, left: 24.w, right: 24.w),
//       height: 100.h,
//       width: double.maxFinite,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10)
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(left: 12.0.w),
//                 child: Text(
//                   regionLocation.region,
//                   style: const TextStyle(
//                     color: Color.fromRGBO(12, 33, 74, 1),
//                     fontSize: 20,
//                     fontWeight: FontWeight.w400
//                   ),
//                 ),
//               ),
//               Icon(
//                 Icons.more_horiz,
//                 color: AppColors.mainBlue,
//               )
//             ],
//           ),
//           Container(
//             width: double.maxFinite,
//             padding: EdgeInsets.symmetric(horizontal: 12.w),
//             decoration: BoxDecoration(
//               color: AppColors.mainBlue,
//               borderRadius: BorderRadius.circular(10)
//             ),
//             height: 36.h,
//             alignment: Alignment.centerRight,
//             child: Text(
//               '${regionLocation.locations.length} Locations Here',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
//   final _searchController = TextEditingController();
// }