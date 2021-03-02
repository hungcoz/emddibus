import 'package:emddibus/pages/Loading/loading.dart';
import 'package:emddibus/pages/Home/fmap.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Color(0xffeeac24)),
    home: Loading(),
    // routes: {
    //   '/map': (context) => FMap(),
    // },
  ));
}