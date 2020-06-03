import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/stores.dart';
import 'package:mvp/screens/storeProductList.dart';

class StoresScreen extends StatefulWidget {
  @override
  _StoresScreenState createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  Future<List<Store>> _fetchStores() async {
    String url = "http://10.0.2.2:8000/api/businesses/";
    Map<String, String> requestHeaders = {
      'x-auth-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlZDYzNzE4YzNlN2M3OWYzZWY1ZWRmMSIsImlhdCI6MTU5MTE1NzMzNiwiZXhwIjoxNTkxMTYwOTM2fQ._KKD1kU7Vj1iytZnpbS8itIaMbQJqW8i1jXh1eQcyF0'
    };
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return jsonToStoreModel(response.body);
    } else {
      throw Exception('something is wrong');
    }
  }

  FutureBuilder _buildArrayFromFuture() {
    return FutureBuilder(
        future: _fetchStores(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Store> arr = snapshot.data;
            return ListView.builder(
                itemCount: arr.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ButtonTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StoreProductsScreen(
                                          businessUsername: arr[index].username,
                                        )));
                          },
                          color: ThemeColoursSeva().dkGreen,
                          textColor: Colors.white,
                          child: Text('${arr[index].name}'),
                        ),
                      ),
                      SizedBox(height: 20.0)
                    ],
                  );
                });
          } else if (snapshot.hasError)
            return Text('${snapshot.error}');
          else
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildArrayFromFuture(),
      ),
    );
  }
}
