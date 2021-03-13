import 'package:emddibus/pages/BusPath/bus_information.dart';
import 'package:emddibus/pages/BusPath/bus_path_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class ListNameBusStop extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListNameBusStopState();

  final ShowBusPathState showBusPathState;
  final BusInformationState busInformationState;

  ListNameBusStop({
    this.showBusPathState,
    this.busInformationState,
  });
}

class ListNameBusStopState extends State<ListNameBusStop> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTileTheme(
      dense: true,
      selectedColor: widget.showBusPathState.color,
      child: ListView.separated(
        controller: widget.showBusPathState.scrollController,
        reverse: false,
        itemCount: widget.showBusPathState.listStopPointRoute.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            selected: index == widget.busInformationState.selectedIndex,
            title: Text(
              widget.showBusPathState.listStopPointRoute[index].name,
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              widget.showBusPathState.mapController.move(
                  LatLng(
                      widget
                          .showBusPathState.listStopPointRoute[index].latitude,
                      widget.showBusPathState.listStopPointRoute[index]
                          .longitude),
                  16);
              setState(() {
                widget.busInformationState.selectedIndex = index;
              });
            },
          );
        },
      ),
    );
  }
}
