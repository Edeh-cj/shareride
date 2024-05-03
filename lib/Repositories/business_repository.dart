// import 'dart:convert';
// import 'package:http/http.dart' as http; 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessRepository{
  final _db = FirebaseFirestore.instance.collection('business');

  
  Future switchtoWhatsapp(String whatsappNumber) async{

    // String businessline =await _db.doc('whatsapp').get().then((value){
    //   return value.get('phonenumber');
    // },);
    // String whatsappurl = "https://wa.me/${businessline}";
    String whatsappurl = "whatsapp://send/?phone=$whatsappNumber&text&type=phone_number&app_absent=0";
    await launchUrl(Uri.parse(whatsappurl));
  }

  Stream<String> streamWhatsappNumber(){
    return _db.doc('whatsapp').snapshots().map((event) => event.get('phonenumber'));
  }

  Stream<String> streamPaystackKey(){
    return _db.doc('paystack').snapshots().map((event) => event.get('key'));
  } 

  Stream<String> streamSecretKey(){
    return _db.doc('paystack').snapshots().map((event) => event.get('secretKey'));
  }

  // Future<String> createAccessCode(String secretKey, String emailaddress, int amount, String ref) async{
    
  //   Map<String, String> headers = {                           
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $secretKey '};
    
  //   Map data = {"amount": amount, "email": emailaddress, "reference": ref};
  //   String payload = json.encode(data);

  //   http.Response response = await http.post(
  //     Uri.parse('https://api.paystack.co/transaction/initialize'),
  //     headers: headers,
  //     body: payload
  //   );

  //   if (response.statusCode == 200) {
  //     final x = jsonDecode(response.body);
  //     return x['data']['access_code'];
  //   } else {
  //     throw 'operation "getAccessCode" failed';
  //   }
  // }
  
}