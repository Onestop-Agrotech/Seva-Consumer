import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/details.dart';
import 'package:http/http.dart' as http;

class ProductsUINew extends StatefulWidget {
  @override
  _ProductsUINewState createState() => _ProductsUINewState();
}

class _ProductsUINewState extends State<ProductsUINew> {
  final List<String> catArray = [
    "Vegetables",
    "Fruits",
    "Fresh Greens & Herbs",
    "Nuts & Dry Fruits",
    "Milk, Eggs & Bread",
    "Dairy Items",
    "Daily needs",
    "Non Veg",
    "Snacks",
    "Ready to Eat",
  ];

  // get all the available product.
  Future<List<StoreProduct>> getProducts(String type) async {
    List<StoreProduct> prods = [];
    StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
    String hub = await p.gethub();
    Map<String, String> requestHeaders = {'x-auth-token': token};
    String url = APIService.getCategorywiseProducts(hub, type);
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      List<StoreProduct> x = jsonToCateogrywiseProductModel(response.body);
      return x;
    } else {
      return prods;
    }
  }

  /// this func returns the cards widget
  Widget getCard(StoreProduct p) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            p: p,
          );
        }));
      },
      child: Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 60, maxHeight: 60),
              child: Hero(
                tag: p.name,
                child: CachedNetworkImage(imageUrl: p.pictureURL),
              ),
            ),
            Text(
              p.name,
              style: TextStyle(fontSize: 14.0),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
            // Text(
            //   "40 Gms - Rs 20",
            //   style: TextStyle(fontSize: 12.0),
            // ),
            // RaisedButton(onPressed: (){}, child: Text("Add"))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // height of screen
    double height = MediaQuery.of(context).size.height;
    // width of screen
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Exp UI"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        /// This is the main row that seperates 2 cols
        children: [
          /// The first column to the left side
          Container(
            // decoration: BoxDecoration(border: Border.all(width: 0.1)),
            child: SizedBox(
              height: height * 0.89,
              width: width * 0.15,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: catArray.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 6.0),
                      // decoration: BoxDecoration(border: Border.all(width: 0.1)),
                      child: ListTile(
                        title: Text(
                          catArray[index],
                          style: TextStyle(fontSize: 13.0),
                        ),
                        onTap: (){
                          if(index<3){
                            switch (index) {
                              case 0:
                                getProducts('vegetable');
                                break;
                              case 1:
                                getProducts('fruit');
                                break;
                              case 2:
                                getProducts('dailyEssential');
                                break;
                              default:
                            }
                          }
                        },
                      ),
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: SizedBox(
              height: height * 0.89,
              width: width * 0.278,
              child: FutureBuilder(
                  future: getProducts("vegetable"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<StoreProduct> arr = snapshot.data;
                      // arr.sort((a, b) => a.name.compareTo(b.name));
                      return GridView.count(
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        crossAxisCount: 2,
                        // Generate 100 widgets that display their index in the List.
                        // children: List.generate(11, (index) {
                        //   return Text(
                        //     'Item $index',
                        //     style: Theme.of(context).textTheme.headline6,
                        //   );
                        // }),
                        // children: List.generate(11, (index) {
                        //   return getCard(index.toString());
                        // }),
                        children: arr.map((e) {
                          return getCard(e);
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      print("ERROR");
                      print(snapshot.error);
                    } else
                      return Center(child: CircularProgressIndicator());
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
