// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shareride/models/location.dart';
// import 'package:shareride/models/ride.dart';
// import 'package:shareride/providers/locations_provider.dart';
// import 'package:shareride/providers/price_provider.dart';
// import 'package:shareride/providers/rides_provider.dart';
// import 'package:shareride/providers/service_time_provider.dart';
// import 'package:shareride/providers/user_provider.dart';
// import 'package:shareride/screens/participation_page.dart';
// import 'package:shareride/screens/rides_page.dart';
// import 'package:shareride/screens/search_delegate.dart';
// import 'package:shareride/utilities/app_colors.dart';
// import 'package:shareride/utilities/app_logo.dart';
// import 'package:shareride/utilities/app_snackbar.dart';
// import 'package:shareride/utilities/app_text_styles.dart';
// import 'package:shareride/utilities/button1.dart';
// import 'package:shareride/utilities/button2.dart';
// import 'package:shareride/utilities/form_decoration.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController _nameController = TextEditingController();
//   Location? _fromValue;
//   Location? _toValue;
//   List<Location> _toList = [];
//   String? _timeValue;
//   final _createRideFormKey = GlobalKey<FormState>();
//   ButtonState _createRideButtonState = ButtonState.normal;

//   @override
//   void initState() {
//     _nameController.text = context.read<UserProvider>().user.name;
//     super.initState();
//   }  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: 115,
//             width: double.maxFinite,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     appLogo,
//                     Padding(
//                       padding: const EdgeInsets.only(right: 16.0),
//                       child: Text(
//                         'Rides @ ${context.watch<PriceProvider>().seatPrice}',
//                         style: const TextStyle(
//                           fontFamily: 'Spartan',
//                           fontWeight: FontWeight.w300,
//                           fontSize: 12
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: ()=> showDialog(context: context, 
//                         builder: (context)=> createRideForm
//                       ),
//                       child: Container(
//                         constraints: BoxConstraints.tight(Size(MediaQuery.of(context).size.width*0.4, 31)),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary,
//                           borderRadius: BorderRadius.circular(5)
//                         ),
//                         child: Center(
//                           child: Text(
//                           '+ Create Ride',
//                           style: AppTextStyle.button2,
//                           ), 
//                         ),
//                       ),
//                     ),
                    
//                     IconButton(
//                       onPressed: (){
//                         showSearch(
//                           context: context, 
//                           delegate: RidesSearchDelegate(
//                             rides: [
//                               Ride.custom(4, 'Hilltop', 'wwwwww'),
//                               Ride.custom(4, 'Hilltop', 'wwwwww'),
//                               Ride.custom(4, 'Odim', 'wwwwww'),
//                               Ride.custom(4, 'Odenigwe', 'wwwwww'),
//                               Ride.custom(4, 'Hilltop', 'wwwwww'),
//                               Ride.custom(4, 'Hilltop', 'wwwwww'),
//                             ]
//                           )
//                         );
//                       }, 
//                       icon: const Icon(
//                         Icons.search,
//                         color: Colors.black,
//                         size: 24,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 8.0),
//                       child: Badge(
//                         textColor: Colors.white,
//                         backgroundColor: Colors.red,
//                         offset: const Offset(0, 4),
//                         label: Text(context.watch<RidesProvider>().userRides(
//                           context.read<UserProvider>().user.uid
//                         ).length.toString()),
//                         child: IconButton(
//                           onPressed: (){
//                             Navigator.of(context).push(
//                               MaterialPageRoute(builder: (context)=> const ParticipationPage())
//                             );
//                           }, 
//                           icon: Icon(
//                             Icons.car_repair_rounded,
//                             color: AppColors.primary,
//                             size: 30,  
//                           )
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: GridView(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 16,
//                   crossAxisSpacing: 16,
//                   childAspectRatio: 1.5
//                 ),
//                 children: context.watch<LocationsProvider>().regions.map(
//                   (e) => _gridCard(e, context.read<RidesProvider>().allRides)
//                 ).toList(),
//               ),
//             ),
//           ),
//           // const Image(
//           //   image: AssetImage('assets/adbanner.png'),
//           //   fit: BoxFit.cover,
//           //   height: 79,
//           //   width: double.maxFinite,
//           // )
//         ],
//       ),
//     );
//   }

//   Widget _gridCard (String regionString, List<Ride> rides) {
//     int ridesAvailable = rides.where(
//       (element) => !element.isComplete
//     ).length;
//     return GestureDetector(
    
//     onTap: () => Navigator.push(
//       context, 
//       MaterialPageRoute(
//         builder: (context)=> RidesPage(regionString: regionString, rides: rides,)
//       )
//     ),
//     child: Card(
//       color: AppColors.secondary,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10)
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 8.0, bottom: 16, top: 28),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               regionString,
//               style: AppTextStyle.appBar,
//             ),
//             Text((ridesAvailable == 1)? '$ridesAvailable Ride Available' :'$ridesAvailable Rides Available',
//             style: AppTextStyle.cardAlert,
//             )
//           ],
//         ),
//       ),
//     ),
//   );
//   }

//   Widget _joinCard(Ride ride) => Center(
//     child: Material(
//       child: Container(
//         color: AppColors.secondary,
//         height: 205,
//         width: double.maxFinite,
//         padding: const EdgeInsets.only(
//           left: 16,
//           bottom: 12,
//           top: 16,
//           right: 4
//         ),
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 12.0),
//                 child: Text(
//                   ride.id,
//                   style: AppTextStyle.cardId,            
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 12.0, right: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       ride.time,
//                       style: AppTextStyle.cardTime,            
//                     ),
//                     Text(
//                       context.read<ServiceTimeProvider>().serviceTime[ride.time]??'-',
//                       style: AppTextStyle.cardnb,            
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(width: 5,),
//                 SizedBox(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Creator:',
//                         style: AppTextStyle.cardDetail,
//                       ),
//                       Text(
//                         'From:',
//                         style: AppTextStyle.cardDetail,
//                       ),
//                       Text(
//                         'To:',
//                         style: AppTextStyle.cardDetail,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 5,),
//                 SizedBox(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         ride.creator,
//                         style: AppTextStyle.cardDetail,
//                       ),
//                       Text(
//                         '${ride.from},${ride.region}',
//                         style: AppTextStyle.cardDetail,
//                       ),
//                       Text(
//                         ride.to,
//                         style: AppTextStyle.cardDetail,
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 12.0, right: 16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Button2(
//                       label: Text(
//                         'Join @ ${ride.price}',
//                         style: AppTextStyle.button2,
//                       ), 
//                       isActive: !ride.isComplete,
//                       futureFunction: ()=> context.read<RidesProvider>().joinRide(
//                         ride: ride, 
//                         userid: context.read<UserProvider>().uid!, 
//                         name: context.read<UserProvider>().user.name, 
//                         phonenumber: context.read<UserProvider>().user.phonenumber
//                       )
//                     ),
//                     const SizedBox(height: 5,),
//                     Text(
//                       ride.remainingPassengersText,
//                       style: AppTextStyle.cardAlert,            
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );

