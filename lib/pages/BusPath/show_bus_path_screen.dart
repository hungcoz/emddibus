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

  List<LatLng> _listPoint = [];

  void getPointOfPath() {
    BUS_PATH.forEach((element) {
      _listPoint.add(LatLng(element.latitude, element.longitude));
    });
  }

  @override
  void initState() {
    getPointOfPath();
    // TODO: implement initState
    super.initState();
  }

  // void setStopPointMarker() {
  //   BUS_PATH.forEach((point) {
  //     markers.add(Marker(
  //         width: 50,
  //         height: 50,
  //         point: LatLng(point.latitude, point.longitude),
  //         builder: (context) => StopPointMarker(mapController: mapController)
  //     ));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Tuyến " + routeId),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          maxZoom: 18,
          center: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 5,
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
                mapController?.move(ld.location, 16);
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
                    onPressed: () => onPressed(),
                    backgroundColor: Colors.white,
                  ),
                );
              }),
          PolylineLayerOptions(
              polylines: [
                Polyline(
                  strokeWidth: 2,
                  points: _listPoint,
                )
              ]
          )
        ],
      ),
    );
  }

}