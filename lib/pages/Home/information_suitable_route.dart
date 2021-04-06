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
  List<Node> list = [];
  Queue<Node> queue;

  @override
  void initState() {
    queue = widget.allList[widget.index];
    for (int i = 0; i + 1 < queue.length; i++) {
      if (queue
          .elementAt(i + 1)
          .routeId != queue
          .elementAt(i)
          .routeId) {
        list.add(queue.elementAt(i + 1));
      }
    }
    print(widget.index);
    queue.forEach((element) {
      print("${element.currentNode.stopId} - ${element.routeId}");
    });
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
                list: list,
              ),
              // Column(
              //   children: [
              //     ListTile(
              //       leading: Icon(
              //         Icons.location_on,
              //         color: Colors.green,
              //         size: 30,
              //       ),
              //       title: Text(
              //         queue.first.currentNode.name,
              //         style: TextStyle(color: Colors.green),
              //       ),
              //     ),
              //     (list.isNotEmpty)
              //         ? Expanded(
              //             child: ListView.builder(
              //               itemCount: list.length,
              //               itemBuilder: (context, index) => Column(
              //                 children: [
              //                   ListTile(
              //                     leading: Icon(Icons.directions_bus),
              //                     title: Text(
              //                         "Đi xe bus số ${list[index].parent.routeId}"),
              //                   ),
              //                   ListTile(
              //                     leading: Icon(
              //                       Icons.location_on,
              //                       color: Colors.blue,
              //                       size: 30,
              //                     ),
              //                     title: Text(
              //                       list[index].currentNode.name,
              //                       style: TextStyle(
              //                           fontWeight: FontWeight.bold,
              //                           color: Colors.blue),
              //                     ),
              //                   ),
              //                   (index == list.length - 1)
              //                       ? Column(
              //                           children: [
              //                             ListTile(
              //                               leading: Icon(Icons.directions_bus),
              //                               title: Text(
              //                                   "Đi xe bus số ${list[index].routeId}"),
              //                             ),
              //                             ListTile(
              //                               leading: Icon(
              //                                 Icons.location_on,
              //                                 color: Colors.orangeAccent,
              //                                 size: 30,
              //                               ),
              //                               title: Text(
              //                                 queue.last.currentNode.name,
              //                                 style: TextStyle(
              //                                     color: Colors.orangeAccent),
              //                               ),
              //                             ),
              //                           ],
              //                         )
              //                       : Container()
              //                 ],
              //               ),
              //               // separatorBuilder: (context, index) => Divider()
              //             ),
              //           )
              //         : Column(
              //             children: [
              //               ListTile(
              //                 leading: Icon(Icons.directions_bus),
              //                 title:
              //                     Text("Đi xe bus số ${queue.first.routeId}"),
              //               ),
              //               ListTile(
              //                 leading: Icon(Icons.location_on, color: Colors.orangeAccent, size: 30,),
              //                 title: Text(queue.last.currentNode.name, style: TextStyle(color: Colors.orangeAccent),),
              //               ),
              //             ],
              //           ),
              //   ],
              // ),
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
  final List<Node> list;

  RouteDetail({this.queue, this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        (list.isNotEmpty)
            ? Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) =>
                Column(
                  children: [
                    (index == 0) ? ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 30,
                      ),
                      title: Text(
                        queue.first.currentNode.name,
                        style: TextStyle(color: Colors.green),
                      ),
                    ) : Container(),
                    ListTile(
                      leading: Icon(Icons.directions_bus),
                      title:
                      Text("Đi xe bus số ${list[index].parent.routeId}"),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 30,
                      ),
                      title: Text(
                        list[index].currentNode.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    (index == list.length - 1)
                        ? Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.directions_bus),
                          title: Text(
                              "Đi xe bus số ${list[index].routeId}"),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.orangeAccent,
                            size: 30,
                          ),
                          title: Text(
                            queue.last.currentNode.name,
                            style:
                            TextStyle(color: Colors.orangeAccent),
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
                size: 30,
              ),
              title: Text(
                queue.first.currentNode.name,
                style: TextStyle(color: Colors.green),
              ),
            ),
            ListTile(
              leading: Icon(Icons.directions_bus),
              title: Text("Đi xe bus số ${queue.first.routeId}"),
            ),
            ListTile(
              leading: Icon(
                Icons.location_on,
                color: Colors.orangeAccent,
                size: 30,
              ),
              title: Text(
                queue.last.currentNode.name,
                style: TextStyle(color: Colors.orangeAccent),
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
      if (queue
          .elementAt(index + 1)
          .routeId != queue
          .elementAt(index + 1)
          .parent
          .routeId) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: getLength(),
      itemBuilder: (context, index) =>
          Container(
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
                          '${queue
                              .elementAt(index)
                              .routeId}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                (checkChangeBusStop(index)) ? Row(
                    children: [
                      Icon(Icons.autorenew, size: 15,),
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
                                '${queue
                                    .elementAt(index+1)
                                    .routeId}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    ]
                ) : Container(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      queue
                          .elementAt(index)
                          .currentNode
                          .name,
                      style: TextStyle(
                          color: (checkChangeBusStop(index))
                              ? Colors.green
                              : Colors.black,
                          fontWeight: (checkChangeBusStop(index)) ? FontWeight
                              .bold : FontWeight.normal
                      ),
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
