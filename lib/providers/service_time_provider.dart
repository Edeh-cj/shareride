import 'package:flutter/material.dart';
import 'package:shareride/models/alarm_time.dart';

import '../Repositories/service_time_repository.dart';
import '../models/business_time_data.dart';

class ServiceTimeProvider with ChangeNotifier {
  final repository = ServiceTimeRepository();

  List<ServiceTimeData> serviceTimeList = [];  
  int? alarmOffsetNoon ;
  int? alarmOffsetMorning ;

  beginStreamServiceTime(){
    repository.streamTimeList().listen((event) {
      serviceTimeList = event.serviceTimeList;
      alarmOffsetMorning = event.alarmOffsetMorning;
      alarmOffsetNoon = event.alarmOffsetNoon;
      notifyListeners();
    });
  }

  String getTimeFormat(String timeKey) {
    List list = serviceTimeList.where((element) => element.key == timeKey).toList();
    String format = list.isNotEmpty? list.first.arrivalTime.toString() : '- am';
    return format;
  }

  AlarmTime? getAlarmSchedule(String timeKey){
    timeKey = timeKey.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    int? timeMinutes =  switch (timeKey) {
      '4am' => 240,
      '5am' => 300,
      '6am' => 360,
      '7am' => 420,
      '8am' => 480,
      '9am' => 540,
      '10am' => 600,
      '11am' => 660,
      '12pm' => 720,
      '1pm' => 780,
      '2pm' => 840,
      '3pm' => 900,
      '4pm' => 960,
      '5pm' => 1020,
      '6pm' => 1080,
      '7pm' => 1140,
      '8pm' => 1200,
      '9pm' => 1260,
      '10pm' => 1320,
      String() => null,
    };
    if (timeMinutes != null && alarmOffsetMorning != null &&  alarmOffsetNoon != null) {
      int alarmHour = ((timeMinutes + (timeKey.contains('am')? alarmOffsetMorning! : alarmOffsetNoon!))/60).floor();
      int alarmMinutes = ((timeMinutes + (timeKey.contains('am')? alarmOffsetMorning! : alarmOffsetNoon!))%60);
      return AlarmTime(hour: alarmHour, minutes: alarmMinutes);
    } else{
      return null;
    }
  }
    

}