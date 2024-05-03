import 'package:flutter/material.dart';
import 'package:shareride/Repositories/user_repository.dart';
import 'package:shareride/models/app_user.dart';

class UserProvider extends ChangeNotifier {
  final repository = UserRepository();
  
  AppUser user = AppUser.dummy();
  String? uid ;

  beginStreamAuthState (){
    repository.streamAuthUser().listen(
      (event) {
          uid = event?.uid ;
          notifyListeners();
        
      }
    );
  }

  Future<void> registerUser({required String name, required String password, required String email, required int phonenumber})async{
    // final credential = await repository.registerAuthUser(email, password);
    // if (credential.user != null) {
    //   await createAppUser(credential.user!.uid, name, phonenumber);
    //   await signinUser(password: password, email: email);
    // }
    // try {
    //   await repository.registerAuthUser(email, password);
    // } catch (e) {
      
    // }
    await repository.registerAuthUser(email, password).then((value) async{
      await createAppUser(value.user!.uid, name, phonenumber, email);
      // await signinUser(password: password, email: email);
    });    
  }
  
  Future signinUser({required String password, required String email})async{
    await repository.signinAuthUser(email, password);
  }

  Future createAppUser(String uid, String name, int phoneNumber, String email) async{
    await repository.createAppUserFirestore(uid, phoneNumber.toString(), name, email);
  }

  Future loadBalance(int amount)async{
    await repository.loadBalance(amount, uid!);
  }
  
  void beginStreamAppUser(String uid) {
    repository.streamAppUserFirestore(uid).listen((event) {
      user = event;
      notifyListeners();
    },);
  }

  Future signOut() async{
    await repository.signOutAuth();
  }
}