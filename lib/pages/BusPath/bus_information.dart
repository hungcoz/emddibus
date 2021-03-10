import 'package:emddibus/constants.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:emddibus/pages/BusPath/bus_path_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'list_name_bus_stop.dart';

class BusInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BusInformationState();

  final ShowBusPathState showBusPathState;
  final BusRoute busRoute;
  BusInformation({this.showBusPathState, this.busRoute});
}

class BusInformationState extends State<BusInformation> {
  Color _color = Colors.green;
  String _text = "Chiều đi";

  //ListNameBusStopState listNameBusStopState = new ListNameBusStopState();

  String nameOfBus;
  int selectedIndex = 0;

  double _initialChildSize = 0.5;
  double _minChildSize = 0.075;
  double _maxChildSize = 0.5;
  double _height;

  IconData _icon = Icons.arrow_downward_outlined;

  @override
  void initState() {
    // getNameOfBus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.showBusPathState.setState(() {
        // render the floating button on widget
        widget.showBusPathState.fabPosition = 0.5 * context.size.height;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (DraggableScrollableNotification notification) {
        widget.showBusPathState.setState(() {
          widget.showBusPathState.widgetHeight = context.size.height;
          widget.showBusPathState.dragScrollSheetExtent = notification.extent;
          widget.showBusPathState.fabPosition =
              widget.showBusPathState.dragScrollSheetExtent *
                  widget.showBusPathState.widgetHeight;
        });
        return;
      },
      child: DraggableScrollableSheet(
          initialChildSize: _initialChildSize,
          minChildSize: _minChildSize,
          maxChildSize: _maxChildSize,
          builder: (context, controller) {
            if (controller.hasClients) {
              var dimension = controller.position.viewportDimension;
              _height ??= dimension / _initialChildSize;

              if (dimension >= _height * _maxChildSize * 0.9) {
                _icon = Icons.arrow_downward_outlined;
              } else if (dimension <= _height * _minChildSize * 1.2) {
                _icon = Icons.arrow_upward_outlined;
              }
            }
            return Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: 1,
                controller: controller,
                itemBuilder: (BuildContext context, index) {
                  return Column(children: [
                    Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 5, right: 10),
                        leading: GestureDetector(
                          onTap: () {
                            print(MediaQuery.of(context).size.height *
                                0.5 *
                                0.85 *
                                0.85);
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.black26,
                              child: Icon(
                                _icon,
                                color: Colors.blue,
                              )),
                        ),
                        title: Text(
                          widget.busRoute.name,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        trailing: OutlineButton(
                          onPressed: () {
                            selectedIndex = 0;
                            widget.showBusPathState.setState(() {
                              if (CHECK_DEPARTER_RETURN == 0) {
                                CHECK_DEPARTER_RETURN = 1;
                                _color = Colors.deepOrange;
                                widget.showBusPathState.color = _color;
                                _text = "Chiều về";
                                //cập nhật marker chiều về
                                widget.showBusPathState.getStopPoint(
                                    widget.busRoute.listStopPointReturn);
                                //cập nhật path chiều về
                                widget.showBusPathState
                                    .getPointOfPath(BUS_PATH_RETURN);
                                // di chuyển camera đến điểm đầu của chiều về
                                widget.showBusPathState.mapController.move(
                                    widget.showBusPathState.listPoint[widget
                                            .showBusPathState.listPoint.length -
                                        1],
                                    16);
                              } else {
                                CHECK_DEPARTER_RETURN = 0;
                                _color = Colors.green;
                                widget.showBusPathState.color = _color;
                                _text = "Chiều đi";
                                //cập nhật marker chiều đi
                                widget.showBusPathState.getStopPoint(
                                    widget.busRoute.listStopPointGo);
                                //cập nhật path chiều đi
                                widget.showBusPathState
                                    .getPointOfPath(BUS_PATH_GO);
                                // di chuyển camera đến điểm đầu của chiều đi
                                widget.showBusPathState.mapController.move(
                                    widget.showBusPathState.listPoint[0], 16);
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
                    ),
                    Container(
                      child: DefaultTabController(
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
                            height: 240,
                            child: TabBarView(
                              children: [
                                Container(
                                  color: Colors.redAccent,
                                  child: ListView.builder(
                                      itemCount: 27,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return ListTile(
                                          title: Text('Item ${index + 1}'),
                                        );
                                      }),
                                ),
                                ListNameBusStop(
                                  showBusPathState: widget.showBusPathState,
                                  busInformationState: this,
                                ),
                                Container(
                                  color: Colors.green,
                                  child: ListView.builder(
                                      itemCount: 10,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return ListTile(
                                          title: Text('Item ${index + 1}'),
                                        );
                                      }),
                                )
                              ],
                            ),
                          )
                        ]),
                      ),
                    )
                  ]);
                },
              ),
            );
          }),
    );
  }
}
