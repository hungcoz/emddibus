import 'package:emddibus/constants.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:emddibus/pages/BusPath/bus_path_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

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

  int selectedIndex = 0;

  double _initialChildSize = 0.5;
  double _minChildSize = 0.08;
  double _maxChildSize = 0.5;

  IconData _icon = Icons.arrow_downward_outlined;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.showBusPathState.setState(() {
        widget.showBusPathState.contextSize = context.size.height;
        widget.showBusPathState.fabPosition = context.size.height * 0.5;
      });
    });

    super.initState();
  }

  void checkGoOrReturn() {
    selectedIndex = 0;
    if (CHECK_DEPARTER_RETURN == 0) {
      widget.showBusPathState.setState(() {
        CHECK_DEPARTER_RETURN = 1;
        _color = Colors.deepOrange;
        widget.showBusPathState.color = _color;
        _text = "Chiều về";
        //cập nhật marker chiều về
        widget.showBusPathState
            .getStopPoint(widget.busRoute.listStopPointReturn);
        //cập nhật path chiều về
        widget.showBusPathState.getPointOfPath(BUS_PATH_RETURN);
        // di chuyển camera đến điểm đầu của chiều về
        widget.showBusPathState.mapController.move(
            LatLng(widget.showBusPathState.listStopPointRoute[0].latitude,
                widget.showBusPathState.listStopPointRoute[0].longitude),
            16);
      });
    } else {
      widget.showBusPathState.setState(() {
        CHECK_DEPARTER_RETURN = 0;
        _color = Colors.green;
        widget.showBusPathState.color = _color;
        _text = "Chiều đi";
        //cập nhật marker chiều đi
        widget.showBusPathState.getStopPoint(widget.busRoute.listStopPointGo);
        //cập nhật path chiều đi
        widget.showBusPathState.getPointOfPath(BUS_PATH_GO);
        // di chuyển camera đến điểm đầu của chiều đi
        widget.showBusPathState.mapController.move(
            LatLng(widget.showBusPathState.listStopPointRoute[0].latitude,
                widget.showBusPathState.listStopPointRoute[0].longitude),
            16);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        widget.showBusPathState.setState(() {
          widget.showBusPathState.widgetHeight = context.size.height;
          widget.showBusPathState.dragScrollSheetExtent = notification.extent;
          widget.showBusPathState.fabPosition =
              widget.showBusPathState.widgetHeight *
                  widget.showBusPathState.dragScrollSheetExtent;
          if (notification.extent >= _initialChildSize * 0.5) {
            _icon = Icons.arrow_downward_outlined;
          } else if (notification.extent < _initialChildSize * 0.5) {
            _icon = Icons.arrow_upward_outlined;
          }
          widget.showBusPathState.animationController.forward();
        });
        return;
      },
      child: DraggableScrollableSheet(
          initialChildSize: _initialChildSize,
          minChildSize: _minChildSize,
          maxChildSize: _maxChildSize,
          builder: (context, controller) {
            return Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: 1,
                controller: controller,
                itemBuilder: (BuildContext context, index) {
                  return Column(children: [
                    Container(
                      height: widget.showBusPathState.contextSize * 0.08,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 5, right: 10),
                        leading: CircleAvatar(
                            backgroundColor: Colors.black26,
                            child: Icon(
                              _icon,
                              color: Colors.blue,
                            )),
                        title: Text(
                          widget.busRoute.name,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        trailing: OutlineButton(
                          onPressed: () {
                            widget.showBusPathState.scrollController.jumpTo(0.0);
                            checkGoOrReturn();
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
                            height: widget.showBusPathState.contextSize * 0.07,
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
                            height: widget.showBusPathState.contextSize * 0.35,
                            child: TabBarView(
                              children: [
                                Container(
                                  color: Colors.redAccent,
                                  child: ListView.builder(
                                      controller: widget
                                          .showBusPathState.scrollController,
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
                                      controller: widget
                                          .showBusPathState.scrollController,
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
