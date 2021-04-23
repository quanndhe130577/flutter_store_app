import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/View/MyCartScreen.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:badges/badges.dart';

import 'InheritedDataProvider.dart';

class StoreActionAppbar extends StatefulWidget {
  final Store<AppState> store;

  StoreActionAppbar({this.store});

  @override
  _StoreActionAppbarState createState() => _StoreActionAppbarState(this.store);
}

class _StoreActionAppbarState extends State<StoreActionAppbar> {
  final Store<AppState> store;

  double opacity;

  _StoreActionAppbarState(this.store);

  @override
  Widget build(BuildContext context) {
    opacity = InheritedDataProvider.of(context).data;
    return Padding(
      padding: EdgeInsets.only(bottom: 7, top: 7),
      child: TextButton(
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyCart(this.store))),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black26.withOpacity(opacity)),
        ),
        child: StoreConnector<AppState, List<CartModel>>(
          converter: (store) => store.state.myCartState.cartList,
          builder: (BuildContext context, List<CartModel> cartList) => Badge(
            badgeColor: Colors.red,
            position: BadgePosition.bottomStart(bottom: 10, start: 10),
            badgeContent: Text(cartList.length.toString(), style: TextStyle(color: Colors.white, fontSize: 10)),
            child: Icon(
              Icons.shopping_cart_outlined,
              color:  opacity <= 0.1 ? Colors.red : Colors.white,
              semanticLabel: "MyCart",
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
