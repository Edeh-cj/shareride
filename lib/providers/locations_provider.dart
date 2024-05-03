import 'package:dart_casing/dart_casing.dart';
import 'package:flutter/material.dart';
import 'package:shareride/models/location.dart';
import 'package:shareride/models/region_location.dart';

import '../Repositories/location_repository.dart';

class LocationsProvider with ChangeNotifier {
  final _repository = LocationRepository();
  List<Location> locations = [];

  Set<String> get regions {
    Set<String> r = {};
    for (var element in locations) {
      r.add(Casing.titleCase(element.region));
    }
    return r;
  }

  List<RegionLocation> get locationByRegion {
    Set<String> regions = {};
    List<RegionLocation> x = [];
    for (var element in locations) {
      regions.add(element.region);
    }
    for (var r in regions) {
      x.add(
        RegionLocation(
          region: r, 
          locations: locations.where((element) => element.region.toLowerCase() == r.toLowerCase() ).toList()
        )
      );
    }
    return x;
  }

  beginStreamLocations(){
    _repository.streamLocations().listen((event) {
      List locs = event['locations'];
      locations = locs.map((e) => Location.fromFirestore(e)).toList();

      notifyListeners();
    });
  }

}