//   Widget get createRideForm => Center(
//     child: Container(
//       height: 479,
//       width: double.maxFinite,
//       margin: AppFormDecoration.margin,
//       child: Material(
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 padding: AppFormDecoration.padding,
//                 decoration: AppFormDecoration.boxDecoration,
//                 // height: double.maxFinite,
//                 width: double.maxFinite,
//                 child: Form(
//                   key: _createRideFormKey,
//                   child: Column(
//                     children: [
//                       // const SizedBox(height: 65,),
//                       AppFormDecoration.dropdownFormfield(
//                         'From', 
//                         'Chizaram Lodge, Hilltop', 
//                         context.read<LocationsProvider>().locations.where(
//                           (element) => element.isRoute == false
//                         ).toList(), 
//                         _fromValue, 
//                         (p0) {
//                           setState(() {
//                             _fromValue = p0;
//                             _toList = context.read<LocationsProvider>().locations.where(
//                               (e) => e.isInsideSchool == !p0!.isInsideSchool && e.isRoute
//                               ).toList();
//                           });
//                         },
//                         (){
//                           setState(() {
//                             _toValue = null;
//                             _toList = [];
//                           });
//                         }

//                       ),
//                       AppFormDecoration.dropdownFormfield(
//                         'To', 
//                         'Palg, School', 
//                         _toList,  
//                         _toValue, 
//                         (p0) {
//                           setState(() {
//                             _toValue = p0;
//                           });
//                         },
//                         (){}
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Time',
//                             style: TextStyle(
//                               fontSize: 13
//                             ),            
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           DropdownButtonFormField<String?>( 
//                             style: const TextStyle(fontSize: 13, color: Colors.black),
//                             value: _timeValue,         
//                             items: List.generate(
//                               context.read<ServiceTimeProvider>().serviceTime.keys.toList().length , 
//                               (index) => DropdownMenuItem(
//                                 value: context.read<ServiceTimeProvider>().serviceTime.keys.toList()[index],
//                                 child: Text(
//                                   context.read<ServiceTimeProvider>().serviceTime.keys.toList()[index],
//                                   overflow: TextOverflow.visible,
//                                 ),
//                               )
//                             ), 
//                             onChanged: (p0) {
//                               setState(() {
//                                 _timeValue = p0;
//                               });
//                             },          
//                             validator: (s){
//                               if (s == null ) {
//                                 return 'invalid field';              
//                               } else {
//                                 return null;
//                               }
//                             },
//                             borderRadius: BorderRadius.circular(0),
//                             elevation: 0,
//                             iconSize: 12,
//                             decoration: InputDecoration(
//                               constraints: BoxConstraints.tight(
//                                 const Size(double.maxFinite, 36)
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(0),
//                                 borderSide: const BorderSide(
//                                   color: Color.fromRGBO(217, 217, 217, 1)
//                                 )
//                               ),
//                               hintText: '8am',
//                               hintStyle: const TextStyle(
//                                 fontSize: 13,
//                               )
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           )
//                         ],
//                       ),
//                       AppFormDecoration.formField(
//                         _nameController, 
//                         'Display Name', 
//                         null, 
//                         (p0) {
//                           if (p0 == null || p0.isEmpty) {
//                             return 'invalid field';
//                           } else {
//                             return null;
//                           }
//                         },
//                         TextInputType.name
//                       ),
//                       GestureDetector(
//                         onTap: _createRideFunction,
//                         child: AppButton(
//                           label: 'Create', 
//                           state: _createRideButtonState,
                          
