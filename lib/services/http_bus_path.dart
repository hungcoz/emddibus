import 'package:emddibus/models/bus_path_model.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

Future<void> getBusPathData(int routeId) async {
  String id = routeId.toString();
  final response = await rootBundle.loadString(URL + '/polyline/route_' + id + '.json');
  var result = listPointOfPathFromJson(response);
  BUS_PATH = result.listPoint;
}