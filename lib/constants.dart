import 'package:latlong/latlong.dart';

import 'models/bus_position_model.dart';
import 'models/bus_route_model.dart';
import 'models/stop_point_model.dart';
import 'models/bus_path_model.dart';

const String URL = 'api_url';

LatLng currentPosition;

List<StopPoint> STOP_POINT;
List<BusRoute> BUS_ROUTE;
List<PointOfBusPath> BUS_PATH_GO;
List<PointOfBusPath> BUS_PATH_RETURN;
int CHECK_DEPARTER_RETURN = 0;

int TRACKING_REQUEST = 1;
List<BusPosition> BUS_POSITION;