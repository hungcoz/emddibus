import 'package:emddibus/pages/Home/fmap_screen.dart';
import 'package:emddibus/pages/Loading/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location/flutter_map_location.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Color(0xffeeac24)),
    home: Loading(),
  ));
}
