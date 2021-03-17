import 'package:emddibus/models/location_model.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/Home/fmap_screen.dart';
import 'package:emddibus/services/http_search_location.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../constants.dart';

class SearchField extends StatefulWidget {
  final FocusNode txtSearchFocusNode;
  final MapController mapController;
  final FMapState fMapState;

  SearchField({Key key, this.txtSearchFocusNode, this.mapController, this.fMapState})
      : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Future<ListLocation> future;

  bool _isSearching = false;

  List<StopPoint> listStopPoint = [];

  TextEditingController searchController = TextEditingController();

  Widget listResult() {
    return _isSearching
        ? FutureBuilder<ListLocation>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  constraints: BoxConstraints(maxHeight: 200),
                  child: snapshot.data.listLocation.length > 0
                      ? Scrollbar(
                          child: ListView.separated(
                            padding: EdgeInsets.only(top: 0),
                            itemCount: snapshot.data.listLocation.length,
                            itemBuilder: (context, index) =>
                                buildStopPointCard(context, snapshot, index),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => Divider(),
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
                );
              }
              return CircularProgressIndicator();
            })
        : null;
  }

  Widget buildStopPointCard(BuildContext context, AsyncSnapshot snapshot, int index) {
    LocationModel location = snapshot.data.listLocation[index];
    return Column(children: [
      // Divider(
      //   color: Colors.grey,
      //   height: 1,
      // ),
      ListTile(
        leading: Icon(Icons.location_on),
        onTap: () {
          // StopPoint tmp = listStopPoint[index];
          widget.fMapState.setState(() {
            widget.fMapState.markers.removeLast();
            widget.fMapState.markers.removeLast();
            widget.fMapState.markers.add(Marker(
                point: LatLng(location.lat,
                    location.long),
                builder: (context) => Icon(Icons.location_on, color: Colors.green,)
            ));
            widget.fMapState.markers.add(Marker());
          });
          widget.mapController.move(
              LatLng(location.lat,
                  location.long),
              16);
          // listStopPoint.clear();
          // listStopPoint.add(tmp);
          setState(() {
            _isSearching = false;
            searchController.text = text(location);
            searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: searchController.text.length));
          });
          widget.txtSearchFocusNode.unfocus();
        },
        title: Text(
          textName(location),
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(text(location)),
      ),
    ]);
  }

  String textName(LocationModel locationModel){
    String text = "";
    if(locationModel.building != null)
      text = locationModel.building;
    else if(locationModel.road != null)
      text = locationModel.road;
    else if(locationModel.village != null)
      text = locationModel.village;
    else if(locationModel.town != null)
      text = locationModel.town;
    else if(locationModel.suburb != null)
      text = locationModel.suburb;
    else if(locationModel.county != null)
      text = locationModel.county;
    else if(locationModel.postCode != null)
      text = locationModel.postCode;
    else if(locationModel.state != null)
      text = locationModel.state;
    return text;
  }

  String text(LocationModel locationModel){
    String text = "";
    if(locationModel.building != null)
      text = text + locationModel.building + ',';
    if(locationModel.road != null)
      text = text + locationModel.road + ',';
    if(locationModel.village != null)
      text = text + locationModel.village + ',';
    if(locationModel.town != null)
      text = text + locationModel.town + ',';
    if(locationModel.suburb != null)
      text = text + locationModel.suburb + ',';
    if(locationModel.county != null)
      text = text + locationModel.county + ',';
    if(locationModel.postCode != null)
      text = text + locationModel.postCode;
    if(locationModel.state != null)
      text = text + locationModel.state;
    return text;
  }

  String convertString(String str) {
    var withDia =
        'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữìíịỉĩđỳýỵỷỹ';
    var withoutDia =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeooooooooooooooooouuuuuuuuuuuiiiiidyyyyy';

    str = str.toLowerCase();
    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }
    return str;
  }

  void search(String value) {
    if (value.isNotEmpty) {
      List<StopPoint> dummyData = <StopPoint>[];
      STOP_POINT.forEach((element) {
        if (convertString(element.name).contains(convertString(value))) {
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 15,
      left: 15,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: _isSearching ? Colors.white : Colors.white70,
          border: Border.all(color: Colors.grey[500], width: 2),
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
              prefixIcon: Icon(Icons.search),
              suffixIcon: searchController.text.isEmpty
                  ? null
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
                future = searchLocation(value);
                // searchLocation(value);
                _isSearching = value.isNotEmpty;
              });
              search(value);
            },
            onSubmitted: (value) {
              setState(() {
                // future = searchLocation(value);
                // searchLocation(value);
                _isSearching = false;
              });
              if (value.isNotEmpty) {
                widget.mapController.move(
                    LatLng(
                        listStopPoint[0].latitude, listStopPoint[0].longitude),
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
