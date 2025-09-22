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
  LatLng _currentPosition = const LatLng(
    -6.210932,
    106.813075,
  ); // Lokasi awal view maps
  double _distanceToTarget = 0;
  String? _currentAddress; // awalnya null

  final LatLng _targetLocation = const LatLng(-6.210882, 106.812942);

  Stream<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
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

    // Ambil lokasi awal
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await _updateLocation(position);
    } catch (_) {}

    // Stream untuk update lokasi real-time
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

    LocationCardState.lastLat = position.latitude;
    LocationCardState.lastLng = position.longitude;
    LocationCardState.lastAddress = _currentAddress;
    LocationCardState.lastDistance = distance;

    LocationCardStateNotifier.distanceNotifier.value = distance;

    widget.onLocationUpdated?.call(
      position.latitude,
      position.longitude,
      _currentAddress!,
      distance,
    );

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
              height: 200,
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
                    infoWindow: const InfoWindow(title: 'PPKDJP'),
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
                  "Alamat Anda: ${_currentAddress ?? 'Sedang mengambil lokasi...'}",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  "Jarak anda ke PPKDJP: ${_formatDistance(_distanceToTarget)}",
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