//                         ),
//                       )
//                     ],
//                   ) 
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: const Padding(
//                   padding: EdgeInsets.only(top: 12.0,  right: 16),
//                   child: Icon(Icons.cancel_outlined),
//                   // child: Text(
//                   //   'x',
//                   //   style: TextStyle(color: Colors.black),
//                   // ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 30.0, left: 18),
//                 child: Text(
//                   'Create New Ride',
//                   style: AppTextStyle.formLabel,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
  
//   _createRideFunction() {
//     if (_createRideFormKey.currentState!.validate() && _createRideButtonState != ButtonState.loading) {
//       setState(() {
//         _createRideButtonState = ButtonState.loading; 
//       });
//       context.read<RidesProvider>().createRide(
//         from: _fromValue!,
//         to: _toValue!,
//         time: _timeValue!,
//         userId: context.read<UserProvider>().uid!,
//         name: _nameController.text
//       ).then(
//         (value) {
//           setState(() {
//             _createRideButtonState = ButtonState.success; 
//           });
//           showDialog(
//             context: context, 
//             builder: (context)=> _joinCard(value)
//           );
//         }
//       ).catchError((e){
//         AppSnackBar.error(e);
//         setState(() {
//           _createRideButtonState = ButtonState.error; 
//         });
//       });
//     }
//   }
// }
