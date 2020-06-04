import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GoogleLocationScreen extends StatefulWidget {
  @override
  _GoogleLocationScreenState createState() => _GoogleLocationScreenState();
}

class _GoogleLocationScreenState extends State<GoogleLocationScreen> {
  GoogleMapController mapController;
  TextEditingController _searchControl = new TextEditingController();

  final LatLng _center = const LatLng(28.570860, 77.368949);
  LatLng _userPosition;
  Set<Marker> _markers = {};
  bool _showActionBtn;

  @override
  void initState() {
    super.initState();
    // _markers.add(Marker(
    //     markerId: MarkerId('1'),
    //     position: _center,
    //     draggable: true,
    //     onDragEnd: ((value) {
    //       print(value.latitude);
    //       print(value.longitude);
    //     })));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // _encodeLocation();
  }

  _onSearchHandler() async {
    try {
      var addresses =
          await Geocoder.local.findAddressesFromQuery(_searchControl.text);
      LatLng coords = LatLng(addresses.first.coordinates.latitude,
          addresses.first.coordinates.longitude);
      setState(() {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: coords, zoom: 16.0)));
      });
      Fluttertoast.showToast(
          msg: "Please select area on map for accuracy",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Please enter a valid address",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    }
  }

  _showFloatingActionButton(){
    if(_showActionBtn==true){
      return FloatingActionButton.extended(
        onPressed: () {
          print(_userPosition);
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
            initialCameraPosition: CameraPosition(target: _center, zoom: 17.0),
            markers: Set.from(_markers),
            onTap: (pos) {
              _showActionBtn=true;
              _userPosition = pos;
              Marker mk1 = Marker(
                markerId: MarkerId('1'),
                position: pos,
              );
              setState(() {
                _markers.add(mk1);
              });
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Container(
                height: 60.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xffebedf0),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 5.0),
                    IconButton(
                        icon: Icon(Icons.search), onPressed: _onSearchHandler),
                    SizedBox(width: 5.0),
                    Container(
                        width: 270.0,
                        child: TextFormField(
                            controller: _searchControl,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            )))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _showFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
