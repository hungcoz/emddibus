import 'package:flutter/cupertino.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'bus_path_screen.dart';

class MapBusPath extends StatefulWidget {
  final ShowBusPathState showBusPathState;

  MapBusPath({this.showBusPathState});

  @override
  State<StatefulWidget> createState() => MapBusPathState();
}

class MapBusPathState extends State<MapBusPath> {
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.height -
          widget.showBusPathState.heightMap,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          maxZoom: 18,
          center: LatLng(widget.showBusPathState.listPoint[0].latitude,
              widget.showBusPathState.listPoint[0].longitude),
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
              color: widget.showBusPathState.color,
              strokeWidth: 5,
              points: widget.showBusPathState.listPoint,
            ),
          ]),
          MarkerLayerOptions(markers: widget.showBusPathState.markers),
          LocationOptions(
              markers: widget.showBusPathState.markers,
              onLocationUpdate: (LatLngData ld) {},
              onLocationRequested: (LatLngData ld) {},
              buttonBuilder: (context,
                  ValueNotifier<LocationServiceStatus> status,
                  Function onPressed) {
                return Container();
              }),
        ],
      ),
    );
  }
}
