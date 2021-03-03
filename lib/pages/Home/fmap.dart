import 'package:emddibus/constants.dart';
import 'package:emddibus/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:latlong/latlong.dart';

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
        elevation: 0,
        backgroundColor: Colors.transparent,
        //iconTheme: IconThemeData(color: Colors.black),
        title: Transform.translate(
          offset: Offset(-20, 0),
          child: Container(
            margin: EdgeInsets.only(top: 10, right: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[300],
                width: 0.5,
              ),
            ),
<<<<<<< HEAD
            child: TextField(
              controller: _txtSearchController,
              focusNode: _textSearchFocusNode,
              onChanged: (String value){},
              decoration: InputDecoration(
                  hintText: "Tìm kiếm điểm dừng",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 15),
                  isDense: false,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 25,
                  ),
                  suffixIcon: IconButton(
                    onPressed: (){
                      _txtSearchController.clear();
                    },
                    icon: Icon(Icons.cancel),
                    iconSize: 20,
                    color: Colors.grey[400],
                  )
              ),
            ),
=======
          ),
          child: TextField(
            controller: _txtSearchController,
            focusNode: _textSearchFocusNode,
            onChanged: (String value) {},
            decoration: InputDecoration(
                hintText: "Tìm kiếm điểm dừng",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15, top: 15),
                isDense: false,
                prefixIcon: Icon(
                  Icons.search,
                  size: 25,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _txtSearchController.clear();
                  },
                  icon: Icon(Icons.cancel),
                  iconSize: 20,
                  color: Colors.grey[400],
                )),
>>>>>>> 705f77bdcb41d011f523d3ec5adf94d93fe0e1e2
          ),
        ),
      ),
      body: Stack(children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
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
        // Container(
        //   color: Colors.amber,
        //   child: AppBar(
        //     elevation: 0,
        //     backgroundColor: Colors.transparent,
        //     iconTheme: IconThemeData(color: Colors.black),
        //     title: Container(
        //       margin: EdgeInsets.only(left: 15, top: 10, right: 15),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(40),
        //         color: Colors.white,
        //         border: Border.all(
        //           color: Colors.grey[300],
        //           width: 0.5,
        //         ),
        //       ),
        //       child: TextField(
        //         controller: _txtSearchController,
        //         onChanged: (String value){},
        //         decoration: InputDecoration(
        //             hintText: "Tìm kiếm điểm dừng",
        //             border: InputBorder.none,
        //             contentPadding: EdgeInsets.only(left: 15, top: 15),
        //             isDense: false,
        //             prefixIcon: Icon(
        //               Icons.search,
        //               size: 25,
        //             ),
        //             suffixIcon: IconButton(
        //               onPressed: (){
        //                 _txtSearchController.clear();
        //               },
        //               icon: Icon(Icons.cancel),
        //               iconSize: 20,
        //               color: Colors.grey[400],
        //             )
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ]),
    );
  }
}
