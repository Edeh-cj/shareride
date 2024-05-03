

import 'package:equatable/equatable.dart';

class Location extends Equatable{
  final String name, region;
  final bool isRoute, isInsideSchool;
  final int? price;

  const Location({required this.name, required this.region, required this.isRoute, required this.isInsideSchool, required this.price});
  Location.fromFirestore(Map data):
    name = data['name'],
    region = data['region'],
    isRoute = data['isroute'],
    isInsideSchool = data['isinsideschool'],
    price = data['price'];

  @override
  List<Object?> get props => [
    name,
    region,
    isRoute,
    isInsideSchool,
    price
  ];
  
}