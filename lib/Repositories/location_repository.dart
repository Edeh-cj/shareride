import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shareride/models/location.dart';

class LocationRepository {
  final _db = FirebaseFirestore.instance.collection('business').doc('locations');
  
  Stream<Map<String, dynamic>> streamLocations(){
    return _db.snapshots().map((event) {
      return event.data()!;
  
    });
  }
}