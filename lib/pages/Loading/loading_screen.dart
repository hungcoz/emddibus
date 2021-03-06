import 'package:emddibus/constants.dart';
import 'package:emddibus/pages/Home/home_screen.dart';
import 'package:emddibus/services/http_stop_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:emddibus/services/http_bus_route.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getData() async {
    //await Future.delayed(Duration(seconds: 3));
    await getBusRouteData();
    await getStopPointData();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    CONTEXT_SIZE = MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    print(CONTEXT_SIZE);
    return Scaffold(
      backgroundColor: Color(0xff1e1e1e),
      body: Center(
        child: Container(
          width: 200,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset('assets/EMDDI_1.jpg'),
            Text(
              'Đang kết nối với máy chủ...',
              style: TextStyle(color: Colors.white),
            )
          ]),
        ),
      ),
    );
  }
}
