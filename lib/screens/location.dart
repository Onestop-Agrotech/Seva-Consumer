import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleLocationScreen extends StatefulWidget {
  @override
  _GoogleLocationScreenState createState() => _GoogleLocationScreenState();
}

class _GoogleLocationScreenState extends State<GoogleLocationScreen> {
  GoogleMapController mapController;
  TextEditingController _searchControl = new TextEditingController();

  final LatLng _center = const LatLng(28.570860, 77.368949);
  Set<Marker> _markers = {};
  LatLng home;

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
        markerId: MarkerId('v bro'),
        position: _center,
        draggable: true,
        onDragEnd: ((value) {
          print(value.latitude);
          print(value.longitude);
        })));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // _encodeLocation();
  }


  // _onSearchHandler() async{
  //   // _searchQueryController
  //   String q = _searchControl.value.toString();
  //   var addresses = await Geocoder.local.findAddressesFromQuery(q);
  //   var first = addresses.first;
  //   LatLng coords =
  //       LatLng(first.coordinates.latitude, first.coordinates.longitude);
  //   mapController.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(target: coords, zoom:15.0)
  //   ));
  // }

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
                    IconButton(icon: Icon(Icons.search), onPressed:null),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Set as Delivery Address"),
        icon: Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
