import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class geoLocation extends StatefulWidget {
  const geoLocation({super.key});

  @override
  State<geoLocation> createState() => _geoLocationState();
}

class _geoLocationState extends State<geoLocation> {
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentAddress = "";

  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("service disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
