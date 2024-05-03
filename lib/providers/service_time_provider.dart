import 'package:flutter/material.dart';

import '../Repositories/service_time_repository.dart';

class ServiceTimeProvider with ChangeNotifier {
  final repository = ServiceTimeRepository();
  Map timeData = <String, String>{};
  getServiceTime(String time) => timeData[time]?? '- am';

  beginStreamServiceTime(){
    repository.streamTimeList().listen((event) {
      Map map = {};
      for (final element in event) {
        map.addEntries({MapEntry(element.keys.first, element.values.first)});
      }
      timeData = map;
      notifyListeners();
    });
  }
    

}