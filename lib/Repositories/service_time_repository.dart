import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceTimeRepository {
  final _db = FirebaseFirestore.instance.collection('business').doc('servicetime');

  Stream<List> streamTimeList(){
    return _db.snapshots().map((event) => event.get('sevicetime'));
  }
}