// CODE TO CHOOSE PLACE OR CURRENT LOCATION AND GO TO NEXT PAGE AND DISPLAY IT THERE

import 'package:flutter/material.dart';
import 'package:predict/screens/screen_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:free_place_search/place_search.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ScreenInitial extends StatefulWidget {
  const ScreenInitial({super.key});

  @override
  State<ScreenInitial> createState() => _ScreenInitialState();
}

class _ScreenInitialState extends State<ScreenInitial> {
  Position? _currentPosition;

  double _lat = 0.0;
  double _lon = 0.0;

  // Current location
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
          return false;
        }
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
        return false;
      }
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _lat = _currentPosition?.latitude ?? 0.0;
        _lon = _currentPosition?.longitude ?? 0.0;
      });
    }).catchError((e) {
      debugPrint(e);
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App Initial Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PlaceAutocomplete.widget(onDone: (e) {
              final add = e.point?.toMap();
              final lat = add?['lat'];
              final lon = add?['lon'];
              _getCoords(lat, lon);
            }),

            // --- Get current location ---
            ElevatedButton(
              onPressed: () {
                _getCurrentPosition();
              },
              child: const Text("Get Current Location"),
            ),
          ],
        ),
      ),

      // ----- Place Select -----
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PlaceAutocomplete.show(
            onDone: (e) {
              Navigator.pop(context);
            },
            context: context,
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Getting cordinates from place search
  void _getCoords(lat, lon) {
    _lat = lat;
    _lon = lon;
    _saveData();
  }

  // SAVE DATA AND GO TO NEXT PAGE
  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    await prefs.setDouble('latitude', _lat);
    await prefs.setDouble('longitude', _lon);

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const ScreenHome(),
        ),
      );
    }
  }
}
