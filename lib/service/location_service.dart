import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  // Location Service
  Future<bool> checkAndRequestLocationService() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        return false;
      }
    }
    return true;
  }

  Future<bool> checkAndRequestLocationPermission() async {
    var premissionStatus = await location.hasPermission();
    if (premissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (premissionStatus == PermissionStatus.denied) {
      premissionStatus = await location.requestPermission();
      return premissionStatus == PermissionStatus.granted;
    }

    return true;
  }


  void getRealTimeLocationData( void Function(LocationData)? onData)async{
    location.changeSettings(
      distanceFilter: 2
    );
    location.onLocationChanged.listen(onData);

  }
}
