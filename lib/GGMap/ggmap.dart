import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GGMap extends StatefulWidget {
  final Position initialPosition;
  final Completer<GoogleMapController> controller;
  final List<Marker> listMarker;

  GGMap({this.initialPosition, this.controller, this.listMarker});

  @override
  _GGMapState createState() => _GGMapState();
}

class _GGMapState extends State<GGMap> {
  Future<void> _centerScreen() async {
    final GoogleMapController mapController = await widget.controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
          widget.initialPosition.latitude, widget.initialPosition.longitude),
      zoom: 16,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialPosition.latitude,
                widget.initialPosition.longitude),
            zoom: 15), //20.986207, 105.7971309
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            widget.controller.complete(controller);
          });
        },
        markers: (widget.listMarker.isNotEmpty) ? Set<Marker>.of(widget.listMarker) : Set<Marker>(),
        // padding: EdgeInsets.only(top: 150),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: Icon(
          Icons.my_location,
          color: Colors.black,
        ),
        onPressed: _centerScreen,
      ),
    );
  }
}
