import 'package:emddibus/constants.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:flutter/services.dart';

const String path = '/api_stop_point.json';

Future<void> getStopPointData() async{
  final response = await rootBundle.loadString(URL + path);
  var result = listStopPointFromJson(response);
  STOP_POINT = result.listStopPoint;
}