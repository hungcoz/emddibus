import 'package:emddibus/models/bus_path_model.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/BusPath/bus_information.dart';
import 'package:emddibus/pages/Map/map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:latlong/latlong.dart';

import '../../constants.dart';
import 'list_name_bus_stop.dart';

class ShowBusPath extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShowBusPathState();
  final BusRoute busRoute;

  ShowBusPath({this.busRoute});
}

class ShowBusPathState extends State<ShowBusPath>
    with SingleTickerProviderStateMixin {
  MapController mapController = MapController();

  List<Marker> markers = [];
  List<LatLng> listPoint = [];
  List<StopPoint> listStopPointRoute = [];

  Color color = Colors.green;

  AnimationController animationController;

  double heightMap = 0;
  double fabPositionPadding = 10;
  double animate = 0;
  double contextSize = 0;

  // IconData _icon = Icons.arrow_downward_outlined;

  getPointOfPath(List<PointOfBusPath> listPointOfBusPath) {
    listPoint.clear();
    listPointOfBusPath.forEach((element) {
      listPoint.add(LatLng(element.latitude, element.longitude));
    });
  }

  getStopPoint(List<dynamic> listStopPoint) {
    listStopPointRoute.clear();
    listStopPoint.forEach((point) {
      STOP_POINT.forEach((element) {
        if (element.stopId == point) {
          listStopPointRoute.add(element);
          markers.add(Marker(
              width: 50,
              height: 50,
              point: LatLng(element.latitude, element.longitude),
              builder: (context) => _buildMarker()));
        }
        markers.add(Marker());
      });
    });
  }

  @override
  void initState() {
    getPointOfPath(BUS_PATH_GO);
    getStopPoint(widget.busRoute.listStopPointGo);
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tuyến " + widget.busRoute.routeId.toString()),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: animationController,
              builder: (_, child) {
                return Container(
                  // color: Colors.redAccent,
                  height: heightMap + animationController.value * animate,
                  child: child,
                );
              },
              child: Map(
                mapController: mapController,
                initialCamera: LatLng(listStopPointRoute[0].latitude,
                    listStopPointRoute[0].longitude),
                initialZoom: 16,
                markers: markers,
                listPoint: listPoint,
                color: color,
              ),
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (_, child) {
                return Transform.translate(
                  offset: Offset(0, animationController.value * animate),
                  child: child,
                );
              },
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

  Widget _buildMarker() {
    return Container(
      child: IconButton(
        icon: Image.asset('assets/stop_point.png'),
        onPressed: () {},
      ),
    );
  }
}
