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

  void fetchData(BusPosition busPosition) {
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
              height: 60,
              width: 60,
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
        height: 60,
        width: 60,
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
      fetchData(widget.busPosition);
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
      body: Stack(
        children: [
          Map(
            mapController: mapController,
            // initialCamera: widget.busPosition.getPosition(),
            // initialZoom: 16,
            bounds: LatLngBounds(widget.busPosition.getPosition(),
                LatLng(widget.stopPoint.latitude, widget.stopPoint.longitude)),
            markers: markers,
            listPoint: listPoint,
            color: Colors.blue,
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: null,
              child: Icon(
                Icons.directions_bus,
                color: Colors.black,
              ),
              onPressed: () => mapController.fitBounds(
                  LatLngBounds(
                      bus.getPosition(),
                      LatLng(widget.stopPoint.latitude,
                          widget.stopPoint.longitude)),
                  options: FitBoundsOptions(padding: EdgeInsets.all(50))),
              backgroundColor: Colors.white70,
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ]),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    child: Image.asset(
                      'assets/bus_icon.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Tuyến số ${widget.busRoute.routeId}   ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: (bus.direction == 0)
                                  ? '(Chiều đi)'
                                  : '(Chiều về)',
                              style: TextStyle(
                                  color: (bus.direction == 0)
                                      ? Colors.green
                                      : Colors.redAccent,
                                  fontStyle: FontStyle.italic)),
                        ]),
                      ),
                      Text(widget.busRoute.name),
                      Text('Biển số: ${bus.busId}'),
                      Text(
                        'Khoảng cách: ' +
                            calculateDistance(
                                    bus.getPosition(),
                                    LatLng(widget.stopPoint.latitude,
                                        widget.stopPoint.longitude))
                                .toStringAsFixed(2)
                                .toString() +
                            ' km',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
