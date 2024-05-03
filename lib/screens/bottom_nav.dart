// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:shareride/providers/locations_provider.dart';
// import 'package:shareride/providers/user_provider.dart';
// import 'package:shareride/providers/whatsapp_provider.dart';
// import 'package:shareride/screens/deposit_page.dart';
// import 'package:shareride/screens/home_page.dart';
// import 'package:shareride/utilities/app_colors.dart';

// import '../providers/bottom_nav_provider.dart';
// import '../providers/connection_state.dart';
// import '../providers/price_provider.dart';
// import '../providers/rides_provider.dart';
// import '../providers/service_time_provider.dart';

// class BottomNavPage extends StatefulWidget {
//   const BottomNavPage({super.key});

//   @override
//   State<BottomNavPage> createState() => _BottomNavPageState();
// }

// class _BottomNavPageState extends State<BottomNavPage> {

//   @override
//   Widget build(BuildContext context) {
//     String uid = context.read<UserProvider>().uid!;
//     context.read<UserProvider>().beginStreamAppUser(uid);
//     context.read<LocationsProvider>().beginStreamLocations();
//     context.read<PriceProvider>().beginStreamPrice(uid);
//     context.read<RidesProvider>().beginStreamAllrides();
//     context.read<ServiceTimeProvider>().beginStreamServiceTime();
    
//     AppConnectionState().initialise(context);

//     List<Widget> screens = [const HomePage(), const DepositPage(), ];
//     Size screensize = MediaQuery.of(context).size;

//     return Scaffold(
//       body: SafeArea(child: screens[context.watch<BottomNavProvider>().index]),
//       floatingActionButton: Visibility(
//         visible: context.read<BottomNavProvider>().index == 1,
//         child: FloatingActionButton(
//           onPressed: (){
//             context.read<WhatsappProvider>().switchtoWhatsapp();
//           },
//           child: const FaIcon(FontAwesomeIcons.whatsapp),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.symmetric(horizontal: screensize.width*0.1),
//         child: BottomNavigationBar( 
//           elevation: 0,
//             currentIndex: context.read<BottomNavProvider>().index,
//             fixedColor: Colors.black,
//             onTap: (value) {
//               context.read<BottomNavProvider>().update(value);              
//             },
//             items: <BottomNavigationBarItem>[
        
//               BottomNavigationBarItem(
//                 icon: FaIcon(
//                   FontAwesomeIcons.house,
//                   size: 20,
//                   color: AppColors.grey,
//                 ),
//                 activeIcon: FaIcon(
//                   FontAwesomeIcons.house,
//                   size: 20,
//                   color: AppColors.primary,
//                 ),
//                 label: ''),
              
//               BottomNavigationBarItem(
//                 icon: FaIcon(
//                   FontAwesomeIcons.nairaSign,
//                   size: 20,
//                   color: AppColors.grey,
//                 ),
//                 activeIcon: FaIcon(
//                   FontAwesomeIcons.nairaSign,
//                   size: 20,
//                   color: AppColors.primary,
//                 ),
//                 label: ''
//               )
//             ]
//           ),
//       ),
//     );
//   }
// }
