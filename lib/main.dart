import 'package:emddibus/pages/Loading/loading_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.black,
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(brightness: Brightness.dark)),
      home: Loading(),
    ),
  );
}
