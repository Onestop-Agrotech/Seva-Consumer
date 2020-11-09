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
  // Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.grey,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.yellow,
      textTheme: ButtonTextTheme.primary,
    ),
  );

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
                  RaisedButton(
                    onPressed: () {},
                    child: Text("Save Address"),
                    color: ThemeColoursSeva().pallete1,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
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
          // selectedPlaceWidgetBuilder:
          //     (_, selectedPlace, state, isSearchBarFocused) {
          //   return FloatingCard(
          //     bottomPosition: 0.0,
          //     leftPosition: 0.0,
          //     rightPosition: 0.0,
          //     width: 400,
          //     height: 350.0,
          //     borderRadius: BorderRadius.circular(12.0),
          //     child: state == SearchingState.Searching
          //         ? Center(child: CommonGreenIndicator())
          //         : Container(
          //             width: 400.0,
          //             height: 350.0,
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Padding(
          //       padding:
          //           const EdgeInsets.only(left: 25.0, top: 7.0),
          //       child: Text(selectedPlace.formattedAddress,
          //           style: TextStyle(
          //               color: Colors.black,
          //               fontSize: 1.7 * SizeConfig.textMultiplier,
          //               fontWeight: FontWeight.w400)),
          //     ),
          //     InputTextField(
          //         labelText: "House No/Flat No:",
          //         controller: _houseno,
          //         textInputType: TextInputType.text),
          //     InputTextField(
          //         labelText: "Landmark:",
          //         controller: _landmark,
          //         textInputType: TextInputType.text),
          //     RaisedButton(
          //       onPressed: () {},
          //       child: Text("Save Address"),
          //       color: ThemeColoursSeva().pallete1,
          //       textColor: Colors.white,
          //     ),
          //   ],
          // ),
          //           ),
          //   );
          // },
          onPlacePicked: (result) {
            print(result.formattedAddress);
            // Navigator.of(context).pop();
            _showAddressDialog();
          },
          initialPosition: _center,
          useCurrentLocation: true,
        ),
      ),
    );
  }
}
