import 'package:emddibus/constants.dart';
import 'package:emddibus/pages/BusPath/bus_path_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'list_name_bus_stop.dart';

class BusInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      BusInformationState(showBusPathState: showBusPathState, routeId: routeId);

  final ShowBusPathState showBusPathState;
  final String routeId;
  BusInformation({this.showBusPathState, this.routeId});
}

class BusInformationState extends State<BusInformation> {
  Color _color = Colors.green;
  String _text = "Chiều đi";

  ShowBusPathState showBusPathState;
  String routeId;
  BusInformationState({this.showBusPathState, this.routeId});

  String nameOfBus;

  void getNameOfBus() {
    BUS_ROUTE.forEach((element) {
      if (element.routeId.toString() == routeId) nameOfBus = element.name;
    });
  }

  @override
  void initState() {
    getNameOfBus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DraggableScrollableSheet(
        minChildSize: 0.075,
        maxChildSize: 0.5,
        builder: (context, controller) {
          return Container(
            margin: EdgeInsets.only(top: 0),
            color: Colors.white,
            child: ListView.builder(
              itemCount: 1,
              controller: controller,
              itemBuilder: (BuildContext context, index) {
                return Column(children: [
                  ListTile(
                    title: Text(
                      nameOfBus,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: OutlineButton(
                      onPressed: () {
                        this.showBusPathState.setState(() {
                          if (CHECK_DEPARTER_RETURN == 0) {
                            CHECK_DEPARTER_RETURN = 1;
                            _color = Colors.deepOrange;
                            showBusPathState.color = _color;
                            _text = "Chiều về";
                            //cập nhật marker chiều về
                            showBusPathState.markers =
                                showBusPathState.markersReturn;
                            //cập nhật path chiều về
                            showBusPathState.listPoint =
                                showBusPathState.listPointReturn;
                            //cập nhật tên các điểm dừng chiều về
                            showBusPathState.listStopPoint =
                                showBusPathState.listStopPointReturn;
                            print(showBusPathState
                                .listStopPoint[
                                    showBusPathState.listStopPoint.length - 1]
                                .name);
                            // di chuyển camera đến điểm đầu của chiều về
                            showBusPathState.mapController.move(
                                showBusPathState.listPoint[
                                    showBusPathState.listPoint.length - 1],
                                16);
                          } else {
                            CHECK_DEPARTER_RETURN = 0;
                            _color = Colors.green;
                            showBusPathState.color = _color;
                            _text = "Chiều đi";
                            //cập nhật marker chiều đi
                            showBusPathState.markers =
                                showBusPathState.markersDeparter;
                            //cập nhật path chiều đi
                            showBusPathState.listPoint =
                                showBusPathState.listPointDeparter;
                            //cập nhật tên các điểm dừng chiều đi
                            showBusPathState.listStopPoint =
                                showBusPathState.listStopPointDeparter;
                            // di chuyển camera đến điểm đầu của chiều đi
                            showBusPathState.mapController
                                .move(showBusPathState.listPoint[0], 16);
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      borderSide: BorderSide(color: _color),
                      child: Text(
                        _text,
                        style: TextStyle(color: _color),
                      ),
                    ),
                  ),
                  DefaultTabController(
                    length: 3,
                    child: Column(children: [
                      Container(
                        color: Colors.amber,
                        child: TabBar(
                          tabs: [
                            Tab(
                              text: "Giờ xuất bến",
                            ),
                            Tab(
                              text: "Điểm dừng",
                            ),
                            Tab(
                              text: "Thông tin",
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 300,
                        child: TabBarView(
                          children: [
                            Container(
                              color: Colors.redAccent,
                              child: ListView.builder(
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, index) {
                                    return ListTile(
                                      title: Text('Item ${index + 1}'),
                                    );
                                  }),
                            ),
                            ListNameBusStop(
                              showBusPathState: showBusPathState,
                            ),
                            Container(
                              color: Colors.green,
                              child: ListView.builder(
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, index) {
                                    return ListTile(
                                      title: Text('Item ${index + 1}'),
                                    );
                                  }),
                            )
                          ],
                        ),
                      )
                    ]),
                  )
                ]);
              },
            ),
          );
        });
  }
}
