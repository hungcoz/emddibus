import 'dart:collection';

import 'package:emddibus/algothrim/find_the_way.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoSuitableRoute extends StatefulWidget {
  final List<Queue<Node>> allList;
  final int index;

  InfoSuitableRoute({this.allList, this.index});

  @override
  State<StatefulWidget> createState() => InfoSuitableRouteState();
}

class InfoSuitableRouteState extends State<InfoSuitableRoute>
    with SingleTickerProviderStateMixin {
  List<Node> listChangeRoute = [];
  List<Node> listCrossWay = [];
  Queue<Node> queue;

  @override
  void initState() {
    queue = widget.allList[widget.index];
    queue.forEach((element) {
      print('${element.currentNode.stopId} - ${element.routeId} - ${element.count} - ${element.direction}');
    });
    for (int i = 0; i + 1 < queue.length; i++) {
      if (queue.elementAt(i + 1).crossStreet == 1)
        listChangeRoute.add(queue.elementAt(i + 1));
      else if (queue.elementAt(i + 1).count!= queue.elementAt(i).count) {
        listChangeRoute.add(queue.elementAt(i + 1));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Thông tin lộ trình'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              color: Colors.amber,
              child: TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "Chi tiết lộ trình",
                  ),
                  Tab(
                    text: "Các điểm bus đi qua",
                  )
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              RouteDetail(
                queue: queue,
                listChangeRoute: listChangeRoute,
              ),
              BusStopPassed(
                queue: queue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RouteDetail extends StatelessWidget {
  final Queue<Node> queue;
  final List<Node> listChangeRoute;

  RouteDetail({this.queue, this.listChangeRoute});

  // int getLength() {
  //   int length = 0;
  //   queue.forEach((element) {
  //     length++;
  //   });
  //   return length;
  // }
  //
  // bool checkCrossWay(int index) {
  //   if (index + 1 < getLength()) {
  //     if (queue.elementAt(index+1).crossStreet == 1) return true;
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        (listChangeRoute.isNotEmpty)
            ? Expanded(
                child: ListView.builder(
                  itemCount: listChangeRoute.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      (index == 0)
                          ? ListTile(
                              dense: true,
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 25,
                              ),
                              title: Transform.translate(
                                offset: Offset(-15, 0),
                                child: Text(
                                  queue.first.currentNode.name,
                                  style: TextStyle(color: Colors.green, fontSize: 15),
                                ),
                              ),
                            )
                          : Container(),
                      (listChangeRoute[index].crossStreet == 1)
                          ? Column(
                              children: [
                                (!listChangeRoute[index]
                                        .parent
                                        .currentNode
                                        .name
                                        .contains(queue.first.currentNode.name))
                                    ? Column(
                                        children: [
                                          ListTile(
                                            dense: true,
                                            leading: Icon(Icons.directions_bus, color: Colors.black,),
                                            title: Transform.translate(
                                                offset: Offset(-15, 0),
                                                child: Text(
                                                    "Đi tuyến bus số ${listChangeRoute[index].parent.routeId}",
                                                  style: TextStyle(fontSize: 15),
                                                )
                                            ),
                                          ),
                                          ListTile(
                                            dense: true,
                                            leading: Icon(
                                              Icons.location_on,
                                              color: Colors.blue,
                                              size: 25,
                                            ),
                                            title: Transform.translate(
                                              offset: Offset(-15, 0),
                                              child: Text(
                                                listChangeRoute[index]
                                                    .parent
                                                    .currentNode
                                                    .name,
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 15
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                ListTile(
                                  dense: true,
                                  leading: Icon(Icons.swap_horiz, size: 25, color: Colors.amber,),
                                  title: Transform.translate(
                                    offset: Offset(-15, 0),
                                    child: Text(
                                        "Di chuyển sang điểm bus đối diện bên đường",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                  title: Transform.translate(
                                    offset: Offset(-15, 0),
                                    child: Text(
                                      listChangeRoute[index].currentNode.name,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                ListTile(
                                  dense: true,
                                  leading: Icon(Icons.directions_bus, color: Colors.black,),
                                  title: Transform.translate(
                                      offset: Offset(-15, 0),
                                      child: Text(
                                          "Đi xe bus số ${listChangeRoute[index].parent.routeId}",
                                        style: TextStyle(fontSize: 15),
                                      )),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                  title: Transform.translate(
                                    offset: Offset(-15, 0),
                                    child: Text(
                                      listChangeRoute[index]
                                          .parent
                                          .currentNode
                                          .name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          fontSize: 15
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      (index == listChangeRoute.length - 1)
                          ? Column(
                              children: [
                                ListTile(
                                  dense: true,
                                  leading: Icon(Icons.directions_bus, color: Colors.black,),
                                  title: Transform.translate(
                                    offset: Offset(-15, 0),
                                    child: Text(
                                        "Đi xe bus số ${listChangeRoute[index].routeId}",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.location_on,
                                    color: Colors.orangeAccent,
                                    size: 25,
                                  ),
                                  title: Transform.translate(
                                    offset: Offset(-15, 0),
                                    child: Text(
                                      queue.last.currentNode.name,
                                      style:
                                          TextStyle(color: Colors.orangeAccent, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                  // separatorBuilder: (context, index) => Divider()
                ),
              )
            : Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: 25,
                    ),
                    title: Text(
                      queue.first.currentNode.name,
                      style: TextStyle(color: Colors.green, fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_bus, color: Colors.black,),
                    title: Text("Đi xe bus số ${queue.first.routeId}"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.orangeAccent,
                      size: 25,
                    ),
                    title: Text(
                      queue.last.currentNode.name,
                      style: TextStyle(color: Colors.orangeAccent, fontSize: 15),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

class BusStopPassed extends StatelessWidget {
  final Queue<Node> queue;

  BusStopPassed({this.queue});

  int getLength() {
    int length = 0;
    queue.forEach((element) {
      length++;
    });
    return length;
  }

  bool checkChangeBusStop(int index) {
    if (index + 1 < getLength()) {
      if (queue.elementAt(index + 1).count !=
          queue.elementAt(index + 1).parent.count) {
        return true;
      }
    }
    return false;
  }

  bool checkCrossWay(int index) {
    if (index + 1 < getLength()) {
      if (queue.elementAt(index + 1).crossStreet == 1) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: getLength(),
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
        child: Row(
          children: [
            Card(
              color: Colors.amber,
              child: Container(
                padding: EdgeInsets.all(2),
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_bus,
                      color: Colors.green,
                    ),
                    Text(
                      '${queue.elementAt(index).routeId}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            (checkChangeBusStop(index))
                ? Row(children: [
                    Icon(
                      Icons.autorenew,
                      size: 15,
                    ),
                    Card(
                      color: Colors.amber,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          children: [
                            Icon(
                              Icons.directions_bus,
                              color: Colors.green,
                            ),
                            Text(
                              '${queue.elementAt(index + 1).routeId}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  ])
                : Container(),
            (checkCrossWay(index))
                ? Card(
                    child: Text("Sang đường"),
                  )
                : Container(),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  queue.elementAt(index).currentNode.name,
                  style: TextStyle(
                      color: (checkChangeBusStop(index))
                          ? Colors.green
                          : Colors.black,
                      fontWeight: (checkChangeBusStop(index))
                          ? FontWeight.bold
                          : FontWeight.normal),
                  textAlign: TextAlign.left,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
