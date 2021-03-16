import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Model/HomeEntity.dart';
import 'package:flutter_food_app/DetailProduct.dart';
import 'package:flutter_food_app/LogInScreen.dart';
import 'UploadData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'MyFavorite.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'MyCart.dart';
import 'Common.dart';

class HomeScreen extends StatefulWidget {
  String currentEmail = "";
  HomeScreen(this.currentEmail);

  @override
  _HomeScreen createState() => _HomeScreen(this.currentEmail);
}

class _HomeScreen extends State<HomeScreen> {
  String currentEmail = "";
  List<HomeModel> dataList = [];
  List<HomeModel> searchList = [];
  FirebaseUser currentUser;
  bool searchState = false;
  bool isLoading = true;
  bool isLoadingMore = false;
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

  int currentIndex = 0;
  int stepLoadMore = 2;
  int lastIndex = 4;
  int numberOfFirstLoad = 5;

  void reloadData() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (this.mounted && !isLoadingMore) {
        setState(() {
          isLoadingMore = true;
        });
      }
      lastIndex += stepLoadMore;
      loadData();
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      // setState(() {
      //   isLoading = true;
      // });
      // Timer(Duration(milliseconds: 2000), () {
      //   setState(() {
      //     isLoading = false;
      //   });
      // });
      loadData();
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(reloadData);
    super.initState();
    auth.currentUser().then((value) => {this.currentUser = value});
    loadData();
  }

  void loadData() async {
    if (this.mounted && !isLoadingMore) {
      setState(() {
        isLoading = true;
        //dataList = dataList;
      });
    }
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("Data");
    await reference.once().then((DataSnapshot dataSnapShot) async {
      //dataList.clear();
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      var count = 0;
      for (var key in keys) {
        if (numberOfFirstLoad == 0) {
          if (count <= currentIndex) {
            count++;
            continue;
          }
          if (currentIndex > lastIndex) {
            //currentIndex = lastIndex;
            break;
          } else {
            currentIndex++;
            count++;
          }
        } else {
          count++;
          currentIndex++;
          numberOfFirstLoad--;
        }

        bool fav = false;
        DatabaseReference favRef = FirebaseDatabase.instance
            .reference()
            .child("Data")
            .child(key)
            .child("Fav")
            .child(currentUser.uid);
        await favRef.once().then((value) {
          if (value.value != null && value.value["state"] == true) {
            fav = true;
          }
          HomeModel data = new HomeModel(
            key,
            values[key]["imgUrl"],
            values[key]["name"],
            values[key]["price"],
            values[key]["material"],
          );
          dataList.add(data);
        });
      }

      //dataList.sort((a, b) => a.name.compareTo(b.name));
      //searchList = new List<Data>.from(dataList);
      searchList = [...dataList]; //clone dataList
    }).whenComplete(
      () => {
        if (this.mounted)
          {
            setState(() {
              isLoading = false;
              isLoadingMore = false;
              //dataList = dataList;
            })
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onChanged: (text) {
                  searchMethod(text.toLowerCase());
                },
                autofocus: true,
              ),
        actions: [
          searchState
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  color: Colors.white,
                  onPressed: () {
                    loadData();
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
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MyCart()));
              },
              icon: Icon(Icons.shopping_cart, color: Colors.black),
              label: Text(""),
            ),
          )
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
                            builder: (BuildContext context) => UploadData()))
                    .then((value) => loadData());
                loadData();
              },
            ),
            ListTile(
              title: Text("My Favorite"),
              leading: Icon(Icons.favorite),
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MyFavorite()))
                    .then((value) => loadData());
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
          Visibility(
            visible: isLoading,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: SpinKitWave(
                color: Colors.red,
                size: 35.0,
              ),
            ),
          ),
          Expanded(
            child: searchList.length == 0
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
          Visibility(
            visible: isLoadingMore,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: SpinKitWave(
                color: Colors.red,
                size: 35.0,
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
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
                  builder: (BuildContext context) => DetailProduct(item.uploadId)));
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
                              '${new String.fromCharCodes(new Runes('\u0024'))} ${item.price} ',
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
    searchList.clear();
    for (var item in dataList) {
      if (item.name.toLowerCase().contains(text.toLowerCase()) ||
          item.material.toLowerCase().contains(text.toLowerCase())) {
        searchList.add(item);
      }
    }
    if (this.mounted) {
      setState(() {
        //
      });
    }
  }
}
