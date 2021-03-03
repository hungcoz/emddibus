import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'models/stop_point_model.dart';

MapController mapController = MapController();

LatLng currentPosition;

List<StopPoint> STOP_POINT;
