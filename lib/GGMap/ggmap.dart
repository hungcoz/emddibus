import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class GGMap extends StatefulWidget {
  final Position initialPosition;

  GGMap({this.initialPosition});

  @override
  _GGMapState createState() => _GGMapState();
}

class _GGMapState extends State<GGMap> {

  Completer<GoogleMapController> _controller = Completer();

  Future<void> _centerScreen() async {
    final GoogleMapController mapController = await _controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(widget.initialPosition.latitude, widget.initialPosition.longitude),
          zoom: 16,
        )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialPosition.latitude, widget.initialPosition.longitude), zoom: 15), //20.986207, 105.7971309
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller.complete(controller);
          });
        },
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
