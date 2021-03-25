import 'package:emddibus/algothrim/calculate_distance.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/Loading/loading_dialog.dart';
import 'package:emddibus/pages/Tracking/tracking_bus.dart';
import 'package:emddibus/services/http_bus_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class StopPointMarker extends StatelessWidget {
  final StopPoint stopPoint;
  final MapController mapController;

  StopPointMarker({Key key, this.stopPoint, this.mapController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (calculateDistance(mapController.center,
            LatLng(stopPoint.latitude, stopPoint.longitude)) <=
        1) {
      return Container(
        child: IconButton(
          icon: Image.asset('assets/stop_point.png'),
          onPressed: () async {
            print(stopPoint.stopId);
            showDialog(
                context: context,
                builder: (BuildContext context) => LoadingDialog());
            await listenBusPosition();
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Tracking(stopPoint: stopPoint)));
          },
        ),
      );
    } else
      return Container();
  }
}
