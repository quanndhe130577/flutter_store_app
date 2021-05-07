import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/CommonWidget/CustomAppBar.dart';
import 'package:flutter_food_app/CommonWidget/InheritedAppbarProvider.dart';
import 'package:flutter_food_app/Model/SearchEntity.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartActions.dart';
import 'package:flutter_food_app/redux/MyFavorite/MyFavoriteActions.dart';
import 'package:flutter_food_app/redux/Search/SearchActions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_food_app/Common.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'DetailProductScreen.dart';

class SearchScreen extends StatefulWidget {
  final Store<AppState> store;

  SearchScreen(this.store);

  @override
  _SearchScreenState createState() => _SearchScreenState(this.store);
}

class _SearchScreenState extends State<SearchScreen> {
  Store<AppState> store;

  _SearchScreenState(this.store);

  TextEditingController _textFiledController;

  bool isHeadOfContext = true;
  double opacityAppbar = 0;

  bool isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    _textFiledController = TextEditingController();
    super.initState();
  }

  void searchMethod(String text) async {
    showSimpleLoadingModalDialog(this.context);
    await Future.delayed(Duration(seconds: 1));
    store.dispatch(FirstLoadSearchAction(text));
  }

  void handleLeading(BuildContext context) {
    store.dispatch(ClearDataSearchAction());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double paddingTopMedia = MediaQuery.of(context).padding.top;
    return StoreProvider(
      store: this.store,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(heightOfAppBar),
          child: InheritedAppBarProvider(
            child: CustomAppBar(
              store: this.store,
              handleLeading: handleLeading,
            ),
            opacity: 0.2,
            actions: [
              Visibility(
                visible: this.isSearching,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 7, top: 7, left: 7),
                  child: TextButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black26.withOpacity(0.2 - this.opacityAppbar * 0.2)),
                    ),
                    child: Icon(
                      Icons.filter_alt_outlined,
                      color: this.opacityAppbar >= 0.1 ? Colors.red : Colors.white,
                      semanticLabel: "MyCart",
                      size: 25,
                    ),
                  ),
                ),
              ),
            ],
            title: Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                color: Colors.black12.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              //color: this.opacityAppbar <= 0.5 ? Colors.white : Colors.black12.withOpacity(0.2),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black.withOpacity(0.5)),
                  SizedBox(width: 5),
                  StoreConnector<AppState, String>(
                    converter: (store) => store.state.searchState.searchText,
                    builder: (BuildContext context, String searchText) => Expanded(
                      child: Container(
                        height: 40,
                        child: TextField(
                          controller: _textFiledController,
                          decoration: InputDecoration(
                            //icon: Icon(Icons.search, color: Colors.red),
                            //hintText: searchText,
                            labelText: searchText,
                            hintStyle: TextStyle(color: Colors.black54),
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
                          },
                          autofocus: false,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.camera_alt_outlined, color: Colors.black.withOpacity(0.5)),
                ],
              ),
            ),
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
              child: StoreConnector<AppState, List<SearchModel>>(
                converter: (store) => store.state.searchState.searchList,
                distinct: true,
                onWillChange: (prev, cur) {
                  Navigator.of(this.context).pop();
                },
                onDidChange: (prev, cur) {
                  print("haha");
                },
                builder: (context, List<SearchModel> dataList) => dataList.length == 0
                    ? Center(
                        child: Text("No data available", style: TextStyle(fontSize: 30)),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(top: paddingTopMedia),
                        //physics: BouncingScrollPhysics(),
                        itemCount: dataList.length + 1,
                        scrollDirection: Axis.vertical,
                        //itemExtent: _getHeightForCart(this.context, dividedBy: 5.6),
                        itemBuilder: (buildContext, index) {
                          if (index == dataList.length) {
                            if (dataList.length > 4) {
                              return SpinKitWave(color: Colors.red, size: 35.0);
                            }
                            return null;
                          }
                          return cardUI(dataList[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardUI(SearchModel item) {
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
