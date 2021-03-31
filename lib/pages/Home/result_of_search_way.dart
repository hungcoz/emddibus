import 'dart:collection';

import 'package:emddibus/GGMap/ggmap.dart';
import 'package:emddibus/algothrim/find_the_way.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/Home/search_way.dart';
import 'package:geolocator/geolocator.dart';

import 'address_to_or_from.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ResultSearchState();
}

class ResultSearchState extends State<ResultSearch> {
  List<List<int>> allList = [];
  List<Widget> list = [];

  String addressFrom = "Điểm bắt đầu";
  String addressTo = "Điểm kết thúc";
  StopPoint start;
  StopPoint target;
  StopPoint tmpStart;
  StopPoint tmpTarget;

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
        color: Colors.grey[200],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.amber,
              ),
              child: SearchWay(
                resultSearchState: this,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FlatButton(
                  onPressed: () async {
                    if (addressFrom == "Điểm bắt đầu" ||
                        addressTo == "Điểm kết thúc") {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              title: Center(
                                child: Text(
                                  "Vui lòng nhập địa chỉ còn thiếu",
                                  style: TextStyle(
                                      color: Colors.amber, fontSize: 15),
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
                    } else {
                      allList.clear();
                      AStar a = AStar();
                      List<Queue<Node>> queue =
                          await a.findPath(tmpStart, tmpTarget);
                      if (queue.isNotEmpty) {
                        queue.forEach((element) {
                          List<int> listRouteId = [];
                          element.forEach((e) {
                            if (!listRouteId.contains(e.routeId)) {
                              listRouteId.add(e.routeId);
                            }
                          });
                          allList.add(listRouteId);
                          for (int i=0; i+1 < allList.length; i++) {
                            if (allList[i].length > allList[i+1].length) {
                              List<int> tmp = allList[i];
                              allList[i] = allList[i+1];
                              allList[i+1] = tmp;
                            }
                          }
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: Center(
                                  child: Text(
                                    (addressTo == addressFrom)
                                        ?"Điểm muốn đến là điểm bắt đầu"
                                        :"Không tìm thấy lộ trình phù hợp",
                                    style: TextStyle(
                                        color: Colors.amber, fontSize: 15),
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
                      setState(() {});
                    }
                  },
                  minWidth: double.infinity,
                  color: Colors.amber,
                  highlightColor: Colors.amber,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "TÌM ĐƯỜNG",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  )),
            ),
            (allList.isEmpty)
                ? Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 25),
                      child: GGMap(
                        initialPosition: Position(
                            latitude: currentPosition.latitude,
                            longitude: currentPosition.longitude),
                      ),
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Container(
                            margin:
                                EdgeInsets.only(left: 10, bottom: 10, top: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Các lộ trình phù hợp",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                          child: Container(
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: GridView.count(
                              scrollDirection: Axis.vertical,
                              crossAxisCount: 1,
                              childAspectRatio: 4,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              children: new List<Widget>.generate(
                                  allList.length, (index) {
                                return new GridTile(
                                  child: _buildCard(allList, index),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<List<int>> allList, int i) {
    return GestureDetector(
      onTap: (){

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
}
