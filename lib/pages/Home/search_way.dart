import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/Home/result_of_search_way.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'address_to_or_from.dart';

class SearchWay extends StatefulWidget {
  final ResultSearchState resultSearchState;

  SearchWay({this.resultSearchState});

  @override
  State<StatefulWidget> createState() => SearchWayState();

}

class SearchWayState extends State<SearchWay> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 8,
          child: Column(
            children: [
              Card(
                shadowColor: Colors.grey,
                margin: EdgeInsets.only(top: 5, left: 5),
                child: ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: Colors.green,
                  ),
                  title: Container(
                    // origin: Offset(0, 10.0),
                    child: Text(
                      widget.resultSearchState.addressFrom,
                      style: TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  dense: true,
                  onTap: () async {
                    widget.resultSearchState.start = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressToOrFrom(
                                title: "Chọn điểm bắt đầu")));
                    setState(() {
                      if (widget.resultSearchState.start != null) {
                        widget.resultSearchState.tmpStart = widget.resultSearchState.start;
                        widget.resultSearchState.addressFrom = widget.resultSearchState.tmpStart.name;

                      }
                    });
                  },
                ),
              ),
              Card(
                shadowColor: Colors.grey,
                margin: EdgeInsets.only(top: 5, left: 5, bottom: 5),
                child: ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: Colors.orangeAccent,
                  ),
                  title: Text(
                    widget.resultSearchState.addressTo,
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  dense: true,
                  onTap: () async {
                    widget.resultSearchState.target = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressToOrFrom(
                                title: "Chọn điểm kết thúc")));
                    setState(() {
                      if (widget.resultSearchState.target != null) {
                        widget.resultSearchState.tmpTarget = widget.resultSearchState.target;
                        widget.resultSearchState.addressTo = widget.resultSearchState.tmpTarget.name;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.swap_vert,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                if (!widget.resultSearchState.addressFrom.contains("Điểm bắt đầu") &&
                    !widget.resultSearchState.addressTo.contains("Điểm kết thúc")) {
                  setState(() {
                    String tmp = widget.resultSearchState.addressTo;
                    widget.resultSearchState.addressTo = widget.resultSearchState.addressFrom;
                    widget.resultSearchState.addressFrom = tmp;
                    StopPoint tmp1 = widget.resultSearchState.tmpStart;
                    widget.resultSearchState.tmpStart = widget.resultSearchState.tmpTarget;
                    widget.resultSearchState.tmpTarget = tmp1;
                  });
                }
              },
            ),
          ),
        )
      ],
    );
  }
}