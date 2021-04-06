import 'package:emddibus/models/foot_path_model.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart';

const String url = 'https://router.project-osrm.org/route/v1/foot/';
const String option = '?skip_waypoints=true&steps=false&geometries=geojson';

Future<FootPath> directionFoot(LatLng start, LatLng end) async {
  final response = await get(
      '$url${start.longitude},${start.latitude};${end.longitude},${end.latitude}$option');
  if (response.statusCode == 200) {
    return footPathFromJson(response.body);
  } else
    throw Exception('Error');
}

// directionFoot(currentPosition,
//         LatLng(dataSearch.lat, dataSearch.long))
//     .then((value) {
//   setState(() {
//     //set list lat long polyline
//     polyline = value.routes[0].geometry.coordinates;
//     //set double distance
//     distance = value.routes[0].distance;
//   });
// });
