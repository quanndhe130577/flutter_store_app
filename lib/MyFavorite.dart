import 'package:flutter/material.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartActions.dart';
import 'package:flutter_food_app/redux/MyFavorite/MyFavoriteActions.dart';
import 'Common.dart';
import 'Model/MyFavoriteEntity.dart';
import 'DetailProduct.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'redux/AppState.dart';
import 'package:toast/toast.dart';

class MyFavorite extends StatefulWidget {
  final Store<AppState> store;

  MyFavorite(this.store);

  @override
  _MyFavoriteState createState() => _MyFavoriteState(this.store);
}

class _MyFavoriteState extends State<MyFavorite> with TickerProviderStateMixin {
  Store<AppState> store;

  _MyFavoriteState(this.store);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: this.store,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Favorite",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xffff2f3c),
        ),
        body: StoreConnector<AppState, List<FavModel>>(
          converter: (store) => store.state.myFavState.favList,
          builder: (BuildContext context, List<FavModel> favList) => favList.length == 0
              ? Center(
                  child: Text("No data available", style: TextStyle(fontSize: 30)),
                )
              : ListView.builder(
                  itemCount: favList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (buildContext, index) {
                    return cardUI(favList[index]);
                  },
                ),
        ),
      ),
    );
  }

  Widget cardUI(FavModel item) {
    return Card(
      elevation: 7,
      margin: EdgeInsets.all(15),
      color: Color(0xffff2fc3),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.all(1.5),
        padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              // height: double.infinity,
              child: TextButton(
                onPressed: () {
                  removeFav(item.uploadId);
                },
                child: Icon(Icons.remove, color: Colors.red),
                style: TextButton.styleFrom(
                  //minimumSize: Size(double.infinity, double.infinity),
                  backgroundColor: Colors.black12,
                ),
              ),
            ),
            SizedBox(height: 3),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DetailProduct(item.uploadId, this.store)));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(item.imgUrl, fit: BoxFit.cover, height: 100, width: 100),
                  SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shortenString(item.name, 15),
                          style: TextStyle(
                              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            'Price : ${item.price} ${new String.fromCharCodes(new Runes('\u0024'))}',
                            style: TextStyle(
                              //color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: double.infinity,
                          child: Text(
                            'Material : ${item.material}',
                            style: TextStyle(
                              //color: Colors.red,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          child: Text(
                            'Descriptions: ${shortenString(item.description, 15)}',
                            style: TextStyle(
                              //color: Colors.red,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3),
            Container(
              child: TextButton.icon(
                onPressed: () {
                  addToCartHandle(item.uploadId);
                },
                icon: Icon(Icons.add_shopping_cart, color: Colors.black),
                label: Text("Add to cart", style: TextStyle(color: Colors.black)),
              ),
              width: double.infinity,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  void removeFav(String uploadId) {
    store.dispatch(HandleFavMyFavAction(uploadId, false));
  }

  void addToCartHandle(String uploadId) {
    Toast.show("Add to cart", context, duration: 1, gravity: Toast.BOTTOM);
    store.dispatch(AddToCartMyCartAction(uploadId));
  }
}
