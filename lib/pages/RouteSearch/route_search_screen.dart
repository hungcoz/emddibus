import 'package:emddibus/constants.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:flutter/material.dart';

class RouteSearch extends StatefulWidget {
  @override
  _RouteSearchState createState() => _RouteSearchState();
}

class _RouteSearchState extends State<RouteSearch> {
  List<BusRoute> _listBusRoutes = [];

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _listBusRoutes.addAll(BUS_ROUTE);
    super.initState();
  }

  void searchRoute(String value){
    if (value.isNotEmpty) {
      List<BusRoute> data = [];
      BUS_ROUTE.forEach((element) {
        if(element.name.toLowerCase().contains(value.toLowerCase()) || element.routeId.toString().contains(value)){
          data.add(element);
        }
      });
      setState(() {
        _listBusRoutes.clear();
        _listBusRoutes.addAll(data);
      });
      return;
    } else {
      setState(() {
        _listBusRoutes.clear();
        _listBusRoutes.addAll(BUS_ROUTE);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Danh sách các tuyến Bus'),
        centerTitle: true,
      ),
    );
  }
}
