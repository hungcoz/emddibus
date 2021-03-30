import 'package:emddibus/models/location_model.dart';
import 'package:emddibus/pages/Home/home_screen.dart';
import 'package:emddibus/services/http_search_location.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class SearchField extends StatefulWidget {
  final FocusNode txtSearchFocusNode;
  final MapController mapController;
  final HomeState fMapState;

  SearchField(
      {Key key, this.txtSearchFocusNode, this.mapController, this.fMapState})
      : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Future<ListLocation> future;

  bool _isSearching = false;

  //List<StopPoint> listStopPoint = [];

  TextEditingController searchController = TextEditingController();

  Widget listResult() {
    return FutureBuilder<ListLocation>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              constraints: BoxConstraints(maxHeight: 200),
              child: snapshot.data.listLocation.length > 0
                  ? Scrollbar(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        itemCount: snapshot.data.listLocation.length,
                        itemBuilder: (context, index) =>
                            buildStopPointCard(context, snapshot, index),
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
            );
          }
          return Container(
            height: 50,
            child: Column(children: [
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              SizedBox(
                height: 5,
              ),
              CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ]),
          );
        });
  }

  Widget buildStopPointCard(
      BuildContext context, AsyncSnapshot snapshot, int index) {
    LocationModel location = snapshot.data.listLocation[index];
    return Column(children: [
      Divider(
        color: Colors.grey,
        height: 1,
      ),
      ListTile(
        leading: Icon(Icons.location_on),
        onTap: () {
          // StopPoint tmp = listStopPoint[index];
          setState(() {
            widget.fMapState.markers[widget.fMapState.markers.length - 2] =
                Marker(
                    anchorPos: AnchorPos.align(AnchorAlign.top),
                    point: LatLng(location.lat, location.long),
                    builder: (context) => Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 50,
                        ));
          });
          widget.mapController.move(LatLng(location.lat, location.long), 16);
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

  String textName(LocationModel locationModel) {
    String text = "";
    if (locationModel.building != null)
      text = locationModel.building;
    else if (locationModel.road != null)
      text = locationModel.road;
    else if (locationModel.village != null)
      text = locationModel.village;
    else if (locationModel.town != null)
      text = locationModel.town;
    else if (locationModel.suburb != null)
      text = locationModel.suburb;
    else if (locationModel.county != null)
      text = locationModel.county;
    else if (locationModel.postCode != null)
      text = locationModel.postCode;
    else if (locationModel.state != null) text = locationModel.state;
    return text;
  }

  String text(LocationModel locationModel) {
    String text = "";
    if (locationModel.building != null)
      text = text + locationModel.building + ', ';
    if (locationModel.road != null) text = text + locationModel.road + ', ';
    if (locationModel.village != null)
      text = text + locationModel.village + ', ';
    if (locationModel.town != null) text = text + locationModel.town + ', ';
    if (locationModel.suburb != null) text = text + locationModel.suburb + ', ';
    if (locationModel.county != null) text = text + locationModel.county + ', ';
    if (locationModel.postCode != null) text = text + locationModel.postCode;
    if (locationModel.state != null) text = text + locationModel.state;
    return text;
  }

  // void search(String value) {
  //   if (value.isNotEmpty) {
  //     List<StopPoint> dummyData = <StopPoint>[];
  //     STOP_POINT.forEach((element) {
  //       if (convertString(element.name).contains(convertString(value))) {
  //         dummyData.add(element);
  //       }
  //     });
  //     setState(() {
  //       listStopPoint.clear();
  //       listStopPoint.addAll(dummyData);
  //     });
  //     return;
  //   } else {
  //     setState(() {
  //       listStopPoint.clear();
  //     });
  //   }
  // }

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
              hintText: 'Tìm kiếm địa điểm...',
              hintStyle: TextStyle(fontSize: 18),
              prefixIcon: Icon(Icons.search),
              suffixIcon: searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchController.text = '';
                        //listStopPoint.clear();
                        setState(() {
                          _isSearching = false;
                          widget.fMapState.markers[
                              widget.fMapState.markers.length - 2] = Marker();
                        });
                      }),
            ),
            onChanged: (value) {
              setState(() {
                _isSearching = value.isNotEmpty;
              });
              future = searchLocation(value);
              //search(value);
            },
            onSubmitted: (value) {
              // setState(() {
              //   _isSearching = false;
              // });
              future = searchLocation(value);
              // if (value.isNotEmpty) {
              //   widget.mapController.move(
              //       LatLng(
              //           listStopPoint[0].latitude, listStopPoint[0].longitude),
              //       16);
              //   searchController.text = listStopPoint[0].name;
              // }
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
