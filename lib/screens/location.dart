import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/common/inputTextField.dart';
import 'package:mvp/screens/errors/locationService.dart';

class GoogleLocationScreen extends StatefulWidget {
  final String userEmail;

  GoogleLocationScreen({this.userEmail});
  @override
  _GoogleLocationScreenState createState() => _GoogleLocationScreenState();
}

class _GoogleLocationScreenState extends State<GoogleLocationScreen> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(12.9716, 77.5946);
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  bool _showActionBtn;
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  int _markerIdCounter = 0;
  String _markerAddress = "";
  bool _loader = false;
  Coordinates coordinates;
  String _subLocality = "";
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

  void getCurrentLocation(ld) async {
    this.setState(() {
      _loader = true;
    });
    LatLng coords = LatLng(ld.latitude, ld.longitude);
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
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 17.0,
          ),
        ),
      );
      _showActionBtn = true;
      this.setState(() {
        _loader = false;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _showFloatingActionButton() {
    if (_showActionBtn == true) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton.extended(
          backgroundColor: ThemeColoursSeva().dkGreen,
          onPressed: () {},
          label: Text("Set as Delivery Address"),
          icon: Icon(Icons.home),
        ),
      );
    } else {
      return Container();
    }
  }

// for changing marker pos
  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  // on dragging maps
  onMapsMove(position) async {
    if (_markers.length > 0) {
      setState(() {
        MarkerId markerId = MarkerId(_markerIdVal());
        Marker marker = _markers[markerId];
        Marker updatedMarker = marker.copyWith(
          positionParam: position.target,
        );
        _markers[markerId] = updatedMarker;
      });
    }
    coordinates =
        new Coordinates(position.target.latitude, position.target.longitude);
  }

  onMapsStop(coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    var subLocality;

    if (first.subLocality != null) {
      subLocality = first.subLocality;
    } else if (first.subAdminArea != null) {
      subLocality = first.subAdminArea;
    } else if (first.countryName != null) {
      subLocality = first.countryName;
    } else {
      subLocality = "None";
    }
    final subArea = first.subAdminArea;
    final state = first.adminArea;
    final pincode = first.postalCode;
    final country = first.countryName;
    final address = "$subArea,$state,$pincode,$country";
    this.setState(() {
      _markerAddress = address;
      _subLocality = subLocality;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: true,
                    onMapCreated: _onMapCreated,
                    markers: Set<Marker>.of(_markers.values),
                    initialCameraPosition:
                        CameraPosition(target: _center, zoom: 15.0),
                    onTap: (pos) {},
                    onCameraMove: (CameraPosition position) {
                      onMapsMove(position);
                    },
                    onCameraIdle: () {
                      onMapsStop(coordinates);
                    },
                  ),
                  if (_loader)
                    Container(
                      color: Colors.white,
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_subLocality != "")
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                  Text(
                    _subLocality,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                _markerAddress,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InputTextField(
                lt: "House No/Flat No:",
                // eC: TextEditingController()..text = _markerAddress
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InputTextField(
                lt: "Landmark:",
                // eC: TextEditingController()..text = _markerAddress
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
    );
  }
}
