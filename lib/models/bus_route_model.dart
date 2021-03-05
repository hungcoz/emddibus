import 'dart:convert';

class BusRoute {
  int routeId;
  String name;
  List<dynamic> listStopPointGo;
  List<dynamic> listStopPointReturn;

  BusRoute(
      {this.routeId,
      this.name,
      this.listStopPointGo,
      this.listStopPointReturn});

  factory BusRoute.fromJson(dynamic json) => BusRoute(
      routeId: int.parse(json['route_id']),
      name: json['name'],
      listStopPointGo: json['list_stop_point_0'],
      listStopPointReturn: json['list_stop_point_1']);
}

class ListBusRoutes {
  int code;
  String message;
  List<BusRoute> listBusRoutes;

  ListBusRoutes({this.code, this.message, this.listBusRoutes});

  factory ListBusRoutes.fromJson(Map<String, dynamic> json) {
    if (json['code'] == 0) {
      var data = json['list_routes'] as List;
      List<BusRoute> _listBusRoutes =
          data.map((e) => BusRoute.fromJson(e)).toList();
      return ListBusRoutes(
          code: json['code'],
          message: json['message'],
          listBusRoutes: _listBusRoutes);
    } else
      throw Exception(json['message']);
  }
}

ListBusRoutes listBusRoutesFromJson(String str) =>
    ListBusRoutes.fromJson(json.decode(str));
