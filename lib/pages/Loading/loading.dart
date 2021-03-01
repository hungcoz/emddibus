import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getData() async {
    Navigator.pushReplacementNamed(context, '/map');
  }

  @override
  void initState() {
    super.initState();
    // geoService.getInitialLocation();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1e1e1e),
      body: Center(
        child: Container(
          width: 200,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset('assets/EMDDI.jpg'),
            Text(
              'Connecting to Internet...',
              style: TextStyle(color: Colors.white),
            )
          ]),
        ),
      ),
    );
  }
}
