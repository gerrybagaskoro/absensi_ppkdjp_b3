import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationCard extends StatefulWidget {
  const LocationCard({super.key});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(-6.200000, 106.816666); // Default to Jakarta
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
      // margin: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bagian peta
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

          // Bagian informasi lokasi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Koordinat: ${_currentPosition.latitude.toStringAsFixed(6)}, ${_currentPosition.longitude.toStringAsFixed(6)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _currentAddress,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _getCurrentLocation();
                    },
                    icon: const Icon(Icons.my_location),
                    label: const Text("Lokasi terkini"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
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
    _currentPosition = LatLng(position.latitude, position.longitude);
    lat = position.latitude;
    long = position.longitude;

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );
    Placemark place = placemarks[0];

    setState(() {
      _marker = Marker(
        markerId: MarkerId("lokasi_saya"),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: 'Lokasi Anda',
          snippet: "${place.street}, ${place.locality}",
        ),
      );

      _currentAddress =
          "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
      print(_currentAddress);
      print(_currentPosition);
      print("${place.street}, ${place.locality}");
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 16),
        ),
      );
    });
  }
}
