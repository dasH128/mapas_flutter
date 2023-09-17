import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final userLocationProvider =
    FutureProvider.autoDispose<(double, double)>((ref) async {
  bool serviceEnabled;
  LocationPermission permission;
  
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw ('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw ('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw ('Location permissions are permanently denied, we cannot request permissions.');
  }

  final location = await Geolocator.getCurrentPosition();

  return (location.latitude, location.longitude);
});
