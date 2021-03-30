import 'dart:collection';

import 'package:emddibus/algothrim/find_the_way.dart';
import 'package:emddibus/models/stop_point_model.dart';

import 'address_to_or_from.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ResultSearchState();
}

class ResultSearchState extends State<ResultSearch> {
  StopPoint start;
  StopPoint target;

  String addressFrom = "Điểm bắt đầu";
  String addressTo = "Điểm kết thúc";

  List<List<int>> allList = [];
  List<Widget> list = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Tìm đường"),
      ),
      body: Container(
        color: Colors.amber,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Card(
                        shadowColor: Colors.grey,
                        margin: EdgeInsets.only(top: 20, left: 10),
                        child: ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.green,
                          ),
                          title: Text(
                            addressFrom,
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                          dense: true,
                          onTap: () async {
                            start = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddressToOrFrom(
                                        title: "Chọn điểm bắt đầu")));
                            setState(() {
                              if (start != null) {
                                addressFrom = start.name;
                              }
                            });
                          },
                        ),
                      ),
                      Card(
                        shadowColor: Colors.grey,
                        margin: EdgeInsets.only(top: 10, left: 10, bottom: 20),
                        child: ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.orangeAccent,
                          ),
                          title: Text(
                            addressTo,
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                          dense: true,
                          onTap: () async {
                            target = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddressToOrFrom(
                                        title: "Chọn điểm kết thúc")));
                            setState(() {
                              if (target != null) {
                                addressTo = target.name;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.swap_vert,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        if (!addressFrom.contains("Điểm bắt đầu") &&
                            !addressTo.contains("Điểm kết thúc")) {
                          setState(() {
                            String tmp = addressTo;
                            addressTo = addressFrom;
                            addressFrom = tmp;
                            StopPoint tmp1 = start;
                            start = target;
                            target = tmp1;
                          });
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FlatButton(
                  onPressed: () async {
                    allList.clear();
                    print("lol");
                    AStar a = AStar();
                    List<Queue<Node>> queue = await a.findPath(start, target);
                    setState(() {
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
                      } else
                        print("Không tìm thấy tuyến phù hợp");
                    });
                  },
                  minWidth: double.infinity,
                  color: Colors.white,
                  highlightColor: Colors.amber,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "TÌM ĐƯỜNG",
                    style: TextStyle(color: Colors.blue),
                  )),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  "Các lộ trình phù hợp",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 1,
                  childAspectRatio: 6,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: new List<Widget>.generate(allList.length, (index) {
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
    );
  }

  Widget _buildCard(List<List<int>> allList, int i) {
    return Card(
      shadowColor: Colors.grey,
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: allList[i].length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.amber),
            child: Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Row(children: [
                Icon(Icons.directions_bus),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    allList[i][index].toString(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                )
              ]),
            ),
          ),
          separatorBuilder: (context, index) => Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
