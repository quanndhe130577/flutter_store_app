import 'package:flutter/material.dart';
import 'package:flutter_food_app/Common.dart';
import 'package:flutter_food_app/CommonWidget/CustomAppBar.dart';
import 'package:flutter_food_app/CommonWidget/InheritedAppbarProvider.dart';
import 'package:flutter_food_app/View/StoreScreen.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartActions.dart';
import 'package:flutter_food_app/redux/MyFavorite/MyFavoriteActions.dart';
import 'package:flutter_food_app/Model/DetailProductEntity.dart';
import 'package:flutter_food_app/Model/MyFavoriteEntity.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

class DetailProductScreen extends StatefulWidget {
  final Store<AppState> store;
  final String uploadId;

  DetailProductScreen(this.uploadId, this.store);

  @override
  _DetailProductScreenState createState() => _DetailProductScreenState(this.uploadId, this.store);
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  String uploadId = "";
  Store<AppState> store;

  _DetailProductScreenState(this.uploadId, this.store);

  DetailProductModel data = new DetailProductModel();
  bool isLoading = false;
  double opacityAppbar = 0;

  ScrollController _controller;

  void handleController() async {
    if (_controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange) {}

    if (_controller.offset <= _controller.position.minScrollExtent && !_controller.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          opacityAppbar = 0;
        });
      }
    } else if (_controller.offset <= _controller.position.minScrollExtent + 80) {
      if (this.mounted) {
        setState(() {
          opacityAppbar = _controller.offset / 100;
        });
      }
    } else {
      if (this.mounted) {
        setState(() {
          opacityAppbar = 1;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = ScrollController();
    _controller.addListener(handleController);

    super.initState();

    loadData(uploadId);
    if (this.mounted) {
      setState(() {
        //
      });
    }
  }

  void loadData(String uploadId) async {
    data = new DetailProductModel();

    if (this.mounted) {
      setState(() {
        isLoading = true;
      });
    }

    DatabaseReference reference = FirebaseDatabase.instance.reference().child("Data").child(uploadId);
    await reference.once().then((DataSnapshot dataSnapShot) async {
      var values = dataSnapShot.value;

      bool fav = store.state.myFavState.favList.any((element) => element.uploadId == this.uploadId);

      data = new DetailProductModel(
        uploadId: uploadId,
        name: values["name"],
        imgUrl: values["imgUrl"],
        description: values["description"],
        fav: fav,
        material: values["material"],
        price: double.parse(values["price"].toString()),
      );

      DatabaseReference refStore = FirebaseDatabase.instance.reference().child("Store").child(values["store"]);
      await refStore.once().then((DataSnapshot dataSnapShot) async {
        var storeValues = dataSnapShot.value;

        data.store = new ShortenStoreModel(
          id: values["store"],
          imgUrl: storeValues["image"],
          name: storeValues["name"],
          evaluate: double.parse(storeValues["evaluate"].toString()),
          chatResponseRate: double.parse(storeValues["chat_response_rate"].toString()),
          numberOfProduct: storeValues["number_of_product"],
        );
      });
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
    double heightStoreWidget = getHeightForWidget(context, dividedBy: 3.5);
    return StoreProvider(
      store: this.store,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(heightOfAppBar),
          child: InheritedAppBarProvider(
            child: CustomAppBar(store: this.store),
            opacity: this.opacityAppbar * 0.2,
            title: opacityAppbar == 0
                ? Text("")
                : Text(isLoading ? "Loading . . ." : data.name, style: TextStyle(color: Colors.black)),
          ),
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
            : Container(
                child: ListView(
                  controller: _controller,
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top), // add to fix error padding appbar
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Image.network(
                            data.imgUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: getHeightForWidget(context, dividedBy: 1.7, ignoreAppbar: false),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
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
                            padding: EdgeInsets.only(left: 10, right: 10),
                            width: double.infinity,
                            child: Text(
                              '${new String.fromCharCodes(new Runes('\u0024'))} ${data.price} ',
                              style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
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
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 10,
                      height: 50,
                    ),
                    StoreProduct(data.store, heightStoreWidget),
                    Divider(
                      thickness: 10,
                      height: 50,
                    ),
                    Container(
                      //alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      //width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              "Detail of product : ",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(),
                          Container(
                            width: double.infinity,
                            child: Text(
                              "${data.description != null ? data.description : ""}",
                              style: TextStyle(color: Colors.black, fontSize: 15),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 10,
                      height: 50,
                    ),
                    SizedBox(height: 30),
                  ],
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

class StoreProduct extends StatefulWidget {
  final ShortenStoreModel storeData;
  final double lengthOfWidget;

  StoreProduct(this.storeData, this.lengthOfWidget);

  @override
  _StoreProductState createState() => _StoreProductState(this.storeData, this.lengthOfWidget);
}

class _StoreProductState extends State<StoreProduct> {
  ShortenStoreModel storeProduct;
  double lengthOfWidget;

  _StoreProductState(this.storeProduct, this.lengthOfWidget);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    storeProduct.imgUrl,
                    height: (lengthOfWidget - 20) / 2.3,
                    width: (lengthOfWidget - 20) / 2.3,
                    fit: BoxFit.cover,
                  ),
                ),
                // CircleAvatar(
                //     radius: 40,
                //     backgroundImage: NetworkImage(storeProduct.imgUrl)
                // ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(50),
                //   child: Image.network(
                //     storeProduct.imgUrl,
                //     fit: BoxFit.cover,
                //     width: 75,
                //     height: 75,
                //   ),
                // ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(storeProduct.name),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StoreScreen()));
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                  ),
                  child: Text("View Store"),
                ),
              ],
            ),
            SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(storeProduct.numberOfProduct.toString(),
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
                          SizedBox(height: 5),
                          Text("Products", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(thickness: 3),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(storeProduct.evaluate.toString(),
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
                          SizedBox(height: 5),
                          Text("Evaluate", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(thickness: 3),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text("${storeProduct.chatResponseRate} %",
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
                          SizedBox(height: 5),
                          Text("Chat Response", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
