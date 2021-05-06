import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/CommonWidget/CustomAppBar.dart';
import 'package:flutter_food_app/CommonWidget/InheritedAppbarProvider.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/Home/HomeActions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_food_app/Common.dart';

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
            reduxStore: this.store,
            child: CustomAppBar(),
            opacity: (1 - opacityAppbar) * 0.2,
            title: TextField(
              controller: _textFiledController,
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.red),
                hintText: "Search . . . ",
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
        body: Container(),
      ),
    );
  }
}
