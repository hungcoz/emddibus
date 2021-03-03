import 'package:emddibus/constants.dart';
import 'package:emddibus/models/stop_point_model.dart';
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        //iconTheme: IconThemeData(color: Colors.black),
        // title: Transform.translate(
        //   offset: Offset(-20, 0),
        //   child: 
          title: Container(
            margin: EdgeInsets.only(top: 10, right: 0, left: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[300],
                width: 0.5,
              ),
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
                }),
          ],
        ),
      ]),
    );
  }
  bool _isSearching = false;

  List<StopPoint> listBusStop = [];

  TextEditingController searchController = TextEditingController();

  Widget listResult() {
    return _isSearching
        ? Container(
            constraints: BoxConstraints(maxHeight: 200),
            child: listBusStop.length > 0
                ? Scrollbar(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 0),
                      itemCount: listBusStop.length,
                      itemBuilder: (context, index) =>
                          buildBusStopCard(context, index),
                      shrinkWrap: true,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    height: 30,
                    child: Center(
                      child: Text(
                        'Không tìm thấy kết quả',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
          )
        : null;
  }
  Widget buildBusStopCard(BuildContext context, int index) {
    StopPoint busStop = listBusStop[index];
    return Column(children: [
      Divider(
        color: Colors.grey,
        height: 1,
      ),
      ListTile(
        onTap: () {
          mapController.move(LatLng(listBusStop[index].latitude, listBusStop[index].longitude), 15);
          setState(() {
            _isSearching = false;
            searchController.text = busStop.name;
            searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: searchController.text.length));
          });
        },
        title: Text(
          '${busStop.name}',
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text('Tuyến chạy qua: '),
      ),
    ]);
  }

  void search(String value) {
    if (value.isNotEmpty) {
      List<StopPoint> dummyData = <StopPoint>[];
      STOP_POINT.forEach((element) {
        if (element.name.toLowerCase()
            .contains(value.toLowerCase())) {
          dummyData.add(element);
        }
      });
      setState(() {
        listBusStop.clear();
        listBusStop.addAll(dummyData);
      });
      return;
    } else {
      setState(() {
        listBusStop.clear();
      });
    }
  }

  Widget _search() {
    return Positioned(
      top: 40,
      right: 15,
      left: 15,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _isSearching ? Colors.white : Colors.white70,
          border: Border.all(color: Colors.grey[800], width: 2),
        ),
        child: Column(children: [
          TextField(
            style: TextStyle(fontSize: 18),
            controller: searchController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              hintText: 'Tìm kiếm điểm dừng...',
              hintStyle: TextStyle(fontSize: 18),
              suffixIcon: searchController.text.isEmpty
                  ? Icon(Icons.search)
                  : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchController.text = '';
                        listBusStop.clear();
                        setState(() {
                          _isSearching = false;
                        });
                      }),
            ),
            onChanged: (value) {
              setState(() {
                _isSearching = value.isNotEmpty;
              });
              search(value);
            },
            onSubmitted: (value) {
              setState(() {
                _isSearching = false;
              });
              if (value.isNotEmpty) {
               mapController.move(
                    LatLng(listBusStop[0].latitude, listBusStop[0].longitude),
                    16);
                searchController.text = listBusStop[0].name;
              }
            },
          ),
          Container(
            child: _isSearching ? listResult() : null,
          ),
        ]),
      ),
    );
  }
}
