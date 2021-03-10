import 'package:emddibus/pages/BusPath/bus_information.dart';
import 'package:emddibus/pages/BusPath/bus_path_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class ListNameBusStop extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListNameBusStopState(
      showBusPathState: showBusPathState,
      busInformationState: busInformationState,
  );

  final ShowBusPathState showBusPathState;
  final BusInformationState busInformationState;

  ListNameBusStop({this.showBusPathState, this.busInformationState,});
}

class ListNameBusStopState extends State<ListNameBusStop> {
  ShowBusPathState showBusPathState;
  BusInformationState busInformationState;

  ListNameBusStopState({this.showBusPathState, this.busInformationState,});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTileTheme(
      dense: true,
      selectedColor: showBusPathState.color,
      child: ListView.separated(
        itemCount: showBusPathState.listStopPoint.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            selected: index == busInformationState.selectedIndex,
            title: Text(
                showBusPathState.listStopPoint[index].name,
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              showBusPathState.mapController.move(
                  LatLng(showBusPathState.listStopPoint[index].latitude,
                      showBusPathState.listStopPoint[index].longitude),
                  16);
              setState(() {
                busInformationState.selectedIndex = index;
              });
            },
          );
        },
      ),
    );
  }
}
