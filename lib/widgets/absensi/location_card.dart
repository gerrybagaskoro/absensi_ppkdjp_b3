// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationCardState {
  static double? lastLat;
  static double? lastLng;
  static String? lastAddress;
  static double? lastDistance;
}

class LocationCardStateNotifier {
  static final ValueNotifier<double> distanceNotifier = ValueNotifier<double>(
    double.infinity,
  );
}

class LocationCard extends StatefulWidget {
  final void Function(double lat, double lng, String address, double distance)?
  onLocationUpdated;

  const LocationCard({super.key, this.onLocationUpdated});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  GoogleMapController? mapController;
  LatLng _currentPosition = const LatLng(-6.200000, 106.816666);
  double _distanceToTarget = 0;
  String _currentAddress = "Alamat tidak ditemukan";

  // Lokasi PPKDJP
  final LatLng _targetLocation = const LatLng(-6.200123, 106.816789);

  Stream<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  void _startLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );

    _positionStream?.listen((position) {
      _updateLocation(position);
    });
  }

  Future<void> _updateLocation(Position position) async {
    final newPos = LatLng(position.latitude, position.longitude);

    // Reverse geocoding
    String address = "Alamat tidak ditemukan";
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        newPos.latitude,
        newPos.longitude,
      );
      final place = placemarks.isNotEmpty ? placemarks[0] : null;
      if (place != null) {
        address =
            "${place.name ?? ''}${place.street != null && place.street!.isNotEmpty ? ', ${place.street}' : ''}, ${place.locality ?? ''}${place.country != null ? ', ${place.country}' : ''}"
                .replaceAll(RegExp(r',\s*,+'), ',')
                .replaceAll(RegExp(r'^\s*,\s*'), '')
                .trim();
      }
    } catch (_) {}

    // Hitung jarak ke target
    final distance = Geolocator.distanceBetween(
      newPos.latitude,
      newPos.longitude,
      _targetLocation.latitude,
      _targetLocation.longitude,
    );

    if (!mounted) return;

    setState(() {
      _currentPosition = newPos;
      _currentAddress = address;
      _distanceToTarget = distance;
    });

    // Update static holder
    LocationCardState.lastLat = position.latitude;
    LocationCardState.lastLng = position.longitude;
    LocationCardState.lastAddress = _currentAddress;
    LocationCardState.lastDistance = distance;

    // Update notifier untuk dashboard
    LocationCardStateNotifier.distanceNotifier.value = distance;

    // Callback ke dashboard
    widget.onLocationUpdated?.call(
      position.latitude,
      position.longitude,
      _currentAddress,
      distance,
    );

    // Animate camera ke posisi user
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 16),
      ),
    );
  }

  String _formatDistance(double distanceMeters) {
    if (distanceMeters < 1000) {
      return "${distanceMeters.toStringAsFixed(0)} m";
    } else {
      return "${(distanceMeters / 1000).toStringAsFixed(2)} km";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 250,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 16,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                markers: {
                  Marker(
                    markerId: const MarkerId('ppkdjp'),
                    position: _targetLocation,
                    infoWindow: const InfoWindow(title: 'PPKDJP Jakpus'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
                    ),
                  ),
                },
                onMapCreated: (controller) => mapController = controller,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alamat Anda: $_currentAddress",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  "Jarak ke PPKDJP: ${_formatDistance(_distanceToTarget)}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _distanceToTarget <= 50 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
