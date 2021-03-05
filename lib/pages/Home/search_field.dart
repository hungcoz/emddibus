import 'package:emddibus/models/stop_point_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../constants.dart';

class SearchField extends StatefulWidget {
  final FocusNode txtSearchFocusNode;
  final MapController mapController;
  SearchField({Key key, this.txtSearchFocusNode, this.mapController}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  bool _isSearching = false;

  List<StopPoint> listStopPoint = [];

  TextEditingController searchController = TextEditingController();

  Widget listResult() {
    return _isSearching
        ? Container(
            constraints: BoxConstraints(maxHeight: 200),
            child: listStopPoint.length > 0
                ? Scrollbar(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 0),
                      itemCount: listStopPoint.length,
                      itemBuilder: (context, index) =>
                          buildStopPointCard(context, index),
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

  Widget buildStopPointCard(BuildContext context, int index) {
    StopPoint point = listStopPoint[index];
    return Column(children: [
      Divider(
        color: Colors.grey,
        height: 1,
      ),
      ListTile(
        onTap: () {
          StopPoint tmp = listStopPoint[index];
          widget.mapController.move(
              LatLng(listStopPoint[index].latitude, listStopPoint[index].longitude),
              16);
          listStopPoint.clear();
          listStopPoint.add(tmp);
          setState(() {
            _isSearching = false;
            searchController.text = point.name;
            searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: searchController.text.length));
          });
          widget.txtSearchFocusNode.unfocus();
        },
        title: Text(
          '${point.name}',
          style: TextStyle(fontSize: 18),
        ),
        //subtitle: Text('Tuyến chạy qua: '),
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
        listStopPoint.clear();
        listStopPoint.addAll(dummyData);
      });
      return;
    } else {
      setState(() {
        listStopPoint.clear();
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
            focusNode: widget.txtSearchFocusNode,
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
                        listStopPoint.clear();
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
                widget.mapController.move(
                    LatLng(listStopPoint[0].latitude, listStopPoint[0].longitude),
                    16);
                searchController.text = listStopPoint[0].name;
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
