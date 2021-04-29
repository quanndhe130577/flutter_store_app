import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_app/Common.dart';
import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/redux/AppActions.dart';
import 'package:flutter_food_app/redux/AppReducers.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/AppMiddleware.dart';
import 'package:flutter_food_app/redux/Home/HomeActions.dart';
import 'package:flutter_food_app/redux/Home/HomeMiddleware.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartActions.dart';
import 'package:flutter_food_app/redux/MyFavorite/MyFavoriteActions.dart';
import 'package:flutter_food_app/Model/HomeEntity.dart';
import 'package:flutter_food_app/View/DetailProductScreen.dart';
import 'package:flutter_food_app/View/LogInScreen.dart';
import 'UploadDataScreen.dart';
import 'package:flutter_food_app/View/MyFavoriteScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_food_app/View//MyCartScreen.dart';
import 'package:toast/toast.dart';
import 'package:badges/badges.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  final String currentEmail;
  final String uid;

  HomeScreen(this.currentEmail, this.uid);

  @override
  _HomeScreen createState() => _HomeScreen(this.currentEmail, this.uid);
}

class _HomeScreen extends State<HomeScreen> {
  final String currentEmail;
  final String uid;

  _HomeScreen(this.currentEmail, this.uid);

  Store<AppState> store;

  // declare state for HomeScreen
  bool searchState = false;
  bool isInLoadingMore = false;
  bool isInLoadingSearch = false;
  bool isHeadOfContext = true;
  double opacityAppbar = 0;
  List<String> listImage = [
    "https://i.imgur.com/NCGELsD.jpg",
    "https://i.imgur.com/68yHTO9.jpg",
    "https://i.imgur.com/gWjAMXQ.jpg",
    "https://i.imgur.com/yfqRp7o.jpg"
  ];

  //

  // declare final variable
  final double numberOfCartInScreen = 4.6;

