import 'dart:collection';

import 'package:emddibus/GGMap/geolocator_service.dart';
import 'package:emddibus/algothrim/find_the_way.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/Home/address_to_or_from.dart';
import 'package:emddibus/pages/Home/search_field.dart';
import 'package:emddibus/pages/Home/stop_point_marker.dart';
import 'package:emddibus/pages/Map/map.dart';
import 'package:emddibus/pages/SearchLocation/search_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'drawer.dart';

class FMap extends StatefulWidget {
  @override
  FMapState createState() => FMapState();
}

class FMapState extends State<FMap> {
  MapController mapController = MapController();
  List<Marker> markers = [];

  bool isVisibleSearchWay = false;
  bool isVisibleSearchLocation = true;
  String addressFrom = "Điểm bắt đầu";
  String addressTo = "Điểm kết thúc";
  StopPoint start;
  StopPoint target;

  FocusNode _textSearchFocusNode = FocusNode();

  final geoService = GeolocatorService();

  void setStopPointMarker() {
    STOP_POINT.forEach((point) {
      markers.add(Marker(
          width: 50,
          height: 50,
          point: LatLng(point.latitude, point.longitude),
          builder: (context) =>
              StopPointMarker(stopPoint: point, mapController: mapController)));
    });
    markers.add(Marker());
    markers.add(Marker());
  }

  @override
  void initState() {
    setStopPointMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: Menu(),
        appBar: AppBar(
          title: Image.asset(
            'assets/EMDDI_2.png',
            scale: 2,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(children: [
            // FutureProvider(
            //   create: (context) => geoService.getInitialLocation(),
            //   child: Consumer<Position>(builder: (context, position, widget) {
            //     return (position != null) ? GGMap(initialPosition: position,) : Center(child: CircularProgressIndicator(),);
            //   },),
            // ),

            Map(
              mapController: mapController,
              markers: markers,
              focusNode: _textSearchFocusNode,
              fMapState: this,
            ),

            Visibility(
              visible: isVisibleSearchLocation,
              child:
                  // SearchField(
                  //   txtSearchFocusNode: _textSearchFocusNode,
                  //   mapController: mapController,
                  //   fMapState: this,
                  // ),
                  IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchLocation())),
              ),
            )
          ]),
        ),
        // centerTitle: true,
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final double width, height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton(
      {this.width, this.height, this.color, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(
        icon: icon,
        enableFeedback: true,
        onPressed: onClick,
      ),
    );
  }
}
