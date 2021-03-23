import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/Home/homeMiddleware.dart';
import 'package:flutter_food_app/redux/actions.dart';
import 'file:///E:/Flutter/flutter_store_app/lib/redux/Home/homeReducer.dart';
import 'Model/HomeEntity.dart';
import 'package:flutter_food_app/DetailProduct.dart';
import 'package:flutter_food_app/LogInScreen.dart';
import 'UploadData.dart';
import 'MyFavorite.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'MyCart.dart';
import 'Common.dart';
import 'package:toast/toast.dart';
import 'package:badges/badges.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomeScreen extends StatefulWidget {
  final String currentEmail;

  HomeScreen(this.currentEmail);

  @override
  _HomeScreen createState() => _HomeScreen(this.currentEmail);
}

class _HomeScreen extends State<HomeScreen> {
  final Store<AppState> store = Store<AppState>(
    homeReducers,
    initialState: AppState(),
    middleware: [appStateMiddleware],
  );

  String currentEmail = "";

  FirebaseUser currentUser;
  bool searchState = false;

  _HomeScreen(this.currentEmail);

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> logOut() async {
    await auth.signOut().then((value) => {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LogInScreen()))
        });
  }

  ScrollController _controller;

  void reloadData() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      store.dispatch(LoadMoreDataAction());
    }

    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      store.dispatch(RefreshDataAction());
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(reloadData);
    super.initState();
    auth.currentUser().then((value) => {this.currentUser = value});
    loadFirstData();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(
        onInit: (store) => store.dispatch(FirstLoadHomeModelAction()),
        builder: (BuildContext context, Store<AppState> store) => Scaffold(
          backgroundColor: Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: Color(0xffff2fc3),
            title: !searchState
                ? Text("Home")
                : TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.white),
                      hintText: "Search . . . ",
                      hintStyle: TextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onSubmitted: (text) {
                      searchMethod(text.toLowerCase());
                    },
                    autofocus: true,
                  ),
            centerTitle: false,
            actions: [
              searchState
                  ? IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.white,
                      onPressed: () {
                        store.dispatch(RemoveSearchState());
                        setState(() {
                          searchState = !searchState;
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          searchState = !searchState;
                        });
                      },
                    ),
              Visibility(
                visible: !searchState,
                child: Badge(
                  badgeColor: Colors.blue,
                  position: BadgePosition.topEnd(top: 0, end: 15),
                  badgeContent:
                      Text("0", style: TextStyle(color: Colors.white)),
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => MyCart()));
                      },
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
          drawer: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 170,
                  color: Color(0xff000725),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 30)),
                      Image(
                          image: AssetImage("images/icon.jpg"),
                          height: 90,
                          width: 90),
                      SizedBox(height: 10),
                      Text(currentEmail, style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
                ListTile(
                  title: Text("Upload"),
                  leading: Icon(Icons.cloud_upload),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                UploadData())).then((value) => {});
                    //loadFirstData();
                  },
                ),
                ListTile(
                  title: Text("My Favorite"),
                  leading: Icon(Icons.favorite),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MyFavorite())).then((value) => loadFirstData());
                  },
                ),
                ListTile(
                  title: Text("My Profile"),
                  leading: Icon(Icons.person),
                ),
                Divider(),
                //line
                ListTile(
                  title: Text("Contact Us"),
                  leading: Icon(Icons.email),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      title: Text("Log out"),
                      leading: Icon(Icons.logout),
                      onTap: () {
                        logOut();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              StoreConnector<AppState, bool>(
                converter: (store) => store.state.isLoading,
                builder: (BuildContext context, bool isLoading) => Visibility(
                  visible: isLoading,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: SpinKitWave(
                      color: Colors.red,
                      size: 35.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StoreConnector<AppState, List<HomeModel>>(
                  converter: (store) => store.state.searchList,
                  builder: (context, List<HomeModel> searchList) =>
                      searchList.length == 0
                          ? Center(
                              child: Text("No data available",
                                  style: TextStyle(fontSize: 30)),
                            )
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              controller: _controller,
                              itemCount: searchList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (buildContext, index) {
                                return cardUI(searchList[index]);
                              },
                            ),
                ),
              ),
              StoreConnector<AppState, bool>(
                converter: (store) => store.state.isLoadingMore,
                builder: (BuildContext context, bool isLoadMore) => Visibility(
                  visible: isLoadMore,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: SpinKitWave(
                      color: Colors.red,
                      size: 35.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardUI(HomeModel item) {
    return Card(
      elevation: 7,
      margin: EdgeInsets.all(15),
      color: Color(0xffff2fc3),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      DetailProduct(item.uploadId)));
        },
        onDoubleTap: () {
          favoriteHandle(item.uploadId, true).then((value) {
            Toast.show("Add to favorite", context,
                duration: 1, gravity: Toast.BOTTOM);
          });
        },
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.all(1.5),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(item.imgUrl,
                      fit: BoxFit.cover, width: 100, height: 100),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Text(
                            item.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${new String.fromCharCodes(new Runes('\u0024'))} ${item.price.toString()} ',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () {
                                    addToCartHandle(item.uploadId);
                                  },
                                  icon: Icon(Icons.add_shopping_cart),
                                  label: Text("Add to cart"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void searchMethod(String text) {
    store.dispatch(SearchAction(text));
  }
}
