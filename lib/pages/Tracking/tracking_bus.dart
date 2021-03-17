import 'dart:async';

import 'package:emddibus/algothrim/function.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/bus_position_model.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:latlong/latlong.dart';
import 'package:emddibus/models/stop_point_model.dart';
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
  List<BusRoute> _listBusRoute = [];
  List<int> _listDirection = [];

  bool isPassed(int point, int nextPoint, List<dynamic> listPoint) {
    int pointIndex = -1;
    int nextPointIndex = listPoint.length + 1;
    for (int i = 0; i < listPoint.length; i++) {
      if (point == listPoint[i]) {
        pointIndex = i;
      }
      if (nextPoint == listPoint[i]) {
        nextPointIndex = i;
      }
    }
    if (pointIndex >= nextPointIndex)
      return true;
    else
      return false;
  }

  void filterRoute(StopPoint stopPoint) {
    _listBusPosition.clear();
    _listBusRoute.clear();
    _listDirection.clear();
    BUS_POSITION.forEach((bus) {
      BUS_ROUTE.forEach((route) {
        if (bus.routeId == route.routeId &&
            isPassed(
                stopPoint.stopId,
                bus.nextPoint,
                ((bus.direction == 0)
                    ? route.listStopPointGo
                    : route.listStopPointReturn))) {
          _listBusPosition.add(bus);
          _listBusRoute.add(route);
        }
      });
      _listDirection.add(bus.direction);
    });
    setState(() {
      TRACKING_REQUEST++;
    });
    // _listBusPosition.sort((a, b) => calculateDistance(
    //         LatLng(a.latitude, a.longitude),
    //         LatLng(widget.stopPoint.latitude, widget.stopPoint.longitude))
    //     .compareTo(calculateDistance(LatLng(b.latitude, b.longitude),
    //         LatLng(widget.stopPoint.latitude, widget.stopPoint.longitude))));
  }

  Timer t;

  @override
  void initState() {
    filterRoute(widget.stopPoint);
    t = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      await listenBusPosition();
      filterRoute(widget.stopPoint);

      print("count" + _listBusPosition.length.toString());
    });
    super.initState();
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.stopPoint.name),
          centerTitle: true,
        ),
        body: Scrollbar(
            child: ListView.builder(
          itemCount: _listBusPosition.length,
          itemBuilder: (context, index) => _buildCard(context, index),
        )));
  }

  Widget _buildCard(BuildContext context, int index) {
    BusPosition busPosition = _listBusPosition[index];
    BusRoute busRoute = _listBusRoute[index];
    String direction = (_listDirection[index] == 0) ? 'Chiều đi' : 'Chiều về';
    Color directionColor =
        (_listDirection[index] == 0) ? Colors.green : Colors.redAccent;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      child: Card(
        child: ListTile(
          onTap: () {},
          leading: CircleAvatar(
            child: Text(
              '${busRoute.routeId}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            backgroundColor: Color(0xffeeac24),
          ),
          title: RichText(
            text: TextSpan(
                text: busRoute.name,
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                      text: ' ($direction)',
                      style: TextStyle(
                          color: directionColor, fontStyle: FontStyle.italic))
                ]),
          ),
          subtitle: Text('Khoảng cách: ' +
              calculateDistance(
                      LatLng(busPosition.latitude, busPosition.longitude),
                      LatLng(widget.stopPoint.latitude,
                          widget.stopPoint.longitude))
                  .toStringAsFixed(2)
                  .toString() +
              ' km'),
        ),
      ),
    );
  }
}
