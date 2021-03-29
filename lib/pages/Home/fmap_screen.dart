import 'dart:collection';

import 'package:emddibus/GGMap/geolocator_service.dart';
import 'package:emddibus/algothrim/filter_route.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'file:///F:/flutter/emddibus/lib/algothrim/find_the_way.dart';
import 'package:emddibus/pages/Home/search_field.dart';
import 'package:emddibus/pages/Home/stop_point_marker.dart';
import 'package:emddibus/pages/Map/map.dart';
import 'package:emddibus/pages/StopPointSearch/stop_point_search_screen.dart';
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

            Map(mapController: mapController, markers: markers, focusNode: _textSearchFocusNode, fMapState: this,),

            Visibility(
              visible: isVisibleSearchWay,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                // padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[300]),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        //choose start and finish location
                        Expanded(
                          flex: 6,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 8),
                            child: Column(
                              children: [
                                //choose start address
                                GestureDetector(
                                  onTap: ()async{
                                    start = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StopPointSearch()));
                                    setState(() {
                                      if (start != null){
                                        addressFrom = start.name;
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.green,
                                          size: 25,
                                        ),
                                        Flexible(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              addressFrom,
                                              style: TextStyle(fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 20,
                                  thickness: 1,
                                  indent: 30,
                                ),
                                //choose address where you wanna go
                                GestureDetector(
                                  onTap: ()async{
                                    target = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StopPointSearch()));
                                    setState(() {
                                      if (target != null){
                                        addressTo = target.name;
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.orange,
                                          size: 25,
                                        ),
                                        Flexible(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              addressTo,
                                              style: TextStyle(
                                                  fontSize: 16
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        //swap between start and finish location
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.swap_vert,
                              color: Colors.amber,
                            ),
                            iconSize: 35,
                            onPressed: (){
                              if (!addressTo.contains("Điểm bắt đầu") && !addressFrom.contains("Điểm kết thúc")) {
                                setState(() {
                                  String tmp = addressTo;
                                  addressTo = addressFrom;
                                  addressFrom = tmp;
                                });
                              }
                              else if (!addressTo.contains("Điểm bắt đầu") && addressFrom.contains("Điểm kết thúc")) {
                                setState(() {
                                  addressTo = "Nhập điểm bắt đầu";
                                  addressFrom = addressTo;
                                });
                              }
                              else if (addressTo.contains("Điểm bắt đầu") && !addressFrom.contains("Điểm kết thúc")) {
                                setState(() {
                                  addressFrom = "Nhập điểm kết thúc";
                                  addressTo = addressFrom;
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    //history of searching for the way
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 0),
                      color: Colors.amber[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  color: Colors.grey,
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text("Lịch sử tìm đường")),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: TextButton(
                              child: Text(
                                "TÌM ĐƯỜNG",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                print("lol");
                                AStar a = AStar();
                                // print('${target.stopId}' + 'and' + '${start.stopId}');
                                List<Queue<Node>> queue = await a.findPath(start, target);
                                if (queue.isNotEmpty) {
                                  queue.forEach((element) {
                                    element.forEach((e) {
                                      print("${e.currentNode.stopId} - ${e.routeId} - ${e.count}");
                                    });
                                    print("##########");
                                  });
                                } else print("Không tìm thấy tuyến phù hợp");
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            Visibility(
              visible: isVisibleSearchLocation,
              child: SearchField(
                txtSearchFocusNode: _textSearchFocusNode,
                mapController: mapController,
                fMapState: this,
              ),
            )
          ]),
        ),
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
