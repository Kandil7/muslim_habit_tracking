import 'package:geolocator/geolocator.dart' as geolocator;
import '../../di/injection_container.dart' as di;
import '/core/utils/constants.dart';
import '/core/utils/helper.dart';
import '/core/utils/services/shared_pref_service.dart';
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  final SharedPrefService _sharedPrefService = di.sl.get<SharedPrefService>();

  Future<bool> _checkServiceEnabled() async {
    bool isServiceEnabled = await _location.serviceEnabled();

    if (!isServiceEnabled) {
      return await _location.requestService();
    }

    return isServiceEnabled;
  }

  Future<bool> _checkLocationPermission() async {
    PermissionStatus permission = await _location.hasPermission();

    if (permission == PermissionStatus.deniedForever) {
      return false;
    }
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      return permission == PermissionStatus.granted;
    }
    return true;
  }

  Future<void> getLocation() async {
    if (await _checkServiceEnabled()) {
      if (await _checkLocationPermission()) {
        final location = await geolocator.Geolocator.getCurrentPosition();
        await _setLocation(location.latitude, location.longitude);
      }
    } else {
      await _setLocation(24.697079250797515, 46.67124576608985);
    }

    await Helper.setLocationCountyAndCity();
  }

  Future<void> _setLocation(double latitude, double longitude) async {
    await _sharedPrefService.setDouble(
      key: Constants.latitude,
      value: latitude,
    );
    await _sharedPrefService.setDouble(
      key: Constants.longitude,
      value: longitude,
    );
  }
}
