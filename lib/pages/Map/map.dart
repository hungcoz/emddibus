import 'package:emddibus/pages/Home/home_screen.dart';
import 'package:emddibus/pages/Home/result_of_search_way.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:latlong/latlong.dart';

import '../../constants.dart';

class Map extends StatefulWidget {
  final MapController mapController;
  final LatLng initialCamera;
  final double initialZoom;
  final List<Marker> markers;
  final List<LatLng> listPoint;
  final Color color;
  final FocusNode focusNode;
  final HomeState fMapState;
  final LatLngBounds bounds;

  Map(
      {this.mapController,
      this.initialCamera,
      this.initialZoom,
      this.markers,
      this.listPoint,
      this.color,
      this.focusNode,
      this.fMapState,
      this.bounds});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  bool initCam;
  @override
  void initState() {
    initCam =
        (widget.initialCamera != null || widget.bounds != null) ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        maxZoom: 18,
        minZoom: 5,
        center: (widget.initialCamera == null)
            ? LatLng(15.594016, 110.450604)
            : widget.initialCamera,
        zoom: (widget.initialZoom == null) ? 5 : widget.initialZoom,
        bounds: (widget.bounds != null) ? widget.bounds : null,
        boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(50)),
        onTap: (_) => widget.focusNode.unfocus(),
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
            color: widget.color,
            strokeWidth: 5,
            points: (widget.listPoint != null) ? widget.listPoint : [],
          )
        ]),
        MarkerLayerOptions(markers: widget.markers),
        LocationOptions(
            markers: widget.markers,
            onLocationUpdate: (LatLngData ld) {
              currentPosition = ld.location;
            },
            onLocationRequested: (LatLngData ld) {
              if (ld == null || ld.location == null) {
                return;
              }
              if (!initCam) {
                widget.mapController?.move(ld.location, 16);
              } else {
                initCam = false;
              }
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
                    builder: (context, LocationServiceStatus value, child) {
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
                  heroTag: "my_location",
                  onPressed: () {
                    {
                      if (currentPosition != null)
                        widget.mapController.move(
                            LatLng(currentPosition.latitude,
                                currentPosition.longitude),
                            16);
                    }
                  },
                  backgroundColor: Colors.white70,
                ),
              );
            }),
      ],
    );
  }
}
