import 'dart:async';
import 'dart:core';

import 'package:emddibus/GGMap/geolocator_service.dart';

import 'package:emddibus/models/bus_path_model.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/BusPath/bus_information.dart';
import 'package:emddibus/pages/Loading/loading_dialog.dart';
import 'package:emddibus/pages/Map/map.dart';
import 'package:emddibus/pages/Tracking/tracking_bus.dart';
import 'package:emddibus/services/http_bus_position.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../../constants.dart';

class ShowBusPath extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShowBusPathState();
  final BusRoute busRoute;

  ShowBusPath({this.busRoute});
}

class ShowBusPathState extends State<ShowBusPath> {
  MapController mapController = MapController();
  ScrollController scrollController = ScrollController();

  List<Marker> markers = [];
  List<LatLng> listPoint = [];
  List<StopPoint> listStopPointRoute = [];

  Color color = Colors.green;

  AnimationController animationController;

  double heightMap = 0;
  double fabPositionPadding = 10;
  double animate = 0;
  double contextSize = 0;

  double widgetHeight = 0;
  double dragScrollSheetExtent = 0;
  double fabPosition = 0;

  final geoService = GeolocatorService();

  double height = 0, two = 0, one = 0;
  double twoFixed = 0, oneFixed = 0;
  Duration _duration = Duration(milliseconds: 1);
  bool _bottom = false;

  void toggleTop() {
    _bottom = !_bottom;
    Timer.periodic(_duration, (timer) {
      if (_bottom) one -= 2;
      else one += 2;

      if (one >= 0) {
        one = 0;
        timer.cancel();
      }
      if (one <= oneFixed) {
        one = oneFixed;
        timer.cancel();
      }
      setState(() {});
    });
  }

  void toggleBottom(IconData iconData) {
    _bottom = !_bottom;
    Timer.periodic(_duration, (timer) {
      if (_bottom) two += 2;
      else two -= 2;

      if (two <= CONTEXT_SIZE*0.5) {
        two = CONTEXT_SIZE*0.5;
        timer.cancel();
      }
      if (two >= CONTEXT_SIZE*0.92) {
        two = CONTEXT_SIZE*0.92;
        timer.cancel();
      }
      setState(() {
        if (two >= CONTEXT_SIZE*0.75)
          iconData = Icons.arrow_upward;
        if (two <= CONTEXT_SIZE*0.75)
          iconData = Icons.arrow_downward;
      });
    });
  }

  getPointOfPath(List<PointOfBusPath> listPointOfBusPath) {
    listPoint.clear();
    listPointOfBusPath.forEach((element) {
      listPoint.add(LatLng(element.latitude, element.longitude));
    });
  }

  getStopPoint(List<dynamic> listStopPoint) {
    listStopPointRoute.clear();
    markers.clear();
    listStopPoint.forEach((point) {
      STOP_POINT.forEach((element) {
        if (element.stopId == point) {
          listStopPointRoute.add(element);
          markers.add(Marker(
              width: 50,
              height: 50,
              point: LatLng(element.latitude, element.longitude),
              builder: (context) => _buildMarker(element)));
        }
      });
    });
    markers.add(Marker());
  }

  @override
  void initState() {
    CHECK_UP_DOWN = 0;
    getPointOfPath(BUS_PATH_GO);
    getStopPoint(widget.busRoute.listStopPointGo);
    height = CONTEXT_SIZE*0.5;
    two = height;
    one = - height;
    twoFixed = height;
    oneFixed = height;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tuyến " + widget.busRoute.routeId.toString()),
      ),
      body: Container(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: (two - CONTEXT_SIZE)*0.5,
              height: CONTEXT_SIZE,
              child: Container(
                // height: contextSize - fabPosition,
                child: Map(
                  mapController: mapController,
                  initialCamera: LatLng(listStopPointRoute[0].latitude,
                      listStopPointRoute[0].longitude),
                  initialZoom: 16,
                  markers: markers,
                  color: color,
                  listPoint: listPoint,
                ),
                // child: GGMap(initialPosition: Position(latitude: currentPosition.latitude, longitude: currentPosition.longitude),),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: two,
              height: height,
              child: BusInformation(
                showBusPathState: this,
                busRoute: widget.busRoute,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarker(StopPoint stopPoint) {
    return Container(
      child: IconButton(
        icon: Image.asset('assets/stop_point.png'),
        onPressed: () async {
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
  }
}
