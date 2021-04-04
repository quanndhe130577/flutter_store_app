import 'package:flutter/material.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartActions.dart';
import 'package:flutter_food_app/redux/MyFavorite/MyFavoriteActions.dart';
import 'Model/MyCartEntity.dart';
import 'Model/MyFavoriteEntity.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import "MyCart.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:badges/badges.dart';

class DetailProduct extends StatefulWidget {
  final Store<AppState> store;
  final String uploadId;

  DetailProduct(this.uploadId, this.store);

  @override
  _DetailProductState createState() => _DetailProductState(this.uploadId, this.store);
}

class _DetailProductState extends State<DetailProduct> {
  String uploadId = "";
  Store<AppState> store;

  _DetailProductState(this.uploadId, this.store);

  //bool favInit = false;
  FavModel data = FavModel.defaultValue();
  FirebaseUser currentUser;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.currentUser().then((value) => {this.currentUser = value}).whenComplete(() {
      loadData(uploadId);
      if (this.mounted) {
        setState(() {
          //favInit = data.fav;
        });
      }
    });
  }

  void loadData(String uploadId) async {
    data = FavModel.defaultValue();

    if (this.mounted) {
      setState(() {
        isLoading = true;
      });
    }

    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("Data").child(uploadId);
    await reference.once().then((DataSnapshot dataSnapShot) async {
      var values = dataSnapShot.value;

      bool fav = store.state.myFavState.favList.any((element) => element.uploadId == this.uploadId);

      data = new FavModel(
        values["imgUrl"],
        values["name"],
        values["material"],
        double.parse(values["price"].toString()),
        values["description"],
        uploadId,
        fav,
      );
    }).whenComplete(() {
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: this.store,
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          backgroundColor: Color(0xffff2fc3),
          title: Text(isLoading ? "Loading . . ." : data.name),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) => MyCart(this.store)));
              },
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: StoreConnector<AppState, List<CartModel>>(
                  converter: (store) => store.state.myCartState.cartList,
                  builder: (BuildContext context, List<CartModel> cartList) => Badge(
                    badgeColor: Colors.blue,
                    position: BadgePosition.bottomEnd(bottom: 10),
                    badgeContent:
                        Text(cartList.length.toString(), style: TextStyle(color: Colors.white)),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      semanticLabel: "MyCart",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Text("Buy"),
          elevation: 2,
          backgroundColor: Colors.red,
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.white,
          child: Container(
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: StoreConnector<AppState, List<FavModel>>(
                      converter: (store) => store.state.myFavState.favList,
                      builder: (BuildContext context, List<FavModel> favList) =>
                          favList.any((element) => element.uploadId == data.uploadId)
                              ? Tooltip(
                                  message: 'High quality',
                                  child: IconButton(
                                    icon: Icon(Icons.favorite),
                                    color: Colors.red,
                                    onPressed: () {
                                      favoriteFunc(data.uploadId, false);
                                    },
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(Icons.favorite),
                                  color: Colors.grey,
                                  onPressed: () {
                                    favoriteFunc(data.uploadId, true);
                                  },
                                  tooltip: "Love",
                                ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {},
                        child: Icon(Icons.add, size: 24),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {},
                        child: Icon(Icons.add, size: 24),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          addToCartHandle(data.uploadId);
                        },
                        child: Icon(Icons.add_shopping_cart, size: 24, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: isLoading
            ? Container(
                child: SpinKitDualRing(
                  color: Colors.red,
                  size: 35.0,
                ),
              )
            : Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: ListView(
                    children: [
                      Image.network(
                        data.imgUrl,
                        fit: BoxFit.cover,
                        width: 400,
                        height: 400,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Text(
                          data.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        child: Text(
                          '${new String.fromCharCodes(new Runes('\u0024'))} ${data.price} ',
                          style: TextStyle(
                              color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Material : ${data.material}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Description : ${data.description != null ? data.description : ""}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  void favoriteFunc(String uploadId, bool fav) {
    store.dispatch(HandleFavMyFavAction(uploadId, fav));
  }

  void addToCartHandle(String uploadId) {
    store.dispatch(AddToCartMyCartAction(uploadId));
  }
}
