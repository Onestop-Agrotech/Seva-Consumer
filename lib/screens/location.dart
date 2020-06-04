import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class GoogleLocationScreen extends StatefulWidget {
  @override
  _GoogleLocationScreenState createState() => _GoogleLocationScreenState();
}

class _GoogleLocationScreenState extends State<GoogleLocationScreen> {

  GoogleMapController mapController;
  final LatLng _center = const LatLng(12.962579, 77.497794);
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
      markerId: MarkerId('v bro'),
      position: _center,
      draggable: true
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 16.0),
            markers: Set.from(_markers),
          ),
        ],
      ),
    );
  }
}
