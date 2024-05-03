import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shareride/models/app_user.dart';

class UserRepository {
  final _auth = FirebaseAuth.instance;
  static final db = FirebaseFirestore.instance.collection('users');

  Future<UserCredential> registerAuthUser (String email, String password,) async{
    return await _auth.createUserWithEmailAndPassword(email: email, password: password); 
  }

  Future<void> signinAuthUser (String email, String password) async{
    await _auth.signInWithEmailAndPassword(email: email, password: password).then(
      (value) => value.user!.uid
    );
  }

  Future signOutAuth () async{
    await _auth.signOut().catchError((e){throw Exception(e);});
  }

  Future<void> createAppUserFirestore(String uid, String phoneNumber, String name, String email) async{
    Map<String, dynamic> userData = {
      'name': name,
      'phonenumber': phoneNumber,
      'balance': 0,
      'uid': uid,
      'email': email
    };
    await db.doc(uid).set(userData);
  }

  Stream<User?> streamAuthUser (){
    return _auth.userChanges();
  }

  Stream<AppUser> streamAppUserFirestore(String uid){
    return db.doc(uid).snapshots().map(
      (event) => AppUser.fromFirestore(event.data()!));
  }

  Future loadBalance(int amount, String uid) async{
    await db.doc(uid).update({
      'balance': FieldValue.increment(amount)
    });
  }

  
}