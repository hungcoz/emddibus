import 'package:emddibus/pages/Loading/loading_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
    theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.light),
    home: Loading(),
  ));
}
