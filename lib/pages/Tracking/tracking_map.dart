import 'package:emddibus/algothrim/function.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/bus_path_model.dart';
import 'package:emddibus/models/bus_position_model.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/Map/map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';

class TrackingMap extends StatefulWidget {
  final BusPosition bus;
  final StopPoint stopPoint;
  final BusRoute busRoute;

  TrackingMap({this.bus, this.stopPoint, this.busRoute});

  @override
  _TrackingMapState createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  List<LatLng> listPoint = [];
  List<Marker> markers = [];

  BusPosition busPosition;

  Stream fetchData() {
    BUS_POSITION.forEach((bus) {
      if (bus.busId == widget.bus.busId) {
        setState(() {
          busPosition = bus;
        });
      }
    });
    print('Stream');
  }

  getPointOfPath(List<PointOfBusPath> listPointOfBusPath) {
    listPoint.clear();
    listPointOfBusPath.forEach((element) {
      listPoint.add(LatLng(element.latitude, element.longitude));
    });
  }

  getMarker(List<dynamic> listStopPoint) {
    STOP_POINT.forEach((point) {
      if (point.stopId == listStopPoint[0] ||
          point.stopId == listStopPoint[listStopPoint.length - 1]) {
        markers.add(Marker(
          height: 50,
          width: 50,
          point: LatLng(point.latitude, point.longitude),
          builder: (context) => Container(
            child: IconButton(
              icon: Image.asset('assets/stop_point.png'),
              onPressed: () {},
            ),
          ),
        ));
      }
    });
    markers.add(Marker(
      width: 50,
      height: 50,
      point: LatLng(widget.stopPoint.latitude, widget.stopPoint.longitude),
      builder: (context) => Container(
        child: IconButton(
          icon: Image.asset('assets/stop_point.png'),
          onPressed: () {},
        ),
      ),
    ));
    markers.add(Marker());
  }

  @override
  void initState() {
    getMarker((widget.bus.direction == 0)
        ? widget.busRoute.listStopPointGo
        : widget.busRoute.listStopPointReturn);
    getPointOfPath((widget.bus.direction == 0) ? BUS_PATH_GO : BUS_PATH_RETURN);
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tuyến ${widget.bus.routeId}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Map(
              initialCamera: LatLng(widget.bus.latitude, widget.bus.longitude),
              initialZoom: 16,
              markers: markers,
              listPoint: listPoint,
              color: Colors.blue,
            ),
          ),
          Container(
            child: Column(
              children: [
                Text(widget.bus.busId.toString()),
                Text(widget.busRoute.name),
                Text('Khoảng cách: ' +
                    calculateDistance(
                            LatLng(busPosition.latitude, busPosition.longitude),
                            LatLng(widget.stopPoint.latitude,
                                widget.stopPoint.longitude))
                        .toStringAsFixed(2)
                        .toString() +
                    ' km')
              ],
            ),
          )
        ],
      ),
    );
  }
}
