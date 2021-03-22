import 'dart:convert';

import 'package:emddibus/pages/Home/convert_post_code.dart';
import 'package:flutter/cupertino.dart';

class LocationModel {
  String building;
  String road;
  String village;
  String town;
  String suburb;
  String county;
  String state;
  String postCode;
  String countryCode;
  double lat, long;

  LocationModel({this.building, this.road, this.village, this.town,
    this.suburb, this.county,this.state, this.postCode, this.countryCode, this.lat, this.long});

  factory LocationModel.fromJson(dynamic json) => LocationModel(
      building: json['address']['building'] != null ? json['address']['building'] : null,
      road: json['address']['road'] != null ? json['address']['road'] : null,
      village: json['address']['village'] != null ? json['address']['village'] : null,
      town: json['address']['town'] != null ? json['address']['town'] : null,
      suburb: json['address']['suburb'] != null ? json['address']['suburb'] : null,
      county: json['address']['county'] != null ? json['address']['county'] : null,
      state: json['address']['state'] != null ? json['address']['state'] : null,
      postCode: json['address']['postcode'],
      countryCode: json['address']['country_code'],
      lat: double.parse(json['lat']),
      long: double.parse(json['lon'])
  );
}
class ListLocation {
  List<LocationModel> listLocation;

  factory ListLocation.fromJson(dynamic json){
    var list = json as List;
    List<LocationModel> _listLocation =
        list.map((e) => LocationModel.fromJson(e)).toList();
    List<LocationModel> _listLocationTmp = [];
    _listLocation.forEach((element) {
      if(element.countryCode.contains('vn')){
        // element.postCode = convertPostCode(int.parse(element.postCode));
        _listLocationTmp.add(element);
      }
    });
    return ListLocation(
      listLocation: _listLocationTmp
    );
  }

  ListLocation({this.listLocation});
}

ListLocation listLocationFromJson(String str) =>
    ListLocation.fromJson(json.decode(str));