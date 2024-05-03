import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shareride/Repositories/rides_repositorty.dart';
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

  Future<void> joinRide({required Ride ride, required String userid, required String name, required String phonenumber}) async{
    await _repository.joinRide(
      ride: ride,
      uid: userid,
      name: name,
      phonenumber: phonenumber
    );
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

  // String rideScheduleNote(String time){
  //   String arrivalMinutes = (60-_timeToRide).toString();
  //   return switch (time) {
  //     '7am' => 'Bus arrives 6:${arrivalMinutes}am',
  //     '8am' => 'Bus arrives 7:${arrivalMinutes}am',
  //     '9am' => 'Bus arrives 8:${arrivalMinutes}am',
  //     '10am' => 'Bus arrives 9:${arrivalMinutes}am',
  //     '11am' => 'Bus arrives 10:${arrivalMinutes}am',
  //     '12pm' => 'Bus arrives 11:${arrivalMinutes}am',
  //     '1pm' => 'Bus arrives 12:${arrivalMinutes}pm',
  //     '2pm' => 'Bus arrives 1:${arrivalMinutes}pm',
  //     '3pm' => 'Bus arrives 2:${arrivalMinutes}pm',
  //     '4pm' => 'Bus arrives 3:${arrivalMinutes}pm',
  //     String() => 'Bus arrives 3:40pm'
  //   };
  // }
  
}