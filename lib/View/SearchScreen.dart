import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/CommonWidget/CustomAppBar.dart';
import 'package:flutter_food_app/CommonWidget/InheritedAppbarProvider.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/Home/HomeActions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_food_app/Common.dart';

import 'MyCartScreen.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    _textFiledController = TextEditingController();
    super.initState();
  }

  void searchMethod(String text) async {
    showSimpleLoadingModalDialog(this.context);
    await Future.delayed(Duration(seconds: 1));
    store.dispatch(SearchHomeAction(text));
  }

  @override
  Widget build(BuildContext context) {
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
            actions: [
              Padding(
                padding: EdgeInsets.only(bottom: 7, top: 7, left: 7),
                child: TextButton(
                  onPressed: () => {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
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
                    converter: (store) => store.state.homeState.searchText,
                    builder: (BuildContext context, String searchText) => Expanded(
                      child: Container(
                        height: 40,
                        child: TextField(
                          controller: _textFiledController,
                          decoration: InputDecoration(
                            //icon: Icon(Icons.search, color: Colors.red),
                            hintText: searchText,
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
                            //searchMethod(text.toLowerCase());
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
        body: Container(),
      ),
    );
  }
}
