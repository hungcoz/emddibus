import 'package:emddibus/constants.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/StopPointDetails/list_route.dart';
import 'package:flutter/material.dart';

class StopPointDetail extends StatefulWidget {
  final StopPoint stopPoint;

  StopPointDetail(this.stopPoint);

  @override
  _StopPointDetailState createState() => _StopPointDetailState();
}

class _StopPointDetailState extends State<StopPointDetail> {

  List<BusRoute> _listBusRoute = [];
  List<int> _listDirection = [];

  void filterRoute(stopPoint){
    BUS_ROUTE.forEach((route) {
      route.listStopPointGo.forEach((point) {
        if(stopPoint.stopId == point){
          _listBusRoute.add(route);
          _listDirection.add(0);
        }
      });
      route.listStopPointReturn.forEach((point) {
        if (stopPoint.stopId == point) {
          _listBusRoute.add(route);
          _listDirection.add(1);
        }
      });
    });
  }

  @override
  void initState() {
    filterRoute(widget.stopPoint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stopPoint.name),
        centerTitle: true,
      ),
      body: ListBus(_listBusRoute, _listDirection),
    );
  }
}
