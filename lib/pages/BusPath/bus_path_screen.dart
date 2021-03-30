import 'package:emddibus/GGMap/geolocator_service.dart';
import 'package:emddibus/GGMap/ggmap.dart';

// import 'package:emddibus/GGMap/ggmap.dart';
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
import 'package:geolocator/geolocator.dart';

// import 'package:flutter_map_location/flutter_map_location.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
// import 'package:provider/provider.dart';

import '../../constants.dart';

class ShowBusPath extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShowBusPathState();
  final BusRoute busRoute;

  ShowBusPath({this.busRoute});
}

class ShowBusPathState extends State<ShowBusPath>
    with SingleTickerProviderStateMixin {
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
              width: 60,
              height: 60,
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
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
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
            Container(
              height: contextSize - fabPosition,
              // child: Map(
              //   mapController: mapController,
              //   initialCamera: LatLng(listStopPointRoute[0].latitude,
              //       listStopPointRoute[0].longitude),
              //   initialZoom: 16,
              //   markers: markers,
              //   color: color,
              //   listPoint: listPoint,
              // ),
              child: GGMap(initialPosition: Position(latitude: currentPosition.latitude, longitude: currentPosition.longitude),),
            ),
            BusInformation(
              showBusPathState: this,
              busRoute: widget.busRoute,
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
