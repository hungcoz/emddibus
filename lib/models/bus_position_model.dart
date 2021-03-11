import 'dart:convert';

class BusPosition {
  int busId;
  int routeId;
  int direction;
  double latitude;
  double longitude;
  double heading;
  int nextPoint;

  BusPosition(
      {this.busId,
      this.routeId,
      this.direction,
      this.latitude,
      this.longitude,
      this.heading,
      this.nextPoint});

  factory BusPosition.fromJson(dynamic json) => BusPosition(
      busId: int.parse(json['bus_id']),
      routeId: int.parse(json['route_id']),
      direction: int.parse(json['direction']),
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      heading: double.parse(json['heading']),
      nextPoint: int.parse(json['next_point']));
}

class ListBusPosition {
  int code;
  String message;
  List<BusPosition> listBusPosition;

  ListBusPosition({this.code, this.message, this.listBusPosition});

  factory ListBusPosition.fromJson(Map<String, dynamic> json) {
    if (json['code'] == 0) {
      var data = json['list_bus_position'] as List;
      List<BusPosition> _listBusPosition =
          data.map((e) => BusPosition.fromJson(e)).toList();
      return ListBusPosition(
          code: json['code'],
          message: json['message'],
          listBusPosition: _listBusPosition);
    } else {
      throw Exception(json['message']);
    }
  }
}

ListBusPosition listBusPositionFromJson(String str) =>
    ListBusPosition.fromJson(json.decode(str));
