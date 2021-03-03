import 'package:emddibus/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:latlong/latlong.dart';

import 'drawer.dart';

class FMap extends StatefulWidget {
  @override
  _FMapState createState() => _FMapState();
}

class _FMapState extends State<FMap> {
  MapController mapController = MapController();
  List<Marker> markers = [];

  TextEditingController _txtSearchController = new TextEditingController();
  FocusNode _textSearchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Menu(),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("EMDDIBUS"),
        ),
      body: Stack(children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            maxZoom: 18,
            center: LatLng(15.594016, 110.450604),
            zoom: 5,
            onTap: (_) => _textSearchFocusNode.unfocus(),
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
                  mapController?.move(ld.location, 14.0);
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
                      onPressed: () => onPressed(),
                      backgroundColor: Colors.white,
                    ),
                  );
                })
          ],
        ),
      ]),
    );
  }
}
