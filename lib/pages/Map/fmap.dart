import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';

class FMap extends StatefulWidget {
  @override
  _FMapState createState() => _FMapState();
}

class _FMapState extends State<FMap> {
  MapController mapController = MapController();
  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [FlutterMap(
          mapController: mapController,
          options: MapOptions(
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
                onLocationRequested: (LatLngData ld) {
                  if (ld == null || ld.location == null) {
                    return;
                  }
                  mapController?.move(ld.location, 14.0);
                },
                buttonBuilder: (BuildContext context, ValueNotifier<LocationServiceStatus> status, Function onPressed) {
                  return Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          //Navigator.pushNamed(context, '/bus');
                        },
                        child: Icon(Icons.directions_bus, color: Colors.black),
                        backgroundColor: Color(0xffeeac24),
                      ),
                      FloatingActionButton(
                        heroTag: null,
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
                    ]
                    ),
                  );
                })
          ],
        ),
      ]
      ),
    );
  }
}
