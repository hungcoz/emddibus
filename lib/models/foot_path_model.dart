import 'dart:convert';
import 'package:latlong/latlong.dart';

// class Coordinate {
//   double latitude;
//   double longitude;
//
//   Coordinate({this.latitude, this.longitude});
//
//   factory Coordinate.fromList(List<double> list) => Coordinate(
//         latitude: list[1],
//         longitude: list[0],
//       );
// }

class Geometry {
  List<LatLng> coordinates;

  Geometry({this.coordinates});

  factory Geometry.fromJson(dynamic json) {
    List<LatLng> _coordinates = [];
    List<List<double>> listCoor = List<List<double>>.from(json["coordinates"]
        .map((x) => List<double>.from(x.map((x) => x.toDouble()))));
    listCoor.forEach((list) {
      _coordinates.add(LatLng(list[1], list[0]));
    });
    return Geometry(coordinates: _coordinates);
  }
}

class Route {
  Geometry geometry;
  double distance;

  Route({this.geometry, this.distance});

  factory Route.fromJson(dynamic json) => Route(
      geometry: Geometry.fromJson(json["geometry"]),
      distance: json['distance'].toDouble());
}

class FootPath {
  String code;
  List<Route> routes;

  FootPath({this.code, this.routes});

  factory FootPath.fromJson(Map<String, dynamic> json) => FootPath(
        code: json["code"],
        routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
      );
}

FootPath footPathFromJson(String str) => FootPath.fromJson(json.decode(str));
