import 'package:emddibus/pages/RouteSearch/route_search_screen.dart';
import 'package:emddibus/pages/StopPointSearch/stop_point_search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  //link to phone
  _launchCaller() async {
    const url = "tel:1800 8888";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black38,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: [
                  DrawerHeader(
                    child: Image.asset('assets/EMDDI_2.png'),
                    margin: EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    leading: Image.asset(
                      'assets/home.png',
                      width: 40,
                      height: 40,
                    ),
                    // Icon(
                    //   Icons.home,
                    //   color: Colors.white,
                    // ),
                    title: Text(
                      "Trang chủ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/bus_icon.png',
                      width: 40,
                      height: 40,
                    ),
                    // Icon(
                    //   Icons.directions_bus,
                    //   color: Colors.white,
                    // ),
                    title: Text(
                      "Tra cứu các tuyến bus",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RouteSearch()));
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/stop_point.png',
                      width: 40,
                      height: 40,
                    ),
                    // Icon(
                    //   Icons.search,
                    //   color: Colors.white,
                    // ),
                    title: Text(
                      "Tra cứu các điểm dừng",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StopPointSearch()));
                    },
                  ),
                ],
              ),
            ),
            //hotline
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: OutlineButton(
                onPressed: _launchCaller,
                borderSide: BorderSide(
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_phone,
                      color: Colors.white,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(
                        "Hotline: 1800 8888",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
