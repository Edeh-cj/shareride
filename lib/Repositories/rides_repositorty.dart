import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shareride/Repositories/user_repository.dart';
import 'package:shareride/models/ride.dart';

class RidesRepository {

  final _db = FirebaseFirestore.instance.collection('rides');

  Stream<List<dynamic>> streamAllRides(){
    return _db.snapshots().map((event) {
      return event.docs.map((e) => Ride(
        creator: e.data()['creator'], 
        creatorid: e.data()['creatorid'], 
        id: e.data()['id'], 
        from: e.data()['from'], 
        isLocked: e.data()['islocked'],
        to: e.data()['to'], 
        region: e.data()['region'], 
        time: e.data()['time'],
        price: e.data()['price'], 
        docid: e.id,
        participants: e.data()['participants'])
        ).toList();
    });
  }

  Future<Ride> createRide({required String creator, required bool isLocked, required String creatorid, required String id, required String from, required String to, required String region, required String time, required int price})async{
    Map<String, dynamic> rideData = {
      'creator' : creator,
      'creatorid': creatorid,
      'id': id,
      'from': from,
      'to': to,
      'time': time,
      'islocked': isLocked,
      'region': region,
      'price': price,
      'participants': <String>[]
    };
    return await _db.add(rideData).then((value) async=> await value.get().then((e) => Ride(
      creator: e['creator'], 
      creatorid: e['creatorid'], 
      id: e['id'], 
      docid: e.id, 
      from: e['from'], 
      to: e['to'], 
      isLocked: e['islocked'],
      region: e['region'], 
      time: e['time'], 
      price: e['price'],
      participants: e['participants']
      )
    )).catchError((e)=> throw (e as FirebaseException).code);
  }

  Future<void> joinRide({required String uid, required String name, required String phonenumber, required Ride ride}) async{
    
    DocumentReference documentReference = _db.doc(ride.docid);
    DocumentReference userDocumentReference = UserRepository.db.doc(uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async{
      
      int balance = await UserRepository.db.doc(uid).get().then((value) => value.data()!['balance']);
      List participants = [];
      int participantsCount = await documentReference.get().then((value) {
        participants = value.get('participants') ;
        return (value.get('participants') as List).length;
      });

      if (participantsCount < 7) {
        if (balance >= ride.price) {
          transaction.update(documentReference, {
            'participants': participants + [uid]
          });
          transaction.update(userDocumentReference, {
            'balance': FieldValue.increment(-ride.price)
          });
        } else {
          throw FirebaseException(
            plugin: 'insufficent Funds',
            code: 'insufficent Funds',
            message: 'insufficent Funds'
          );
        }
      } else {
        throw FirebaseException(
          plugin: 'passengers-already-complete',
          code: 'passengers-already-complete',
          message: 'passengers-already-complete'
        );
      }
      
    }).catchError((e) {
      throw (e as FirebaseException).code;
    });
  }
  //   Future switchtoWhatsapp() async{
  //   DocumentReference linedocref = businessref.doc('businessline');

  //   String businessline =await linedocref.get().then((value){
  //     return value.get('number');
  //   },);

  //   // String whatsappurl = "https://wa.me/${businessline}";
  //   String whatsappurl = "whatsapp://send/?phone=$businessline&text&type=phone_number&app_absent=0";
  //   await launchUrl(Uri.parse(whatsappurl));
  // }

  Future<void> cancelRide({required Ride ride, required String uid})async{
    DocumentReference documentReference = _db.doc(ride.docid);
    DocumentReference userDocumentReference = UserRepository.db.doc(uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async{
      List participants = 
        await documentReference.get().then((value) {
          return value.get('participants') ;
      }); 
      await userDocumentReference.update(
        {
          'balance': FieldValue.increment(ride.price) 
        }
      );
      participants.remove(uid);

      transaction.update(documentReference, {
        'participants': participants
      });
      
    }).catchError((e) => throw (e as FirebaseException).code);
  }
}