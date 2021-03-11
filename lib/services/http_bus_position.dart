import 'package:emddibus/models/bus_position_model.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

const String path = '/tracking/';

Future<void> listenBusPosition() async {
  final response = await rootBundle
      .loadString(URL + path + TRACKING_REQUEST.toString() + '.json');
  var result = listBusPositionFromJson(response);
  BUS_POSITION = result.listBusPosition;
}
