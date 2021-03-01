import 'package:emddibus/pages/Loading/loading.dart';
import 'package:emddibus/pages/Map/fmap.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Color(0xffeeac24)),
    home: FMap(),
    // routes: {
    //   '/map': (context) => FMap(),
    // },
  ));
}