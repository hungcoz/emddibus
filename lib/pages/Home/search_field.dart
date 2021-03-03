import 'package:emddibus/models/stop_point_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

import '../../constants.dart';

class SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  bool _isSearching = false;

  List<StopPoint> listBusStop = [];

  TextEditingController searchController = TextEditingController();

  Widget listResult() {
    return _isSearching
        ? Container(
            constraints: BoxConstraints(maxHeight: 200),
            child: listBusStop.length > 0
                ? Scrollbar(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 0),
                      itemCount: listBusStop.length,
                      itemBuilder: (context, index) =>
                          buildBusStopCard(context, index),
                      shrinkWrap: true,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    height: 30,
                    child: Center(
                      child: Text(
                        'Không tìm thấy kết quả',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
          )
        : null;
  }

  Widget buildBusStopCard(BuildContext context, int index) {
    StopPoint busStop = listBusStop[index];
    return Column(children: [
      Divider(
        color: Colors.grey,
        height: 1,
      ),
      ListTile(
        onTap: () {
          mapController.move(
              LatLng(listBusStop[index].latitude, listBusStop[index].longitude),
              15);
          setState(() {
            _isSearching = false;
            searchController.text = busStop.name;
            searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: searchController.text.length));
          });
        },
        title: Text(
          '${busStop.name}',
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text('Tuyến chạy qua: '),
      ),
    ]);
  }

  void search(String value) {
    if (value.isNotEmpty) {
      List<StopPoint> dummyData = <StopPoint>[];
      STOP_POINT.forEach((element) {
        if (element.name.toLowerCase().contains(value.toLowerCase())) {
          dummyData.add(element);
        }
      });
      setState(() {
        listBusStop.clear();
        listBusStop.addAll(dummyData);
      });
      return;
    } else {
      setState(() {
        listBusStop.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 15,
      left: 15,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _isSearching ? Colors.white : Colors.white70,
          border: Border.all(color: Colors.grey[800], width: 2),
        ),
        child: Column(children: [
          TextField(
            style: TextStyle(fontSize: 18),
            controller: searchController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              hintText: 'Tìm kiếm điểm dừng...',
              hintStyle: TextStyle(fontSize: 18),
              suffixIcon: searchController.text.isEmpty
                  ? Icon(Icons.search)
                  : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchController.text = '';
                        listBusStop.clear();
                        setState(() {
                          _isSearching = false;
                        });
                      }),
            ),
            onChanged: (value) {
              setState(() {
                _isSearching = value.isNotEmpty;
              });
              search(value);
            },
            onSubmitted: (value) {
              setState(() {
                _isSearching = false;
              });
              if (value.isNotEmpty) {
                mapController.move(
                    LatLng(listBusStop[0].latitude, listBusStop[0].longitude),
                    16);
                searchController.text = listBusStop[0].name;
              }
            },
          ),
          Container(
            child: _isSearching ? listResult() : null,
          ),
        ]),
      ),
    );
  }
}
