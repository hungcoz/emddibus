import 'file:///D:/Flutter%20App/emddibus/lib/pages/Loading/loading.dart';
import 'package:emddibus/pages/Map/fmap.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Color(0xffeeac24)),
    home: Loading(),
    routes: {
      '/map': (context) => FMap(),
    },
  ));
}