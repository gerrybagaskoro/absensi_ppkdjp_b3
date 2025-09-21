// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Static holder (pilihan cepat) — dashboard kamu bisa akses:
/// LocationCardState.lastLat, LocationCardState.lastLng, LocationCardState.lastAddress
class LocationCardState {
  static double? lastLat;
  static double? lastLng;
  static String? lastAddress;
}

class LocationCard extends StatefulWidget {
  /// Optional callback: dipanggil setiap lokasi terupdate
  final void Function(double lat, double lng, String address)?
  onLocationUpdated;

  const LocationCard({super.key, this.onLocationUpdated});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  GoogleMapController? mapController;
  LatLng _currentPosition = const LatLng(
    -6.200000,
    106.816666,
  ); // Default Jakarta
  double lat = -6.200000;
  double long = 106.816666;
  String _currentAddress = "Alamat tidak ditemukan";
  Marker? _marker;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Map
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
                markers: _marker != null ? {_marker!} : {},
                onMapCreated: (controller) {
                  mapController = controller;
                },
              ),
            ),
          ),
          // Info + tombol
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Koordinat Lokasi: ${_currentPosition.latitude.toStringAsFixed(6)}, ${_currentPosition.longitude.toStringAsFixed(6)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentAddress,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                // const SizedBox(height: 12),
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton.icon(
                //     onPressed: _loading ? null : _getCurrentLocation,
                //     icon: const Icon(Icons.my_location),
                //     label: Text(
                //       _loading ? "Mencari lokasi..." : "Lokasi terkini",
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       padding: const EdgeInsets.symmetric(vertical: 14),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
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

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final newPos = LatLng(position.latitude, position.longitude);

      List<Placemark> placemarks = [];
      try {
        placemarks = await placemarkFromCoordinates(
          newPos.latitude,
          newPos.longitude,
        );
      } catch (_) {
        // geocoding bisa gagal di emulator tanpa Google Play services — biarkan tertangani
      }
      final place = placemarks.isNotEmpty ? placemarks[0] : null;

      final address = place != null
          ? "${place.name ?? ''}${place.street != null && place.street!.isNotEmpty ? ', ${place.street}' : ''}, ${place.locality ?? ''}${place.country != null ? ', ${place.country}' : ''}"
                .replaceAll(RegExp(r',\s*,+'), ',')
                .replaceAll(RegExp(r'^\s*,\s*'), '')
                .trim()
          : "Alamat tidak ditemukan";

      if (!mounted) return;

      setState(() {
        _currentPosition = newPos;
        lat = position.latitude;
        long = position.longitude;
        _marker = Marker(
          markerId: const MarkerId("lokasi_saya"),
          position: _currentPosition,
          infoWindow: InfoWindow(
            title: 'Lokasi Anda',
            snippet: "${place?.street ?? ''}, ${place?.locality ?? ''}",
          ),
        );
        _currentAddress = address;
      });

      // Simpan di static holder (DashboardPresensi bisa baca)
      LocationCardState.lastLat = lat;
      LocationCardState.lastLng = long;
      LocationCardState.lastAddress = _currentAddress;

      // Panggil callback jika ada
      widget.onLocationUpdated?.call(lat, long, _currentAddress);

      // Animate camera (jika controller tersedia)
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentPosition, zoom: 16),
          ),
        );
      }
    } catch (e, st) {
      debugPrint('Error mengambil lokasi: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengambil lokasi: $e')));
      }
    }
  }
}
