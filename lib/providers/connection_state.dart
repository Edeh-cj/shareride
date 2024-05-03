import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class AppConnectionState {

  late bool isOnline;

  initialise(BuildContext context) async{

    await Connectivity().checkConnectivity().then((value) {
      if (checkIsOnline(value)) {
        isOnline = true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('No Connection')),
          backgroundColor: Colors.grey,
          )
        );
      }
    });

    Connectivity().onConnectivityChanged.listen((event) {
      if (checkIsOnline(event) != isOnline) {
        if (checkIsOnline(event)) {
          ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
            content: Center(child: Text('Online')),
            backgroundColor: Colors.green,
            ));
          isOnline = true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('No Connection')),
            backgroundColor: Colors.grey,
            )
          );
          isOnline = false;
        }
      }
    });
  }

  bool checkIsOnline(ConnectivityResult value){
    if (value == ConnectivityResult.mobile || 
    value == ConnectivityResult.wifi ||
    value == ConnectivityResult.vpn) {
      return true;
    } else {
      return false;
    }
  }
}