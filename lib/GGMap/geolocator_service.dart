import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  final Geolocator geo = new Geolocator();

  Stream<Position> getCurrentLocation(){
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.best);
    return geo.getPositionStream(locationOptions);
  }

  Future<Position> getInitialLocation() async {
    return geo.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }
}