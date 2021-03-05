import 'dart:typed_data';

import 'package:emddibus/models/stop_point_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class StopPointMarker extends StatelessWidget {
  final StopPoint stopPoint;
  final MapController mapController;

  StopPointMarker(
      {Key key, this.stopPoint, this.mapController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mapController.zoom >= 13) {
      return Container(
        child: IconButton(
          icon: Image.asset('assets/stop_point.png'),
          onPressed: () {},
        ),
      );
    } else
      return Container();
  }
}
