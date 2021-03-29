import 'package:emddibus/algothrim/convert_string.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/Home/search_field.dart';
import 'package:emddibus/pages/StopPointDetails/stop_point_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class AddressToOrFrom extends StatefulWidget {
  final String title;

  AddressToOrFrom({this.title});

  @override
  State<StatefulWidget> createState() => AddressToOrFromState();
}

class AddressToOrFromState extends State<AddressToOrFrom> {
  List<StopPoint> _listStopPoint = [];

  ScrollController _scrollController = ScrollController();

  bool _isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _listStopPoint.addAll(STOP_POINT);
    // TODO: implement initState
    super.initState();
  }

  void searchStopPoint(String value) {
    if (value.isNotEmpty) {
      List<StopPoint> data = [];
      STOP_POINT.forEach((element) {
        if (convertString(element.name.toLowerCase())
            .contains(convertString(value.toLowerCase()))) {
          data.add(element);
        }
      });
      setState(() {
        _listStopPoint.clear();
        _listStopPoint.addAll(data);
      });
      return;
    } else {
      setState(() {
        _listStopPoint.clear();
        _listStopPoint.addAll(STOP_POINT);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(child: Text("Địa điểm"),),
              Tab(child: Text("Điểm dừng bus"),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: SearchField(),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(10),
                  color: Colors.amber[200],
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Các điểm đã đi",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.separated(
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Icon(Icons.history),
                          title: Text(
                            "Ngõ 44 Triều Khúc",
                            style: TextStyle(fontSize: 15),
                          ),
                          dense: true,
                          contentPadding: EdgeInsets.only(left: 10),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => Divider(),
                    ))
              ],
            ),
            Container(
              child: GestureDetector(
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
                            searchStopPoint(value);
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
                                  searchStopPoint(searchController.text);
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
                            itemCount: _listStopPoint.length,
                            itemBuilder: (context, index) => _buildCard(context, index),
                            shrinkWrap: true,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildCard(BuildContext context, int index) {
    StopPoint stopPoint = _listStopPoint[index];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
      child: Card(
        child: ListTile(
          onTap: () {
            Navigator.pop(context, stopPoint);
          },
          title: Text(
            stopPoint.name,
            style: TextStyle(),
          ),
          leading: Image.asset(
            'assets/stop_point.png',
            width: 50,
            height: 50,
          ),
          //subtitle: Text('${busRoute.city}'),
        ),
      ),
    );
  }
}
