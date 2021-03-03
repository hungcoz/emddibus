import 'package:emddibus/pages/Home/fmap_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location/flutter_map_location.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => FMap()), (route) => false);
    });
  }

  @override
  void initState() {
    super.initState();
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
            Image.asset('assets/EMDDI_1.jpg'),
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
