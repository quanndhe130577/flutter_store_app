import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_app/Common.dart';
import 'package:flutter_food_app/CommonWidget/CustomAppBar.dart';
import 'package:flutter_food_app/CommonWidget/InheritedAppbarProvider.dart';
import 'package:flutter_food_app/View/SearchScreen.dart';
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
import 'package:toast/toast.dart';
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
  bool isInLoadingMore = false;
  bool isHeadOfContext = true;
  double opacityAppbar = 0;
  double heightOfSlide = 150;
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

  void handleControllerHome() async {
    // if (_controller.offset >= _controller.position.maxScrollExtent &&
    //     !_controller.position.outOfRange) {
    //   //await Future.delayed(Duration(seconds: 1));
    //   //store.dispatch(LoadMoreDataHomeAction());
    // }

    if (_controller.offset >=
            _controller.position.maxScrollExtent -
                double.parse(stepLoadMore.toString()) *
                    (getHeightForWidget(this.context, dividedBy: numberOfCartInScreen) / 2) &&
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
    if (_controller.offset <= _controller.position.minScrollExtent + this.heightOfSlide) {
      if (this.mounted) {
        setState(() {
          opacityAppbar = _controller.offset / this.heightOfSlide;
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

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double paddingTopMedia = MediaQuery.of(context).padding.top;
    heightOfSlide = getHeightForWidget(this.context, dividedBy: 5);
    final double lengthForACart =
        getHeightForWidget(this.context, dividedBy: this.numberOfCartInScreen, sub: this.heightOfSlide);

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
            child: InheritedAppBarProvider(
              opacity: this.opacityAppbar * 0.2,
              title: GestureDetector(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (BuildContext context) => SearchScreen(this.store))),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: this.opacityAppbar <= 0.5 ? Colors.white : Colors.black12.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.black.withOpacity(0.5)),
                      SizedBox(width: 5),
                      StoreConnector<AppState, String>(
                        converter: (store) => store.state.searchState.searchText,
                        builder: (BuildContext context, String searchText) =>
                            Expanded(child: Text(searchText, style: TextStyle(color: Colors.red, fontSize: 15))),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.camera_alt_outlined, color: Colors.black.withOpacity(0.5)),
                    ],
                  ),
                ),
              ),
              child: CustomAppBar(
                store: this.store,
                handleLeading: () => _scaffoldKey.currentState.openDrawer(),
                iconDataLeading: Icons.dehaze_rounded,
              ),
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
                  converter: (store) => store.state.homeState.dataList,
                  onWillChange: (prev, cur) {},
                  onDidChange: (prev, cur) {
                    if (store.state.homeState.dataList.length > this.numberOfCartInScreen &&
                        _controller.offset == _controller.position.maxScrollExtent) {
                      Toast.show("You reached the end", context, duration: 1);
                      _controller.animateTo(
                        _controller.position.maxScrollExtent - 50,
                        curve: Curves.linear,
                        duration: Duration(microseconds: 1),
                      );
                    }
                    if (this.mounted) {
                      setState(() {
                        this.isInLoadingMore = false;
                      });
                    }
                  },
                  builder: (context, List<HomeModel> dataList) => dataList.length == 0
                      ? Center(
                          child: Text("No data available", style: TextStyle(fontSize: 30)),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(top: paddingTopMedia),
                          //physics: BouncingScrollPhysics(),
                          controller: _controller,
                          itemCount: dataList.length + 2,
                          scrollDirection: Axis.vertical,
                          //itemExtent: _getHeightForCart(this.context, dividedBy: numberOfCartInScreen),
                          itemBuilder: (buildContext, index) {
                            //final double height = MediaQuery.of(context).size.height;
                            if (index == 0) {
                              return CarouselSlider(
                                options: CarouselOptions(
                                  aspectRatio: 2,
                                  //enlargeCenterPage: true,
                                  scrollDirection: Axis.vertical,
                                  autoPlay: true,
                                  height: this.heightOfSlide,
                                  viewportFraction: 1,
                                ),
                                items: listImage
                                    .map((item) => Image.network(
                                          item,
                                          fit: BoxFit.cover,
                                          height: 150,
                                        ))
                                    .toList(),
                              );
                            } else if (index == dataList.length + 1) {
                              if (dataList.length > 4) {
                                return Container(
                                  height: 50,
                                  child: SpinKitWave(color: Colors.red, size: 35.0),
                                );
                              }
                              return null;
                            }
                            return cardUI(dataList[index - 1], lengthForACart);
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

  Widget cardUI(HomeModel item, double length) {
    return Card(
      elevation: 7,
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
                  child: Image.network(item.imgUrl, fit: BoxFit.cover, width: length - 20, height: length - 20),
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
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void addToCartHandle(String uploadId) {
    store.dispatch(AddToCartMyCartAction(uploadId));
  }
}
