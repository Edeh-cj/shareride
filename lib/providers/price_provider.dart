import 'package:flutter/material.dart';
import 'package:shareride/Repositories/price_repository.dart';

class PriceProvider with ChangeNotifier {
  final repository = PriceRepository();

  int seatPrice = 0;

  beginStreamPrice (String uid){
    repository.streamPrice(uid).listen((event) {
      seatPrice = event;
      notifyListeners();
    });
  }
}