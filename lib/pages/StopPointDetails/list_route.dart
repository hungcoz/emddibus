import 'package:emddibus/models/bus_route_model.dart';
import 'package:flutter/material.dart';

class ListBus extends StatelessWidget {
  final List<BusRoute> _listBusRoute;
  final List<int> _listDirection;


  ListBus(this._listBusRoute, this._listDirection);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(child: ListView.builder(
      itemCount: _listBusRoute.length,
      itemBuilder: (context, index) => _buildCard(context, index),
    ));
  }

  Widget _buildCard(BuildContext context, int index) {
    BusRoute busRoute = _listBusRoute[index];
    String direction = (_listDirection[index] == 0) ? 'Chiều đi' : 'Chiều về';
    Color directionColor = (_listDirection[index] == 0) ? Colors.green : Colors.redAccent;
    return Padding(padding: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      child: Card(
      child: ListTile(
        onTap: () {},
        leading: CircleAvatar(
          child: Text('${busRoute.routeId}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
          ),
          backgroundColor: Color(0xffeeac24),
        ),
        title: RichText(
          text: TextSpan(
            text: busRoute.name,
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: ' ($direction)',
                style: TextStyle(
                  color: directionColor,
                  fontStyle: FontStyle.italic
                )
              )
            ]
          ),
        ),
      ),
    ),
    );
  }
}