  //

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> logOut() async {
    await auth.signOut().then((value) {
      store.dispatch(ClearStateAppAction());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LogInScreen()));
    });
  }

  ScrollController _controller;
  TextEditingController _textFiledController;

  void handleControllerHome() async {
    // if (_controller.offset >= _controller.position.maxScrollExtent &&
    //     !_controller.position.outOfRange) {
    //   //await Future.delayed(Duration(seconds: 1));
    //   //store.dispatch(LoadMoreDataHomeAction());
    // }

    if (_controller.offset >=
            _controller.position.maxScrollExtent -
                double.parse(stepLoadMore.toString()) *
                    (_getHeightForCart(this.context, dividedBy: numberOfCartInScreen) / 2) &&
        //!store.state.homeState.isLoadingMore &&
        !isInLoadingMore) {
      if (this.mounted) {
        setState(() {
          this.isInLoadingMore = true;
        });
      }
      //await Future.delayed(Duration(seconds: 1));
      store.dispatch(LoadMoreDataHomeAction());
    }

    /*if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange &&
        !store.state.homeState.isLoading) {
      store.dispatch(RefreshDataHomeAction());
    } else */
    if (searchState) {
      if (this.mounted) {
        setState(() {
          opacityAppbar = 1;
          this.isHeadOfContext = false;
        });
      }
    } else if (_controller.offset <= _controller.position.minScrollExtent + 30) {
      if (this.mounted) {
        setState(() {
          opacityAppbar = 0;
          this.isHeadOfContext = true;
        });
      }
    } else if (_controller.offset <= _controller.position.minScrollExtent + 50) {
      if (this.mounted) {
        setState(() {
          opacityAppbar = 0.2;
          this.isHeadOfContext = false;
        });
      }
    } else if (_controller.offset <= _controller.position.minScrollExtent + 70) {
      if (this.mounted) {
        setState(() {
          opacityAppbar = 0.4;
          this.isHeadOfContext = false;
        });
      }
    } else if (_controller.offset <= _controller.position.minScrollExtent + 90) {
      if (this.mounted) {
        setState(() {
          opacityAppbar = 0.6;
          this.isHeadOfContext = false;
        });
      }
    } else if (_controller.offset <= _controller.position.minScrollExtent + 110) {
      if (this.mounted) {
        setState(() {
          opacityAppbar = 0.8;
          this.isHeadOfContext = false;
        });
      }
    } else if (opacityAppbar != 1) {
      if (this.mounted) {
        setState(() {
          opacityAppbar = 1;
          this.isHeadOfContext = false;
        });
      }
    }
  }

  @override
  void initState() {
    store = Store<AppState>(
      appReducers,
      initialState: AppState(this.uid),
      middleware: [appStateMiddleware],
    );

    _controller = ScrollController();
    _controller.addListener(handleControllerHome);

    _textFiledController = TextEditingController();
    super.initState();
  }

  double _getHeightForCart(BuildContext context, {double dividedBy = 1}) {
    double height = MediaQuery.of(context).size.height - heightOfAppBar;

    // Height (without SafeArea)
    var padding = MediaQuery.of(context).padding;
    double newHeight = height - padding.top - padding.bottom;

    return newHeight / dividedBy;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double paddingTopMedia = MediaQuery.of(context).padding.top;
    return StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(
        onInit: (store) => store.dispatch(InitAppAction(store.state.uid)),
        builder: (BuildContext context, Store<AppState> store) => Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          backgroundColor: Color(0xffffffff),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(heightOfAppBar),
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.dehaze_rounded, color: isHeadOfContext && !searchState ? Colors.white : Colors.blue),
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
              backgroundColor:
                  isHeadOfContext && !searchState ? Colors.transparent : Colors.white.withOpacity(opacityAppbar),
              //backgroundColor: isHeadOfContext ? Colors.transparent : Color(0xffff2fc3).withOpacity(opacityAppbar),
              elevation: opacityAppbar * 10,
              title: TextField(
                controller: _textFiledController,
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: isHeadOfContext && !searchState ? Colors.white : Colors.red),
                  hintText: "Search . . . ",
                  hintStyle: TextStyle(color: isHeadOfContext && !searchState ? Colors.white : Colors.black54),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (text) {
                  searchMethod(text.toLowerCase());
                  setState(() {
                    searchState = true;
                  });
                },
                autofocus: false,
              ),
              centerTitle: false,
              actions: [
                Visibility(
                  visible: searchState,
                  child: IconButton(
                    icon: Icon(Icons.cancel),
                    color: isHeadOfContext && !searchState ? Colors.white : Colors.red,
                    onPressed: () {
                      _textFiledController.value =
                          new TextEditingController.fromValue(new TextEditingValue(text: "")).value;
                      store.dispatch(RemoveSearchHomeState());
                      setState(() {
                        searchState = !searchState;
                      });
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyCart(this.store)));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: StoreConnector<AppState, List<CartModel>>(
                      converter: (store) => store.state.myCartState.cartList,
                      builder: (BuildContext context, List<CartModel> cartList) => Badge(
                        badgeColor: Colors.red,
                        position: BadgePosition.bottomStart(bottom: 10, start: 15),
                        badgeContent: Text(cartList.length.toString(), style: TextStyle(color: Colors.white)),
                        child: Icon(
                          Icons.shopping_cart,
                          color: isHeadOfContext && !searchState ? Colors.white : Colors.blue,
                          semanticLabel: "MyCart",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                      Image(image: AssetImage("images/icon.jpg"), height: 90, width: 90),
                      SizedBox(height: 10),
                      Text(currentEmail, style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
                ListTile(
                  title: Text("Upload"),
                  leading: Icon(Icons.cloud_upload),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UploadData()))
                        .then((value) => {});
                    //loadFirstData();
                  },
                ),
                ListTile(
                  title: Text("My Favorite"),
                  leading: Icon(Icons.favorite),
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (BuildContext context) => MyFavorite(this.store)));
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
              /*StoreConnector<AppState, bool>(
                converter: (store) => store.state.homeState.isLoading,
                builder: (BuildContext context, bool isLoading) =>
                    Visibility(
                  visible: isLoading && !this.isInLoadingSearch,
                  child: Padding(
                    padding: EdgeInsets.only(top: paddingTopMedia + heightOfAppBar),
                    child: SpinKitWave(
                      color: Colors.red,
                      size: 35.0,
                    ),
                  ),
                ),
              ),*/
              Expanded(
                child: StoreConnector<AppState, List<HomeModel>>(
                  distinct: true,
                  converter: (store) => store.state.homeState.searchList,
                  onWillChange: (prev, cur) {
                    if (prev != cur && this.isInLoadingSearch) {
                      Navigator.of(this.context).pop();
                    }
                  },
                  onDidChange: (prev, cur) {
                    if (isInLoadingSearch) {
                      _controller.animateTo(0.1, duration: Duration(milliseconds: 1), curve: Curves.linear);
                    } else if (store.state.homeState.searchList.length > this.numberOfCartInScreen &&
                        _controller.offset == _controller.position.maxScrollExtent) {
                      Toast.show("You reached the end", context);
                      _controller.animateTo(
                        _controller.position.maxScrollExtent -
                            _getHeightForCart(this.context, dividedBy: this.numberOfCartInScreen),
                        curve: Curves.linear,
                        duration: Duration(microseconds: 1),
                      );
                    }
                    if (this.mounted) {
                      setState(() {
                        this.isInLoadingMore = false;
                        this.isInLoadingSearch = false;
                      });
                    }
                  },
                  builder: (context, List<HomeModel> searchList) => searchList.length == 0
                      ? Center(
                          child: Text("No data available", style: TextStyle(fontSize: 30)),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(top: paddingTopMedia),
                          //physics: BouncingScrollPhysics(),
                          controller: _controller,
                          itemCount: searchList.length + 1,
                          scrollDirection: Axis.vertical,
                          itemExtent: _getHeightForCart(this.context, dividedBy: numberOfCartInScreen),
                          itemBuilder: (buildContext, index) {
                            final double height = MediaQuery.of(context).size.height;
                            if (index == 0 && !searchState) {
                              return CarouselSlider(
                                options: CarouselOptions(
                                  aspectRatio: 2,
                                  //enlargeCenterPage: true,
                                  scrollDirection: Axis.vertical,
                                  autoPlay: true,
                                  height: height,
                                  viewportFraction: 1,
                                ),
                                items: listImage
                                    .map((item) => Image.network(
                                          item,
                                          fit: BoxFit.cover,
                                          height: height,
                                        ))
                                    .toList(),
                              );
                            } else if (index == searchList.length) {
                              if (searchList.length > 4) {
                                return SpinKitWave(color: Colors.red, size: 35.0);
                              }
                              return null;
                            }
                            return cardUI(searchList[index]);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardUI(HomeModel item) {
    return Card(
      elevation: 7,
      //margin: EdgeInsets.all(3),
      //color: Color(0xffff2fc3),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.all(1.5),
        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DetailProductScreen(item.uploadId, this.store)));
                  },
                  onDoubleTap: () {
                    Toast.show("Add to favorite", context, duration: 1, gravity: Toast.BOTTOM);
                    if (!store.state.myFavState.favList.any((element) => element.uploadId == item.uploadId)) {
                      store.dispatch(HandleFavMyFavAction(item.uploadId, true));
                    }
                  },
                  child: Image.network(item.imgUrl, fit: BoxFit.cover, width: 100, height: 100),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          shortenString(item.name, 15),
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
                            style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
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
    );
  }

  void searchMethod(String text) async {
    if (this.mounted) {
      setState(() {
        isInLoadingSearch = true;
      });
    }
    showSimpleLoadingModalDialog(this.context);
    await Future.delayed(Duration(seconds: 1));
    store.dispatch(SearchHomeAction(text));
  }

  void addToCartHandle(String uploadId) {
    store.dispatch(AddToCartMyCartAction(uploadId));
  }
}
