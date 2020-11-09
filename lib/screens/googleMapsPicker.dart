import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/common/inputTextField.dart';
import 'package:mvp/screens/common/progressIndicator.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

class GoogleMapsPicker extends StatefulWidget {
  @override
  _GoogleMapsPickerState createState() => _GoogleMapsPickerState();
}

class _GoogleMapsPickerState extends State<GoogleMapsPicker> {
  final LatLng _center = const LatLng(12.9716, 77.5946);
  TextEditingController _houseno = new TextEditingController();
  TextEditingController _landmark = new TextEditingController();
  String _apiKey;

  @override
  void initState() {
    super.initState();
    _apiKey = DotEnv().env["GOOGLE_MAPS_API_KEY"];
  }

  _showAddressDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            title: Text("For doorstep convenience :)"),
            content: Container(
              height: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InputTextField(
                      labelText: "House No/Flat No:",
                      controller: _houseno,
                      textInputType: TextInputType.text),
                  InputTextField(
                      labelText: "Landmark:",
                      controller: _landmark,
                      textInputType: TextInputType.text),
                ],
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: () {},
                child: Text("Save Address"),
                color: ThemeColoursSeva().pallete1,
                textColor: Colors.white,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: PlacePicker(
          apiKey: _apiKey,
          hintText: "Search for your address",
          enableMapTypeButton: false,
          region: "in",
          selectedPlaceWidgetBuilder:
              (_, selectedPlace, state, isSearchBarFocused) {
            return FloatingCard(
              bottomPosition: 40.0,
              leftPosition: 10.0,
              rightPosition: 60.0,
              width: 60,
              height: 135.0,
              borderRadius: BorderRadius.circular(12.0),
              child: state == SearchingState.Searching
                  ? Center(child: CommonGreenIndicator())
                  : Container(
                      width: 60.0,
                      height: 135.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Text(selectedPlace.formattedAddress,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 1.9 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w400)),
                          ),
                          RaisedButton(
                            onPressed: () {
                              _showAddressDialog();
                            },
                            child: Icon(Icons.check),
                            color: ThemeColoursSeva().pallete1,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
            );
          },
          initialPosition: _center,
          useCurrentLocation: true,
        ),
      ),
    );
  }
}
