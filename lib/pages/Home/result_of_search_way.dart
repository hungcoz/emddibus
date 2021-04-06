import 'dart:async';
import 'dart:collection';

import 'package:emddibus/GGMap/ggmap.dart';
import 'package:emddibus/algothrim/find_the_way.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/Home/information_suitable_route.dart';
import 'package:emddibus/pages/Home/search_way.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ResultSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ResultSearchState();
}

class ResultSearchState extends State<ResultSearch>
    with SingleTickerProviderStateMixin {
  List<List<int>> allList = [];
  List<Widget> list = [];

  String addressFrom = "Điểm bắt đầu";
  String addressTo = "Điểm kết thúc";
  StopPoint start;
  StopPoint target;
  StopPoint tmpStart;
  StopPoint tmpTarget;

  List<Marker> listMarker = [];

  List<Queue<Node>> queue;

  Completer<GoogleMapController> controller;
  GoogleMapController mapController;

  static double _height = 0, _two = 0;
  double _twoFixed = 0;
  Duration _duration = Duration(microseconds: 500);
  bool _bottom = false;

  void _toggleBottom() {
    _bottom = !_bottom;
    Timer.periodic(_duration, (timer) {
      if (_bottom)
        _two -= 1;
      else
        _two += 1;
      if (_two <= 0) {
        _two = 0;
        timer.cancel();
      }
      if (_two >= _twoFixed) {
        _two = _twoFixed;
        timer.cancel();
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    controller = Completer();
    getMapController(controller);
    _height = CONTEXT_SIZE;
    _two = _height;
    _twoFixed = _height;
    // TODO: implement initState
    super.initState();
  }

  getMapController(Completer<GoogleMapController> controller) async {
    mapController = await controller.future;
  }

  void showAlertDialog(String text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Center(
              child: Text(
                text,
                style: TextStyle(color: Colors.amber, fontSize: 15),
              ),
            ),
            content: Container(
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.amber,
        title: Text("Tìm đường"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    child: GGMap(
                      initialPosition: Position(
                          latitude: currentPosition.latitude,
                          longitude: currentPosition.longitude),
                      controller: controller,
                      listMarker: listMarker,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // color: Colors.amber,
                  ),
                  child: SearchWay(
                    resultSearchState: this,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: FlatButton(
                      minWidth: double.infinity,
                      color: Colors.white,
                      highlightColor: Colors.amber,
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () async {
                        listMarker.clear();
                        if (addressFrom == "Điểm bắt đầu" || addressTo == "Điểm kết thúc") {
                          showAlertDialog("Vui lòng nhập địa chỉ còn thiếu");
                        }
                        else if (addressTo == addressFrom) {
                          showAlertDialog("Điểm muốn đến là điểm bắt đầu");
                        }
                        else {
                          AStar a = AStar();
                          queue = await a.findPath(tmpStart, tmpTarget);
                          if (queue.isEmpty)
                            showAlertDialog("Không tìm thấy lộ trình phù hợp");
                          else {
                            filterCrossingPath();
                            filterSameRoute();
                            sortRoute();
                          }
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "TÌM ĐƯỜNG",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              top: _two,
              height: _height,
              child: GestureDetector(
                // onTap: _toggleBottom,
                onPanEnd: (details) => _toggleBottom(),
                onPanUpdate: (details) {
                  _two += details.delta.dy;
                  if (_two <= 0) _two = 0;
                  if (_two >= _twoFixed) _two = _twoFixed;
                  setState(() {});
                },
                child: Container(
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      Container(
                          margin:
                              EdgeInsets.only(left: 10, bottom: 10, top: 10),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Các lộ trình phù hợp",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    allList.clear();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.grey,
                                  ),
                                  child: Text("Hủy tìm đường"),
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                        child: GridView.count(
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 1,
                          childAspectRatio: 4,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          children: new List<Widget>.generate(allList.length,
                              (index) {
                            return new GridTile(
                              child: _buildCard(allList, index),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<List<int>> allList, int i) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InfoSuitableRoute(
                      allList: queue,
                      index: i,
                    )));
      },
      child: Card(
        margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
        shadowColor: Colors.amber,
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: allList[i].length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.only(top: 10, bottom: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber),
                      child: Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(children: [
                          Icon(
                            Icons.directions_bus,
                            size: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              allList[i][index].toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          )
                        ]),
                      ),
                    ),
                    separatorBuilder: (context, index) => Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 20,
                        )),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.accessibility,
                          color: Colors.black54,
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child: Text(
                            "200 m",
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.directions_bus, color: Colors.black54),
                        Container(
                          child: Text("6 km",
                              style: TextStyle(color: Colors.black54)),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void filterSameRoute() {
    List<List<int>> listRouteOfPath = [];
    List<Queue<Node>> listPathToDelete = [];
    queue.forEach((element) {
      List<int> listRouteId = [];
      element.forEach((e) {
        if (!listRouteId.contains(e.routeId)) {
          listRouteId.add(e.routeId);
        }
      });
      listRouteOfPath.add(listRouteId);
    });
    for (int i=0; i < listRouteOfPath.length; i++) {
      for (int j=i+1; j < listRouteOfPath.length; j++) {
        if (listRouteOfPath[j].length == listRouteOfPath[i].length) {
          int count = 0;
          listRouteOfPath[j].forEach((route) {
            if (listRouteOfPath[i].contains(route)) count++;
          });
          if (count == listRouteOfPath[i].length) {
            if (queue[j].last.count > queue[i].last.count) {
              if (!listPathToDelete.contains(queue[j]))
                listPathToDelete.add(queue[j]);
            } else if (queue[j].last.count < queue[i].last.count) {
              if (!listPathToDelete.contains(queue[i]))
                listPathToDelete.add(queue[i]);
            }
          }
        }
      }
    }
    listPathToDelete.forEach((element) {
      queue.remove(element);
    });
  }

  void filterCrossingPath() {
    List<Queue<Node>> listPathCrossWay = [];
    List<List<int>> listRouteOfPath = [];
    List<int> listIndexCross = [];
    queue.forEach((element) {
      for (int i = 0; i < element.length; i++) {
        if (element.elementAt(i).crossStreet == 1) {
          listPathCrossWay.add(element);
          listIndexCross.add(i);
          break;
        }
      }
    });
    for (int i = 0; i < listPathCrossWay.length; i++) {
      List<int> tmp = [];
      listPathCrossWay[i].forEach((element) {
        if (element.crossStreet == 1) tmp.add(element.routeId);
      });
      if (tmp.length > 1) queue.remove(listPathCrossWay[i]);
      else if (tmp.length == 1) listRouteOfPath.add(tmp);
    }
    for (int i = 0; i < listRouteOfPath.length; i++) {
      for (int j = i + 1; j < listRouteOfPath.length; j++) {
        if (listRouteOfPath[j].length == listRouteOfPath[i].length) {
          int count = 0;
          listRouteOfPath[i].forEach((element) {
            if (listRouteOfPath[j].contains(element)) count++;
          });
          if (count == listRouteOfPath[i].length) {
            if (listIndexCross[j] < listIndexCross[i])
              queue.remove(listPathCrossWay[i]);
            else
            if (listIndexCross[j] > listIndexCross[i])
              queue.remove(listPathCrossWay[j]);
          }
        }
      }
    }
  }

  void sortRoute() {
      allList.clear();
      if (queue.isNotEmpty) {
        queue.forEach((element) {
          List<int> listRouteId = [];
          element.forEach((e) {
            if (!listRouteId.contains(e.routeId)) {
              listRouteId.add(e.routeId);
            }
          });
          allList.add(listRouteId);
        });
        for (int i = 0; i + 1 < allList.length; i++) {
          for (int j = i + 1; j < allList.length; j++) {
            if (allList[i].length > allList[j].length) {
              List<int> tmp = allList[i];
              allList[i] = allList[j];
              allList[j] = tmp;
              Queue<Node> tmp1 = new Queue<Node>();
              tmp1.addAll(queue.elementAt(i));
              queue[i].clear();
              queue[i].addAll(queue[j]);
              queue[j].clear();
              queue[j].addAll(tmp1);
            }
          }
        }
      }
      _toggleBottom();
      setState(() {});
    }
}
