import 'package:emddibus/pages/BusPath/bus_path_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class ListNameBusStop extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListNameBusStopState(showBusPathState: showBusPathState);

  final ShowBusPathState showBusPathState;
  ListNameBusStop({this.showBusPathState});
}

class ListNameBusStopState extends State<ListNameBusStop> {
  ShowBusPathState showBusPathState;

  ListNameBusStopState({this.showBusPathState});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: ListView.separated(
        itemCount: showBusPathState.listStopPoint.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(showBusPathState.listStopPoint[index].name),
            onTap: (){
              print(showBusPathState.listStopPoint.length);
              showBusPathState.mapController.move(
                  LatLng(showBusPathState.listStopPoint[index].latitude, showBusPathState.listStopPoint[index].longitude),
                  16
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}