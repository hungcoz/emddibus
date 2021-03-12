import 'package:emddibus/GGMap/geolocator_service.dart';
import 'package:emddibus/GGMap/ggmap.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/pages/Home/search_field.dart';
import 'package:emddibus/pages/Home/stop_point_marker.dart';
import 'package:emddibus/pages/Map/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'drawer.dart';

class FMap extends StatefulWidget {
  @override
  _FMapState createState() => _FMapState();
}

class _FMapState extends State<FMap> {
  MapController mapController = MapController();
  List<Marker> markers = [];

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
  }

  @override
  void initState() {
    // int permissionCheck = ContextCompat.checkSelfPermission(thisActivity,
    //     Manifest.permission.ACCESS_FINE_LOCATION);
    // if(permissionCheck != PackageManager.PERMISSION_GRANTED) {
    //   // ask permissions here using below code
    //   ActivityCompat.requestPermissions(thisActivity,
    //       new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
    //       REQUEST_CODE);
    // }
    setStopPointMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          Map(mapController: mapController, initialCamera: LatLng(15.594016, 110.450604), initialZoom: 16, markers: markers, focusNode: _textSearchFocusNode),

          // FlutterMap(
          //   mapController: mapController,
          //   options: MapOptions(
          //     maxZoom: 18,
          //     minZoom: 5,
          //     center: LatLng(15.594016, 110.450604),
          //     zoom: 5,
          //     onTap: (_) => _textSearchFocusNode.unfocus(),
          //     plugins: [
          //       LocationPlugin(),
          //     ],
          //     interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          //   ),
          //   layers: [
          //     TileLayerOptions(
          //       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          //     ),
          //     MarkerLayerOptions(markers: markers),
          //     LocationOptions(
          //         markers: markers,
          //         onLocationUpdate: (LatLngData ld) {
          //           setState(() {
          //             currentPosition = ld.location;
          //           });
          //         },
          //         onLocationRequested: (LatLngData ld) {
          //           if (ld == null || ld.location == null) {
          //             return;
          //           }
          //           mapController?.move(ld.location, 16);
          //         },
          //         buttonBuilder: (BuildContext context,
          //             ValueNotifier<LocationServiceStatus> status,
          //             Function onPressed) {
          //           return Positioned(
          //             bottom: 20,
          //             right: 20,
          //             child: FloatingActionButton(
          //               child: ValueListenableBuilder<LocationServiceStatus>(
          //                 valueListenable: status,
          //                 builder:
          //                     (context, LocationServiceStatus value, child) {
          //                   switch (value) {
          //                     case LocationServiceStatus.disabled:
          //                     case LocationServiceStatus.permissionDenied:
          //                     case LocationServiceStatus.unsubscribed:
          //                       return Icon(
          //                         Icons.location_disabled,
          //                         color: Colors.black,
          //                       );
          //                       break;
          //                     default:
          //                       return Icon(
          //                         Icons.my_location,
          //                         color: Colors.black,
          //                       );
          //                       break;
          //                   }
          //                 },
          //               ),
          //               onPressed: () => onPressed(),
          //               backgroundColor: Colors.white,
          //             ),
          //           );
          //         }),
          //   ],
          // ),
          SearchField(
            txtSearchFocusNode: _textSearchFocusNode,
            mapController: mapController,
          )
        ]),
      ),
    );
  }
}
class CircularButton extends StatelessWidget {
  final double width, height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton({this.width, this.height, this.color, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(icon: icon, enableFeedback: true, onPressed: onClick,),
    );
  }

}
