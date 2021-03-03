<<<<<<< HEAD:lib/menu.dart
import 'dart:io';

// import 'package:emddi_bus/info_user.dart';
// import 'package:emddi_bus/search.dart';
import 'package:emddibus/constants.dart';
=======
>>>>>>> 705f77bdcb41d011f523d3ec5adf94d93fe0e1e2:lib/widgets/drawer.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MenuState();
}

<<<<<<< HEAD:lib/menu.dart
  // File file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

=======
class _MenuState extends State<Menu> {
>>>>>>> 705f77bdcb41d011f523d3ec5adf94d93fe0e1e2:lib/widgets/drawer.dart
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
    // TODO: implement build
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
                      color: Colors.amber,
                    ),
                    //padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
                    // child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     // user
                    //     Row(
                    //       children: [
                    //         GestureDetector(
                    //           onTap: ()async{
                    //             // final result = await Navigator.push(
                    //             //     context,
                    //             //     MaterialPageRoute(builder: (context) => InfoUser()));
                    //             // setState(() {
                    //             //   FILE_AVATAR = result;
                    //             // });
                    //           },
                    //           // child: _getWidgetImage(),
                    //           child: CircleAvatar(
                    //                   radius: 40,
                    //                   backgroundImage: AssetImage(PATH_AVATAR),
                    //           )
                    //         ),
                    //         Container(
                    //           margin: EdgeInsets.only(left: 15),
                    //           child: Text(PHONE),
                    //         ),
                    //       ],
                    //     ),
                    //     //language
                    //     Container(
                    //       margin: EdgeInsets.only(top: 15),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           //vietnamese
                    //           FlatButton(
                    //             padding: EdgeInsets.only(left: 0),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               children: [
                    //                 ClipRRect(
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                   child: Image(
                    //                     fit: BoxFit.cover,
                    //                     image: AssetImage('images/vietnam.png'),
                    //                     width: 40,
                    //                     height: 30,
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   margin: EdgeInsets.only(left: 5),
                    //                   child: Text(
                    //                     "Tiếng Việt",
                    //                     style: TextStyle(color: Colors.black),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           //english
                    //           FlatButton(
                    //             child: Row(
                    //               children: [
                    //                 ClipRRect(
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                   child: Image(
                    //                     fit: BoxFit.cover,
                    //                     image: AssetImage(
                    //                       'images/UK.png',
                    //                     ),
                    //                     width: 40,
                    //                     height: 30,
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                     margin: EdgeInsets.only(left: 5),
                    //                     child: Text(
                    //                       "Tiếng Anh",
                    //                       style: TextStyle(color: Colors.black),
                    //                     ))
                    //               ],
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    leading: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Trang chủ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.directions_bus,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Tra cứu các tuyến bus",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Tra cứu các điểm dừng",
                      style: TextStyle(color: Colors.white),
                    ),
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
