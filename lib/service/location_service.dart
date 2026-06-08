import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("GPS tidak aktif");

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Izin lokasi ditolak");
    }

    return await Geolocator.getCurrentPosition();
  }
}