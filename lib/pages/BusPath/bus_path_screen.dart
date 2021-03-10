import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/BusPath/bus_information.dart';
import 'package:emddibus/pages/Home/stop_point_marker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:latlong/latlong.dart';

import '../../constants.dart';

class ShowBusPath extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShowBusPathState(routeId: routeId);
  final String routeId;

  ShowBusPath({this.routeId});
}

class ShowBusPathState extends State<ShowBusPath> {
  final String routeId;

  ShowBusPathState({this.routeId});

  MapController mapController = MapController();

  List<Marker> markersDeparter = [];
  List<Marker> markersReturn = [];
  List<Marker> markers = [];

  List<LatLng> listPointDeparter = [];
  List<LatLng> listPointReturn = [];
  List<LatLng> listPoint = [];

  List<dynamic> listIdStopPointDeparter = [];
  List<dynamic> listIdStopPointReturn = [];

  List<StopPoint> listStopPointDeparter = [];
  List<StopPoint> listStopPointReturn = [];
  List<StopPoint> listStopPoint = [];

  Color color = Colors.green;

  void getPointOfPath() {
    BUS_PATH_GO.forEach((element) {
      listPointDeparter.add(LatLng(element.latitude, element.longitude));
    });
    BUS_PATH_RETURN.forEach((element) {
      listPointReturn.add(LatLng(element.latitude, element.longitude));
    });
  }

  void getIdStopPoint() {
    BUS_ROUTE.forEach((element) {
      if (element.routeId.toString() == routeId) {
        listIdStopPointDeparter = element.listStopPointGo;
        listIdStopPointReturn = element.listStopPointReturn;
      }
    });
  }

  void getStopPointGo() {
    listIdStopPointDeparter.forEach((point) {
      STOP_POINT.forEach((element) {
        if (element.stopId == point) {
          listStopPointDeparter.add(element);
          markersDeparter.add(Marker(
              width: 50,
              height: 50,
              point: LatLng(element.latitude, element.longitude),
              builder: (context) =>
                  StopPointMarker(
                    stopPoint: element,
                    mapController: mapController,
                  )));
        }
        markersDeparter.add(Marker());
      });
    });
  }

  void getStopPointReturn() {
    listIdStopPointReturn.forEach((point) {
      STOP_POINT.forEach((element) {
        if (element.stopId == point) {
          listStopPointReturn.add(element);
          markersReturn.add(Marker(
              width: 50,
              height: 50,
              point: LatLng(element.latitude, element.longitude),
              builder: (context) =>
                  _buildMarker()
          ));
        }
      });
      markersReturn.add(Marker());
    });
  }

  @override
  void initState() {
    getPointOfPath();
    getIdStopPoint();
    getStopPointGo();
    getStopPointReturn();
    listPoint = listPointDeparter;
    markers = markersDeparter;
    listStopPoint = listStopPointDeparter;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Tuyến " + routeId.toString()),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                maxZoom: 18,
                center: LatLng(listPoint[0].latitude, listPoint[0].longitude),
                onTap: (_) {},
                zoom: 16,
                plugins: [
                  LocationPlugin(),
                ],
                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                    onLocationUpdate: (LatLngData ld) {
                      // setState(() {
                      //   currentPosition = ld.location;
                      // });
                    },
                    onLocationRequested: (LatLngData ld) {
                      // if (ld == null || ld.location == null) {
                      //   return;
                      // }
                      // mapController?.move(listPoint[0], 16);
                    },
                    buttonBuilder: (BuildContext context,
                        ValueNotifier<LocationServiceStatus> status,
                        Function onPressed) {
                      return Positioned(
                        bottom: 20,
                        right: 20,
                        child: FloatingActionButton(
                          child: ValueListenableBuilder<LocationServiceStatus>(
                            valueListenable: status,
                            builder:
                                (context, LocationServiceStatus value, child) {
                              switch (value) {
                                case LocationServiceStatus.disabled:
                                case LocationServiceStatus.permissionDenied:
                                case LocationServiceStatus.unsubscribed:
                                  return Icon(
                                    Icons.location_disabled,
                                    color: Colors.black,
                                  );
                                  break;
                                default:
                                  return Icon(
                                    Icons.my_location,
                                    color: Colors.black,
                                  );
                                  break;
                              }
                            },
                          ),
                          onPressed: () {
                            if (currentPosition == null) return;
                            mapController?.move(currentPosition, 16);
                          },
                          backgroundColor: Colors.white,
                        ),
                      );
                    }),
              ],
            ),
            BusInformation(
              showBusPathState: this,
              routeId: routeId,
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
        onPressed: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => StopPointDetail(stopPoint)));
        },
      ),
    );
  }
}
