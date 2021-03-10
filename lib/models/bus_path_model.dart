import 'dart:convert';

class PointOfBusPath {
  double latitude, longitude;

  PointOfBusPath({this.latitude, this.longitude});

  factory PointOfBusPath.fromJson(dynamic json) => PointOfBusPath(
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']));
}

class ListPointOfBusPath {
  int routeId;
  List<PointOfBusPath> listPointOfDirectionFGo;
  List<PointOfBusPath> listPointOfDirectionFReturn;

  ListPointOfBusPath(
      {this.routeId,
      this.listPointOfDirectionFGo,
      this.listPointOfDirectionFReturn});

  factory ListPointOfBusPath.fromJson(Map<String, dynamic> json) {
    var listPointOfDirectionFGo = json['direction_go'] as List;
    var listPointOfDirectionFReturn = json['direction_return'] as List;
    List<PointOfBusPath> _listPointOfDirectionFGo =
        listPointOfDirectionFGo.map((e) => PointOfBusPath.fromJson(e)).toList();
    List<PointOfBusPath> _listPointOfDirectionFReturn =
        listPointOfDirectionFReturn
            .map((e) => PointOfBusPath.fromJson(e))
            .toList();
    return ListPointOfBusPath(
        routeId: int.parse(json['route_id']),
        listPointOfDirectionFGo: _listPointOfDirectionFGo,
        listPointOfDirectionFReturn: _listPointOfDirectionFReturn);
  }
}

ListPointOfBusPath listPointOfPathFromJson(String str) =>
    ListPointOfBusPath.fromJson(json.decode(str));
