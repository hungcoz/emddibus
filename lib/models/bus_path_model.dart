import 'dart:convert';

class PointOfBusPath {
  double latitude, longitude;

  PointOfBusPath({this.latitude, this.longitude});

  factory PointOfBusPath.fromJson(dynamic json) => PointOfBusPath(
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude'])
  );
}
class ListPointOfBusPath {
  int routeId;
  List<PointOfBusPath> listPoint;

  ListPointOfBusPath({this.routeId, this.listPoint});

  factory ListPointOfBusPath.fromJson(Map<String, dynamic> json) {
    var listPoint = json['direction_go'] as List;
    List<PointOfBusPath>_listPoint = listPoint.map((e) => PointOfBusPath.fromJson(e)).toList();
    return ListPointOfBusPath(
      routeId: int.parse(json['route_id']),
        listPoint: _listPoint
    );
  }
}

ListPointOfBusPath listPointOfPathFromJson(String str) =>
    ListPointOfBusPath.fromJson(json.decode(str));