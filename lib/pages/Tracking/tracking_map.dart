import 'dart:async';
import 'dart:math';

import 'package:emddibus/algothrim/calculate_distance.dart';
import 'package:emddibus/algothrim/is_passed_bus.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/bus_path_model.dart';
import 'package:emddibus/models/bus_position_model.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/Map/map.dart';
import 'package:emddibus/pages/Tracking/passed_dialog.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';

class TrackingMap extends StatefulWidget {
  final BusPosition busPosition;
  final StopPoint stopPoint;
  final BusRoute busRoute;

  TrackingMap({this.busPosition, this.stopPoint, this.busRoute});

  @override
  _TrackingMapState createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  MapController mapController = MapController();
  List<LatLng> listPoint = [];
  List<Marker> markers = [];

  BusPosition bus;
  Timer t;

  void fechtData(BusPosition busPosition) {
    BUS_POSITION.forEach((element) async {
      if (busPosition.busId == element.busId &&
          busPosition.direction == element.direction &&
          isPassed(
              widget.stopPoint.stopId,
              element.nextPoint,
              (widget.busPosition.direction == 0)
                  ? widget.busRoute.listStopPointGo
                  : widget.busRoute.listStopPointReturn)) {
        setState(() {
          bus = element;
          markers[3] = Marker(
              height: 50,
              width: 50,
              point: bus.getPosition(),
              builder: (context) => IconButton(
                  icon: Transform.rotate(
                      angle: bus.heading * -pi / 180,
                      child: Image.asset('assets/bus.png')),
                  onPressed: () {}));
        });
        return;
      } else {
        t.cancel();
        await showDialog(
            context: context,
            builder: (BuildContext context) => PassedDialog());
        Navigator.pop(context);
      }
    });
  }

  getPointOfPath(List<PointOfBusPath> listPointOfBusPath) {
    listPoint.clear();
    listPointOfBusPath.forEach((element) {
      listPoint.add(LatLng(element.latitude, element.longitude));
    });
  }

  getMarker(List<dynamic> listStopPoint) {
    STOP_POINT.forEach((point) {
      if (point.stopId == listStopPoint[0] ||
          point.stopId == listStopPoint[listStopPoint.length - 1]) {
        markers.add(Marker(
          height: 50,
          width: 50,
          point: LatLng(point.latitude, point.longitude),
          builder: (context) => Container(
            child: IconButton(
              icon: Image.asset('assets/stop_point.png'),
              onPressed: () {},
            ),
          ),
        ));
      }
    });
    markers.add(Marker(
      width: 50,
      height: 50,
      point: LatLng(widget.stopPoint.latitude, widget.stopPoint.longitude),
      builder: (context) => Container(
        child: IconButton(
          icon: Image.asset('assets/stop_point.png'),
          onPressed: () {},
        ),
      ),
    ));
    markers.add(Marker(
        height: 50,
        width: 50,
        point: bus.getPosition(),
        builder: (context) => IconButton(
            icon: Transform.rotate(
                angle: bus.heading * -pi / 180,
                child: Image.asset('assets/bus.png')),
            onPressed: () {})));
    markers.add(Marker());
  }

  @override
  void initState() {
    bus = widget.busPosition;
    getMarker((widget.busPosition.direction == 0)
        ? widget.busRoute.listStopPointGo
        : widget.busRoute.listStopPointReturn);
    getPointOfPath(
        (widget.busPosition.direction == 0) ? BUS_PATH_GO : BUS_PATH_RETURN);
    t = Timer.periodic(Duration(seconds: 1), (Timer t) {
      fechtData(widget.busPosition);
      print(bus.heading);
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
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                Map(
                  mapController: mapController,
                  initialCamera: LatLng(widget.busPosition.latitude,
                      widget.busPosition.longitude),
                  initialZoom: 16,
                  markers: markers,
                  listPoint: listPoint,
                  color: Colors.blue,
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: FloatingActionButton(
                    heroTag: null,
                    child: Icon(Icons.directions_bus, color: Colors.black,
                    ),
                    onPressed: () => mapController.move(bus.getPosition(), 16),
                    backgroundColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Text(widget.busPosition.busId.toString()),
                Text(widget.busRoute.name),
                Text('Khoảng cách: ' +
                    calculateDistance(
                            LatLng(bus.latitude, bus.longitude),
                            LatLng(widget.stopPoint.latitude,
                                widget.stopPoint.longitude))
                        .toStringAsFixed(2)
                        .toString() +
                    ' km')
              ],
            ),
          )
        ],
      ),
    );
  }
}
