import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/common/inputTextField.dart';
import 'package:mvp/screens/errors/locationService.dart';
import 'package:mvp/screens/userProfile.dart';

class GoogleLocationScreen extends StatefulWidget {
  final String userEmail;

  GoogleLocationScreen({this.userEmail});
  @override
  _GoogleLocationScreenState createState() => _GoogleLocationScreenState();
}

class _GoogleLocationScreenState extends State<GoogleLocationScreen> {
  GoogleMapController mapController;
  TextEditingController _searchControl = new TextEditingController();

  final LatLng _center = const LatLng(12.9716, 77.5946);
  LatLng _userPosition;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  bool _showActionBtn;
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  int _markerIdCounter = 0;

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  void getPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // go to enable GPS service page
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EnableLocationPage(
                      userEmail: widget.userEmail,
                    )));
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    Fluttertoast.showToast(
        msg: "Getting your location, just a moment!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER);
    Future.delayed(const Duration(seconds: 3), () async {
      _locationData = await location.getLocation();
      getCurrentLocation(_locationData);
    });
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  void getCurrentLocation(ld) async {
    LatLng coords = LatLng(ld.latitude, ld.longitude);
    // Marker mk1 = Marker(
    //     markerId: MarkerId('current'),
    //     position: coords,
    //     draggable: true,
    //     onDragEnd: ((value) {
    //       setState(() {
    //         coords = LatLng(value.latitude, value.longitude);
    //         _userPosition = coords;
    //       });
    //     }));

    // setState(() {
    //   mapController.animateCamera(CameraUpdate.newCameraPosition(
    //       CameraPosition(target: coords, zoom: 18.0)));
    //   _markers.add(mk1);
    //   _userPosition = coords;
    //   _showActionBtn = true;
    //   // dragabble
    // });
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = coords;
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: false,
    );
    setState(() {
      _markers[markerId] = marker;
    });

    Future.delayed(Duration(seconds: 1), () async {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 17.0,
          ),
        ),
      );
      _userPosition = coords;
      _showActionBtn = true;
    });
    Fluttertoast.showToast(
        msg: "Hold the marker and drag for accuracy.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // _encodeLocation();
  }

  _showFloatingActionButton() {
    if (_showActionBtn == true) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: FloatingActionButton.extended(
          backgroundColor: ThemeColoursSeva().dkGreen,
          onPressed: () {
            _searchControl.clear();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfileScreen(
                          coords: _userPosition,
                          userEmail: widget.userEmail,
                        )));
          },
          label: Text("Set as Delivery Address"),
          icon: Icon(Icons.home),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                rotateGesturesEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: _center, zoom: 15.0),
                markers: Set<Marker>.of(_markers.values),
                onTap: (pos) {
                  // _showActionBtn = true;
                  // _userPosition = pos;
                  // Marker mk1 = Marker(
                  //   markerId: MarkerId('1'),
                  //   position: pos,
                  // );
                  // setState(() {
                  //   _markers.add(mk1);
                  // });
                },
                onCameraMove: (CameraPosition position) {
                  print(position);
                  if (_markers.length > 0) {
                    MarkerId markerId = MarkerId(_markerIdVal());
                    Marker marker = _markers[markerId];
                    Marker updatedMarker = marker.copyWith(
                      positionParam: position.target,
                    );

                    setState(() {
                      _markers[markerId] = updatedMarker;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InputTextField(
                lt: "Home address:",
              ),
            ),
            Container(
              child: _showFloatingActionButton(),
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
      // floatingActionButton: _showFloatingActionButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
