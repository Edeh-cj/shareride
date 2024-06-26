class BusinessTimeData {
  final int alarmOffsetMorning, alarmOffsetNoon;
  List<ServiceTimeData> serviceTimeList;

  BusinessTimeData({required this.alarmOffsetMorning, required this.serviceTimeList, required this.alarmOffsetNoon});
  
}

class ServiceTimeData {
  final key, arrivalTime;

  ServiceTimeData({required this.key, required this.arrivalTime});
}