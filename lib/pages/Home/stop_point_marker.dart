import 'dart:math';

import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/StopPointDetails/stop_point_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class StopPointMarker extends StatelessWidget {
  final StopPoint stopPoint;
  final MapController mapController;

  StopPointMarker({Key key, this.stopPoint, this.mapController})
      : super(key: key);

  calculateDistance(LatLng pos1, LatLng pos2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((pos2.latitude - pos1.latitude) * p)/2 +
        cos(pos1.latitude * p) * cos(pos2.latitude * p) *
            (1 - cos((pos2.longitude - pos1.longitude) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    if (calculateDistance(mapController.center, LatLng(stopPoint.latitude, stopPoint.longitude)) <= 1) {
      return Container(
        child: IconButton(
          icon: Image.asset('assets/stop_point.png'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StopPointDetail(stopPoint)));
          },
        ),
      );
    } else
      return Container();
  }
}
