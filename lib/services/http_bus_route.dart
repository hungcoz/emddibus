import 'package:emddibus/constants.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:flutter/services.dart';

const String path = '/api_routes.json';

Future<void> getBusRouteData() async {
  final response = await rootBundle.loadString(URL + path);
  var result = listBusRoutesFromJson(response);
  BUS_ROUTE = result.listBusRoutes;
}
