import 'dart:convert';

class StopPoint {
  int stopId;
  String name;
  double latitude, longitude;

  StopPoint({this.stopId, this.name, this.latitude, this.longitude});

  factory StopPoint.fromJson(dynamic json) => StopPoint(
    stopId: int.parse(json['stop_id']),
    name: json['name'],
    latitude: double.parse(json['latitude']),
    longitude: double.parse(json['longitude'])
  );
}

class ListStopPoint {
  int code;
  String message;
  List<StopPoint> listStopPoint;

  ListStopPoint({this.code, this.message, this.listStopPoint});

  factory ListStopPoint.fromJson(Map<String, dynamic> json) {
    if(json['code'] == 0) {
      var data = json['list_stop_point'] as List;
      List<StopPoint> _listStopPoint = data.map((e) => StopPoint.fromJson(e)).toList();
      return ListStopPoint(
        code: json['code'],
        message: json['message'],
        listStopPoint: _listStopPoint
      );
    }
    else {
      throw Exception(json['message']);
    }
  }
}

ListStopPoint listStopPointFromJson(String str) => ListStopPoint.fromJson(json.decode(str));
