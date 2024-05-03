import 'package:cloud_firestore/cloud_firestore.dart';

class PriceRepository {
  final _db = FirebaseFirestore.instance.collection('business').doc('price');
  
  Stream<int> streamPrice (String uid){
    return _db.snapshots().map((event) => event.data()!['price']);
  }
}