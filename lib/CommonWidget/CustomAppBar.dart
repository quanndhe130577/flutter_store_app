import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/View/MyCartScreen.dart';
import 'package:flutter_food_app/redux/AppState.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:badges/badges.dart';

import 'InheritedAppbarProvider.dart';

class CustomAppBar extends StatefulWidget {
  final Store<AppState> store;
  final IconData iconDataLeading;
  final Function handleLeading;

  CustomAppBar({this.store, this.iconDataLeading, this.handleLeading});

  @override
  _CustomAppBarState createState() => _CustomAppBarState(
      //this.store,
      this.iconDataLeading,
      this.handleLeading);
}

class _CustomAppBarState extends State<CustomAppBar> {
  double opacityAppbar = 0;
  Store<AppState> store;
  IconData iconDataLeading;
  Function handleLeading;

  _CustomAppBarState(
      //this.store,
      this.iconDataLeading,
      this.handleLeading);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _defaultHandleLeading() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    this.opacityAppbar = InheritedAppBarProvider.of(context).opacity;
    this.store = InheritedAppBarProvider.of(context).reduxStore;
    print(this.store.state.myCartState.cartList.length.toString());
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 7, top: 7),
        child: TextButton(
          onPressed: this.handleLeading != null ? this.handleLeading : this._defaultHandleLeading,
          child: Icon(this.iconDataLeading != null ? this.iconDataLeading : Icons.arrow_back,
              color: this.opacityAppbar <= 0.1 ? Colors.red : Colors.white, size: 20),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black26.withOpacity(this.opacityAppbar)),
          ),
        ),
      ),
      backgroundColor:
          this.opacityAppbar != 0.2 ? Colors.white.withOpacity(1 - this.opacityAppbar / 0.2) : Colors.transparent,
      elevation: (1 - this.opacityAppbar / 0.2) * 5,
      title: InheritedAppBarProvider.of(context).title != null ? InheritedAppBarProvider.of(context).title : Text(""),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(bottom: 7, top: 7),
          child: TextButton(
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyCart(this.store))),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black26.withOpacity(this.opacityAppbar)),
            ),
            child: Badge(
              badgeColor: Colors.red,
              position: BadgePosition.bottomStart(bottom: 10, start: 10),
              badgeContent: Text(this.store.state.myCartState.cartList.length.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10)),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: this.opacityAppbar <= 0.1 ? Colors.red : Colors.white,
                semanticLabel: "MyCart",
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
