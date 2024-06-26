import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shareride/models/business_time_data.dart';

class ServiceTimeRepository {
  final _db = FirebaseFirestore.instance.collection('business').doc('servicetime');

  Stream<BusinessTimeData> streamTimeList(){
    return _db.snapshots().map((event) {
      List list = event.get('sevicetime');
      List<ServiceTimeData> serviceTimeList = list.map((e) => ServiceTimeData(key: e['key'], arrivalTime: e['busArrivalTime']),).toList();
      return BusinessTimeData(
        alarmOffsetMorning: event.get('alarm_offset_morning_minutes'), 
        alarmOffsetNoon: event.get('alarm_offset_noon_minutes'),
        serviceTimeList: serviceTimeList,         
      );
      // return event.get('sevicetime');
    });
  }
}