// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{03-09-2020}

///
/// @fileoverview location widget : contains map for the location of the user.
///

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/users.dart';
import 'package:mvp/screens/common/inputTextField.dart';
import 'package:mvp/screens/errors/locationService.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/screens/errors/notServing.dart';

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
  TextEditingController _houseno = new TextEditingController();
  TextEditingController _landmark = new TextEditingController();
  bool _housenoEmpty = false;
  bool _landmarkEmpty = false;
  double _lat;
  double _lng;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  // permission for the GPS(location)
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

  // gets the current location of the user.
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
      _showActionBtn = true;
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
      this.setState(() {
        _loader = false;
      });
    });
  }

  // creates the map.
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // sets the address of the delivery.
  _showFloatingActionButton() {
    if (_showActionBtn == true) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton.extended(
          backgroundColor: ThemeColoursSeva().dkGreen,
          onPressed: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            _handleAddressAddition();
          },
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

  // change the location when switch to a different position on map.
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
      _lng = first.coordinates.longitude;
      _lat = first.coordinates.latitude;
    });
  }

  // field validation
  _showHouseEmptyError() {
    if (_housenoEmpty == true) {
      return Text(
        'Please enter the House No',
        style: TextStyle(color: Colors.red),
      );
    } else
      return Container();
  }

  // field validation
  _showLandmarkEmptyError() {
    if (_landmarkEmpty == true) {
      return Text(
        'Please enter the Landmark',
        style: TextStyle(color: Colors.red),
      );
    } else
      return Container();
  }

  // hits the api and stores the address in the database.
  _handleAddressAddition() async {
    if (_houseno.text == '') {
      // handle empty error
      this.setState(() {
        _housenoEmpty = true;
      });
    }
    if (_landmark.text == '') {
      // handle empty error
      setState(() {
        _landmarkEmpty = true;
      });
    } else {
      setState(() {
        _landmarkEmpty = false;
        _housenoEmpty = false;
      });
      UserModel user = new UserModel();
      String houseno = _houseno.text.trim();
      String landmark = _landmark.text.trim();
      String geocodedaddress = _markerAddress;
      user.email = widget.userEmail;
      user.address = '$houseno,$landmark,$geocodedaddress';
      user.latitude = _lat.toString();
      user.longitude = _lng.toString();
      _submitToDbhelper(user, context);
    }
  }

  _submitToDbhelper(UserModel user, context) async {
    setState(() {
      _loader = true;
    });
    String url = APIService.registerAddressAPI;
    final p = await Preferences.getInstance();
    String token = await p.getData("token");
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": token
    };
    String getJson = userModelAddress(user);
    var response = await http.post(url, body: getJson, headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        _loader = false;
      });
      await p.setToken(json.decode(response.body)["token"]);
      await p.setUsername(json.decode(response.body)["username"]);
      await p.setId(json.decode(response.body)["id"]);
      await p.sethub(json.decode(response.body)["hub"]);
      bool far = json.decode(response.body)["far"];
      await p.setFarStatus(far.toString());
      await p.setEmail(json.decode(response.body)["email"]);
      await p.setMobile(json.decode(response.body)["mobile"]);
      if (!far) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/main', ModalRoute.withName('/main'));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return NotServing(
            userEmail: widget.userEmail,
          );
        }));
      }
    } else {
      setState(() {
        _loader = false;
      });
      throw Exception('Server error');
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
              child: InputTextField(lt: "House No/Flat No:", eC: _houseno),
            ),
            _showHouseEmptyError(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InputTextField(lt: "Landmark:", eC: _landmark),
            ),
            _showLandmarkEmptyError(),
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
