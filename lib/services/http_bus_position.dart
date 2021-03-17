import 'package:emddibus/models/bus_position_model.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

const String path = '/tracking/';

Future<void> listenBusPosition() async {
  final response = await rootBundle
      .loadString(URL + path + TRACKING_REQUEST.toString() + '.json');
  //TRACKING_REQUEST++;
  var result = listBusPositionFromJson(response);
  BUS_POSITION = result.listBusPosition;
  print(TRACKING_REQUEST);
  print(BUS_POSITION[0].nextPoint);
}
