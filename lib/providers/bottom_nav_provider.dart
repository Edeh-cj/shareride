import 'package:flutter/material.dart';

class BottomNavProvider with ChangeNotifier {
  int index = 0;
  
  update(int newValue){
    index = newValue;
    notifyListeners();
  }
  
}