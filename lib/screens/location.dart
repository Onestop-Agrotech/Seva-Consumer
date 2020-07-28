import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mvp/constants/themeColours.dart';
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
  Set<Marker> _markers = {};
  bool _showActionBtn;
  Location location = new Location();

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(
        msg: "Getting your location, just a moment!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER);
    // getPermissions();
    getCurrentLocation();
  }

  void getPermissions() async {}

  void getCurrentLocation() async {
    LocationData _locationData;
    _locationData = await location.getLocation();
    LatLng coords = LatLng(_locationData.latitude, _locationData.longitude);
    Marker mk1 = Marker(
        markerId: MarkerId('current'),
        position: coords,
        draggable: true,
        onDragEnd: ((value) {
          setState(() {
            coords = LatLng(value.latitude, value.longitude);
          });
        }));
    setState(() {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: coords, zoom: 18.0)));
      _markers.add(mk1);
      _showActionBtn = true;
    });
    Fluttertoast.showToast(
        msg: "Hold the marker and drag for accuracy.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // _encodeLocation();
  }

  _showFloatingActionButton() {
    if (_showActionBtn == true) {
      return FloatingActionButton.extended(
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
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
            markers: Set.from(_markers),
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
          ),
        ],
      ),
      floatingActionButton: _showFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
