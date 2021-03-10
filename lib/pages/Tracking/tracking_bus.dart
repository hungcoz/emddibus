import 'package:emddibus/algothrim/function.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/bus_position_model.dart';
import 'package:latlong/latlong.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/Tracking/list_tracking.dart';
import 'package:emddibus/services/http_bus_position.dart';
import 'package:flutter/material.dart';

class Tracking extends StatefulWidget {
  final StopPoint stopPoint;

  Tracking({this.stopPoint});

  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  List<BusPosition> _listBusPosition = [];

  Future<void> filterRoute(StopPoint stopPoint) async {
    await listenBusPosition();
    _listBusPosition.clear();
    BUS_POSITION.forEach((bus) {
      if (bus.nextPoint == stopPoint.stopId) {
        _listBusPosition.add(bus);
      }
    });
    _listBusPosition.sort((a, b) => calculateDistance(
            LatLng(a.latitude, a.longitude),
            LatLng(widget.stopPoint.latitude, widget.stopPoint.longitude))
        .compareTo(calculateDistance(LatLng(b.latitude, b.longitude),
            LatLng(widget.stopPoint.latitude, widget.stopPoint.longitude))));
  }

  @override
  void initState() {
    filterRoute(widget.stopPoint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stopPoint.name),
        centerTitle: true,
      ),
      body: ListTracking(
          stopPoint: widget.stopPoint, listBusPosition: _listBusPosition),
    );
  }
}
