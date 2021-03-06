import 'dart:math';

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
  List<Marker> markers = [];

  List<LatLng> _listPointGo = [];
  List<LatLng> _listPointReturn = [];

  List<dynamic> listStopPoint0 = [];
  List<dynamic> listStopPoint1 = [];

  void getPointOfPath() {
    BUS_PATH_GO.forEach((element) {
      _listPointGo.add(LatLng(element.latitude, element.longitude));
    });
    BUS_PATH_RETURN.forEach((element) {
      _listPointReturn.add(LatLng(element.latitude, element.longitude));
    });
  }

  @override
  void initState() {
    getPointOfPath();
    getStopPointMarker();
    getStopPointGo();
    getStopPointReturn();
    // TODO: implement initState
    super.initState();
  }

  void getStopPointMarker() {
    BUS_ROUTE.forEach((element) {
      if (element.routeId.toString() == routeId) {
        listStopPoint0 = element.listStopPointGo;
        listStopPoint1 = element.listStopPointReturn;
      }
    });
  }
  void getStopPointGo() {
    STOP_POINT.forEach((element) {
      listStopPoint0.forEach((point) {
        if (element.stopId == point) {
          markers.add(Marker(
            width: 50,
            height: 50,
            point: LatLng(element.latitude, element.longitude),
            builder: (context) => StopPointMarker(mapController: mapController,)
          ));
        }
      });
    });
  }
  void getStopPointReturn() {
    STOP_POINT.forEach((element) {
      listStopPoint1.forEach((point) {
        if (element.stopId == point) {
          markers.add(Marker(
              width: 50,
              height: 50,
              point: LatLng(element.latitude, element.longitude),
              builder: (context) => StopPointMarker(mapController: mapController,)
          ));
        }
      });
    });
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
                center: LatLng(_listPointGo[0].latitude, _listPointGo[0].longitude),
                onTap: (_){},
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
                MarkerLayerOptions(markers: markers),
                PolylineLayerOptions(
                    polylines: [
                      Polyline(
                        strokeWidth: 4,
                        points: _listPointGo,
                      ),
                      Polyline(
                        color: Colors.deepOrangeAccent,
                        strokeWidth: 4,
                        points: _listPointReturn,
                      )
                    ]
                ),
                LocationOptions(
                    markers: markers,
                    onLocationUpdate: (LatLngData ld) {
                      setState(() {
                        currentPosition = ld.location;
                      });
                    },
                    onLocationRequested: (LatLngData ld) {
                      if (ld == null || ld.location == null) {
                        return;
                      }
                      // mapController?.move(ld.location, 16);
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
                          onPressed:(){
                            mapController?.move(currentPosition, 16);
                        },
                          backgroundColor: Colors.white,
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

}