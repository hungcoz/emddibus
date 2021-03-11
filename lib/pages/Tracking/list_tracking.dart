import 'package:emddibus/algothrim/function.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/bus_position_model.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';

class ListTracking extends StatefulWidget {
  final StopPoint stopPoint;
  final List<BusPosition> listBusPosition;

  ListTracking({this.stopPoint, this.listBusPosition});

  @override
  _ListTrackingState createState() => _ListTrackingState();
}

class _ListTrackingState extends State<ListTracking> {
  List<BusRoute> _listBusRoute = [];
  List<int> _listDirection = [];

  filterRoute() {
    widget.listBusPosition.forEach((bus) {
      BUS_ROUTE.forEach((route) {
        if (bus.routeId == route.routeId) {
          _listBusRoute.add(route);
        }
      });
      _listDirection.add(bus.direction);
    });
  }

  @override
  void initState() {
    filterRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
      itemCount: widget.listBusPosition.length,
      itemBuilder: (context, index) => _buildCard(context, index),
    ));
  }

  Widget _buildCard(BuildContext context, int index) {
    BusPosition busPosition = widget.listBusPosition[index];
    BusRoute busRoute = _listBusRoute[index];
    String direction = (_listDirection[index] == 0) ? 'Chiều đi' : 'Chiều về';
    Color directionColor =
        (_listDirection[index] == 0) ? Colors.green : Colors.redAccent;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      child: Card(
        child: ListTile(
          onTap: () {},
          leading: CircleAvatar(
            child: Text(
              '${busRoute.routeId}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            backgroundColor: Color(0xffeeac24),
          ),
          title: RichText(
            text: TextSpan(
                text: busRoute.name,
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                      text: ' ($direction)',
                      style: TextStyle(
                          color: directionColor, fontStyle: FontStyle.italic))
                ]),
          ),
          subtitle: Text('Khoảng cách: ' +
              calculateDistance(
                  LatLng(busPosition.latitude, busPosition.longitude),
                  LatLng(
                      widget.stopPoint.latitude, widget.stopPoint.longitude)) +
              ' km'),
        ),
      ),
    );
  }
}
