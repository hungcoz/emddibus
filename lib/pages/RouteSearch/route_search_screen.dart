import 'package:emddibus/algothrim/convert_string.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/bus_route_model.dart';
import 'package:emddibus/pages/BusPath/bus_path_screen.dart';
import 'package:emddibus/pages/Loading/loading_dialog.dart';
import 'package:emddibus/services/http_bus_path.dart';
import 'package:flutter/material.dart';

class RouteSearch extends StatefulWidget {
  @override
  _RouteSearchState createState() => _RouteSearchState();
}

class _RouteSearchState extends State<RouteSearch> {
  List<BusRoute> _listBusRoutes = [];

  ScrollController _scrollController = ScrollController();

  bool _isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _listBusRoutes.addAll(BUS_ROUTE);
    super.initState();
  }

  void searchRoute(String value) {
    if (value.isNotEmpty) {
      List<BusRoute> data = [];
      BUS_ROUTE.forEach((element) {
        if (convertString(element.name.toLowerCase())
                .contains(convertString(value.toLowerCase())) ||
            element.routeId.toString().contains(value)) {
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8, 10, 8, 5),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  _isSearching = true;
                  searchRoute(value);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(25, 10, 5, 5),
                  hintText: 'Tìm kiếm...',
                  hintStyle: TextStyle(
                    fontSize: 20,
                  ),
                  suffixIcon: (_isSearching)
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              _isSearching = false;
                            });
                            searchRoute(searchController.text);
                          })
                      : Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _listBusRoutes.length,
                  itemBuilder: (context, index) => _buildCard(context, index),
                  shrinkWrap: true,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    BusRoute busRoute = _listBusRoutes[index];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
      child: Card(
        child: ListTile(
          onTap: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) => LoadingDialog());
            await getBusPathData(busRoute.routeId);
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowBusPath(busRoute: busRoute)));
          },
          title: Text(busRoute.name),
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
          //subtitle: Text('${busRoute.city}'),
        ),
      ),
    );
  }
}
