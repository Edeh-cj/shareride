import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shareride/firebase_options.dart';
import 'package:shareride/providers/user_provider.dart';
import 'package:shareride/providers/locations_provider.dart';
import 'package:shareride/providers/price_provider.dart';
import 'package:shareride/providers/rides_provider.dart';
import 'package:shareride/providers/service_time_provider.dart';
import 'package:shareride/providers/whatsapp_provider.dart';
import 'package:shareride/screens/signin_page.dart';
import 'package:shareride/utilities/app_colors.dart';
import 'new_screens/homepage.dart';
import 'providers/bottom_nav_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BottomNavProvider()),
      ChangeNotifierProvider(create: (_) => RidesProvider()),
      ChangeNotifierProvider(create: (_) => PriceProvider()),
      ChangeNotifierProvider(create: (_) => LocationsProvider()),
      ChangeNotifierProvider(create: (_) => ServiceTimeProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => WhatsappProvider()),
    ],
    child: const ScreenUtilInit(
      designSize: Size(360, 800),  
      child: MyApp()
  )));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<UserProvider>().beginStreamAuthState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareRide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        fontFamily: 'Spartan'
      ),
      home: Center(
          child: context.watch<UserProvider>().uid != null
              ? const Homepage()
              : const SigninPage()
            ),
    );
  }
}
