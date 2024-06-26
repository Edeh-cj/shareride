import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:shareride/Repositories/rides_repositorty.dart';
import 'package:shareride/models/alarm_time.dart';
import 'package:shareride/models/location.dart';
import 'package:shareride/models/region_ride.dart';
import 'package:shareride/models/ride.dart';

class RidesProvider with ChangeNotifier {

  final _repository = RidesRepository();
  
  List<Ride> allRides = [];

  List<RegionRide> get regionalRides {
    Set<String> regions = {};
    List<RegionRide> list = [];
    for (var element in allRides) {
      regions.add(element.region);
    }
    for (var r in regions) {
      list.add(
        RegionRide(
          region: r, 
          rides: allRides.where((element) => element.region == r).toList()
        )
      );
    }
    return list;
  }

  List<Ride> userRides(String userId) {
    List<Ride> r = [];
    for (var element in allRides) { 
      // ignore: unused_local_variable
      for (var e in element.participants) { 
        if (e== userId) {
          r.add(element);
        }        
      }
    }    
    return r;
  }

  List<Ride> ridesbyRegion (String region)=> allRides.where(
    (element) => element.region.toLowerCase() == region.toLowerCase(),).toList();


  beginStreamAllrides (){
    _repository.streamAllRides().listen(
      (event) {
        allRides = event as List<Ride>;
        notifyListeners();
      }
    );
    
  }
 
  Future<Ride> createRide({required Location from, required Location to, required String time, required String name, required String userId, })async{
    return _repository.createRide(
      creator: name,
      creatorid: userId, 
      id: generateRideId(), 
      to: to.name, 
      region: from.region, 
      from: from.name, 
      isLocked : false,
      price: (from.price ?? to.price)!,
      time: time
    );
  }

  Future<void> joinRide({required Ride ride, required String userid, required String name, required String phonenumber, required AlarmTime? alarmTime}) async{
    await _repository.joinRide(
      ride: ride,
      uid: userid,
      name: name,
      phonenumber: phonenumber
    ).then((value) => setAlarm(alarmTime, ride.time));
  }

  Future<void> cancelRide({required Ride ride, required String userid})async{
    await _repository.cancelRide(
      ride: ride,
      uid: userid  
    );
  }

  String generateRideId (){
    String idStrings = 'ABCBEFGHJKLMNPQRSTWXYZ0123456789';
    int randIndex () => Random().nextInt((idStrings.length));
    return idStrings[randIndex()] + idStrings[randIndex()] + idStrings[randIndex()] + idStrings[randIndex()] + idStrings[randIndex()];
    
  }


  void setAlarm (AlarmTime? alarmTime, String timeKey){
    if (alarmTime != null) {
      FlutterAlarmClock.createAlarm(
        title: 'ShareRide. ⏰Almost time!! 🏃🚐 ',
        hour: alarmTime.hour, minutes: alarmTime.minutes
      );
    }
  }

  // void setAlarmMorn(String schedule, DateTime now){
  //   int alarmTime = scheduletoint(schedule); 
  //   FlutterAlarmClock.createAlarm(
  //     title: 'GoEasy, ⏰Almost time!! 🏃🚐 (bus arrives at $alarmTime:30) 🏃🚐',
  //     hour: alarmTime, minutes: 0);
  // }

  // bool canBook(String timeSchedule, List<Schedule> list){
  //   List<String> tick = list.map((e) => e.schedule).toList();
  //   bool isMorn = (timeSchedule == '7am') || (timeSchedule == '8am') || (timeSchedule == '9am') || (timeSchedule == '10am');
  //   bool canBookNoon = (tick.where((element) => element== '1pm' || element== '2pm' || element== '3pm' || element== '4pm' )).length < 2;
  //   bool canBookMorn = (tick.where((element) => element== '7am' || element== '8am' || element== '9am' || element== '10am' )).length < 2;
  //   if ((isMorn && canBookMorn) || (!isMorn && canBookNoon)) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // int scheduletoint(String schedule) {
  //   switch (schedule) {
  //     case '7am':
  //       return 6;
  //     case '8am':
  //       return 7;
  //     case '9am':
  //       return 8;
  //     case '10am':
  //       return 9;
  //     case '1pm':
  //       return 13;
  //     case '2pm':
  //       return 14;
  //     case '3pm':
  //       return 15;
  //     case '4pm':
  //       return 16;
        
  //     default: return 0;
  //   }
  // }
  
}