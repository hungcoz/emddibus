import 'package:emddibus/models/bus_path_model.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/BusPath/bus_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
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

  List<Marker> markers = [];

  List<LatLng> listPoint = [];

  List<StopPoint> listStopPointRoute = [];

  Color color = Colors.green;

  double widgetHeight = 0;
  double dragScrollSheetExtent = 0;
  double fabPosition = 0;
  double fabPositionPadding = 10;

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
              height: MediaQuery.of(context).size.height - fabPosition,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  maxZoom: 18,
                  center: LatLng(listPoint[0].latitude, listPoint[0].longitude),
                  onTap: (_) {},
                  zoom: 16,
                  plugins: [
                    LocationPlugin(),
                  ],
                  interactiveFlags:
                      InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  PolylineLayerOptions(polylines: [
                    Polyline(
                      color: color,
                      strokeWidth: 5,
                      points: listPoint,
                    ),
                  ]),
                  MarkerLayerOptions(markers: markers),
                  LocationOptions(
                      markers: markers,
                      onLocationUpdate: (LatLngData ld) {},
                      onLocationRequested: (LatLngData ld) {},
                      buttonBuilder: (context,
                          ValueNotifier<LocationServiceStatus> status,
                          Function onPressed) {
                        return Container();
                      }),
                ],
              ),
            ),
            Positioned(
              bottom: fabPosition + fabPositionPadding,
              right: fabPositionPadding,
              child: FloatingActionButton(
                onPressed: () {
                  if (currentPosition == null) return;
                  mapController?.move(currentPosition, 16);
                },
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.my_location,
                  color: Colors.black,
                ),
              ),
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

  Widget _buildMarker() {
    return Container(
      child: IconButton(
        icon: Image.asset('assets/stop_point.png'),
        onPressed: () {},
      ),
    );
  }
}
