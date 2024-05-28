import 'package:flutter/material.dart';
import 'package:shareride/Repositories/business_repository.dart';

class WhatsappProvider with ChangeNotifier {
  final _repository = BusinessRepository();
  String whatsappNumber = '+2348079904793';
  String key = '';
  // String _secretKey = '';


  beginStreamkey (){
    _repository.streamPaystackKey().listen((event) {
      key = event;
      notifyListeners();
    });
    _repository.streamWhatsappNumber().listen((event) {
      whatsappNumber = event;
      notifyListeners();
    });
    // _repository.streamSecretKey().listen((event) {
    //   _secretKey = event;
    //   notifyListeners();
    // });
  }

  // Future<String> createAccessCode(String email, int amount, String ref) async{
  //   return await _repository.createAccessCode(_secretKey, email, amount, ref);
  // }

  Future switchtoWhatsapp()async{
    await _repository.switchtoWhatsapp(whatsappNumber);
  }
}