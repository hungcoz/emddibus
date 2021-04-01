import 'package:emddibus/GGMap/geolocator_service.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/location_model.dart';
import 'package:emddibus/pages/Home/stop_point_marker.dart';
import 'package:emddibus/pages/Map/map.dart';
import 'package:emddibus/pages/SearchLocation/search_location_screen.dart';
import 'package:emddibus/services/http_foot_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'drawer.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  MapController mapController = MapController();
  List<Marker> markers = [];
  //List<LatLng> polyline = [];

  FocusNode _textSearchFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();

  LocationModel dataSearch;

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
        child: Stack(
          children: [
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
              //listPoint: polyline,
              //color: Colors.lightBlueAccent,
              fMapState: this,
            ),
            Positioned(
              top: 10,
              right: 15,
              left: 15,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white70,
                  border: Border.all(color: Colors.grey[500], width: 2),
                ),
                child: Column(children: [
                  TextField(
                    style: TextStyle(fontSize: 18),
                    controller: searchController,
                    focusNode: _textSearchFocusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      hintText: 'Tìm kiếm địa điểm...',
                      hintStyle: TextStyle(fontSize: 18),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon:
                          // searchController.text.isEmpty
                          //     ? null
                          //     :
                          IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                searchController.text = '';
                                setState(() {
                                  markers[markers.length - 2] = Marker();
                                  //polyline.clear();
                                });
                              }),
                    ),
                    onTap: () async {
                      _textSearchFocusNode.unfocus();
                      dataSearch = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchLocation()));
                      if (dataSearch != null) {
                        // mapController.fitBounds(LatLngBounds(currentPosition,
                        //     LatLng(dataSearch.lat, dataSearch.long)));
                        mapController.move(
                            LatLng(dataSearch.lat, dataSearch.long), 16);
                        searchController.text = text(dataSearch);
                        setState(() {
                          markers[markers.length - 2] = Marker(
                              anchorPos: AnchorPos.align(AnchorAlign.top),
                              point: LatLng(dataSearch.lat, dataSearch.long),
                              builder: (context) => Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 50,
                                  ));
                        });
                        SEARCH_HISTORY.remove(dataSearch);
                        SEARCH_HISTORY.add(dataSearch);
                      }
                    },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
