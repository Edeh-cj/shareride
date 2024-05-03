// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shareride/models/ride.dart';
// import 'package:shareride/providers/user_provider.dart';
// import 'package:shareride/providers/rides_provider.dart';
// import 'package:shareride/utilities/app_colors.dart';
// import 'package:shareride/utilities/app_text_styles.dart';
// import 'package:shareride/utilities/background_paint.dart';
// import 'package:shareride/utilities/button2.dart';

// import '../providers/service_time_provider.dart';

// class ParticipationPage extends StatefulWidget {
//   const ParticipationPage({super.key});

//   @override
//   State<ParticipationPage> createState() => _ParticipationPageState();
// }

// class _ParticipationPageState extends State<ParticipationPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: CustomPaint(
//           painter: BackgroundPaint(),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 70,
//                 width: double.maxFinite,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       onPressed: ()=> Navigator.pop(context), 
//                       icon: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       'Participations(Rides)',
//                       style: AppTextStyle.appBar,
//                     ),
                    
//                   ],
//                 ),
//               ),
//               Expanded(child: ListView(
//                   children: context.watch<RidesProvider>().userRides(
//                     context.read<UserProvider>().user.uid
//                   ).map((e) => _participationCard(e)).toList(),
//                 )
//               )
      
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _participationCard(Ride ride) => Center(
//     child: Container(
//       height: 205,
//       width: double.maxFinite,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: AppColors.secondary,
//       ),
//       margin: const EdgeInsets.all(20),
//       padding: const EdgeInsets.only(
//         left: 16,
//         bottom: 12,
//         top: 4,
//         right: 4
//       ),
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.topLeft,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 12.0),
//               child: Text(
//                 ride.id,
//                 style: AppTextStyle.cardId,            
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.topRight,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 12.0, right: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     ride.time,
//                     style: AppTextStyle.cardTime,            
//                   ),
//                   Text(
//                     context.read<ServiceTimeProvider>().serviceTime[ride.time]??'-',
//                     style: AppTextStyle.cardnb,            
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(width: 5,),
//               SizedBox(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Creator:',
//                       style: AppTextStyle.cardDetail,
//                     ),
//                     Text(
//                       'From:',
//                       style: AppTextStyle.cardDetail,
//                     ),
//                     Text(
//                       'To:',
//                       style: AppTextStyle.cardDetail,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 5,),
//               SizedBox(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       ride.creator,
//                       style: AppTextStyle.cardDetail,
//                     ),
//                     Text(
//                       '${ride.from},${ride.region}',
//                       style: AppTextStyle.cardDetail,
//                     ),
//                     Text(
//                       ride.to,
//                       style: AppTextStyle.cardDetail,
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
           
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 12.0, right: 16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   SizedBox(
//                     height: 32,
//                     width: double.maxFinite,
//                     child: Align(
//                       alignment: Alignment.centerRight,
//                       child: Padding(
//                         padding: const EdgeInsets.only(right: 12.0),
//                         child: Button2(
//                           label: Text(
//                             'Cancel',
//                             style: AppTextStyle.button2,
//                           ), 
//                           isActive: true,
//                           futureFunction: ()=> context.read<RidesProvider>().cancelRide(
//                             ride: ride, 
//                             userid: context.read<UserProvider>().uid!
//                           )
//                         ),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     ride.remainingPassengersText,
//                     style: AppTextStyle.cardAlert,            
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }