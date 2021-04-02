import 'dart:async';

import 'package:emddibus/pages/Loading/loading_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
    theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.light),
    home: Loading(),
  ));
}
// void main() => runApp(MaterialApp(home: HomePage()));
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   static double _height = 100, _one = -_height, _two = _height;
//   final double _oneFixed = -_height;
//   final double _twoFixed = _height;
//   Duration _duration = Duration(milliseconds: 5);
//   bool _top = false, _bottom = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Slide")),
//       body: SizedBox(
//         height: _height,
//         child: Stack(
//           children: <Widget>[
//             Positioned(
//               left: 0,
//               right: 0,
//               height: _height,
//               child: GestureDetector(
//                 onVerticalDragEnd: (details) {
//                   if (details.velocity.pixelsPerSecond.dy >= 0) _toggleTop();
//                   else _toggleBottom();
//                 },
//                 child: _myContainer(
//                   color: Colors.yellow[800],
//                   text: "Old Container",
//                   child1: IconButton(
//                     icon: Icon(Icons.arrow_downward),
//                     onPressed: _toggleTop,
//                   ),
//                   child2: IconButton(
//                     icon: Icon(Icons.arrow_upward),
//                     onPressed: _toggleBottom,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 0,
//               right: 0,
//               top: _one,
//               height: _height,
//               child: GestureDetector(
//                 onTap: _toggleTop,
//                 onPanEnd: (details) => _toggleTop(),
//                 onPanUpdate: (details) {
//                   _one += details.delta.dy;
//                   if (_one >= 0) _one = 0;
//                   if (_one <= _oneFixed) _one = _oneFixed;
//                   setState(() {});
//                 },
//                 child: _myContainer(
//                   // color: _one >= _oneFixed + 1 ? Colors.red[800] : Colors.transparent,
//                   color: Colors.red[800],
//                   text: "Upper Container",
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 0,
//               right: 0,
//               top: _two,
//               height: _height,
//               child: GestureDetector(
//                 onTap: _toggleBottom,
//                 onPanEnd: (details) => _toggleBottom(),
//                 onPanUpdate: (details) {
//                   _two += details.delta.dy;
//                   if (_two <= 0) _two = 0;
//                   if (_two >= _twoFixed) _two = _twoFixed;
//                   setState(() {});
//                 },
//                 child: _myContainer(
//                   // color: _two <= _twoFixed - 1 ? Colors.green[800] : Colors.transparent,
//                   color: Colors.green[800],
//                   text: "Bottom Container",
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _toggleTop() {
//     _top = !_top;
//     Timer.periodic(_duration, (timer) {
//       if (_top) _one += 2;
//       else _one -= 2;
//
//       if (_one >= 0) {
//         _one = 0;
//         timer.cancel();
//       }
//       if (_one <= _oneFixed) {
//         _one = _oneFixed;
//         timer.cancel();
//       }
//       setState(() {});
//     });
//   }
//
//   void _toggleBottom() {
//     _bottom = !_bottom;
//     Timer.periodic(_duration, (timer) {
//       if (_bottom) _two -= 2;
//       else _two += 2;
//
//       if (_two <= 0) {
//         _two = 0;
//         timer.cancel();
//       }
//       if (_two >= _twoFixed) {
//         _two = _twoFixed;
//         timer.cancel();
//       }
//       setState(() {});
//     });
//   }
//
//   Widget _myContainer({Color color, String text, Widget child1, Widget child2, Function onTap}) {
//     Widget child;
//     if (child1 == null || child2 == null) {
//       child = Text(text, style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold));
//     } else {
//       child = Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           child1,
//           child2,
//         ],
//       );
//     }
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         color: color,
//         alignment: Alignment.center,
//         child: child,
//       ),
//     );
//   }
// }
