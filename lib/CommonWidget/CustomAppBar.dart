import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/View/MyCartScreen.dart';
import 'package:flutter_food_app/redux/AppState.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:badges/badges.dart';

import 'InheritedDataProvider.dart';

class CustomAppBar extends StatefulWidget {
  final Store<AppState> store;
  final Widget title;
  IconData iconDataLeading;
  Function handleLeading;

  CustomAppBar({@required this.store, this.title, this.iconDataLeading, this.handleLeading});

  @override
  _CustomAppBarState createState() =>
      _CustomAppBarState(this.store, this.title, this.iconDataLeading, this.handleLeading);
}

class _CustomAppBarState extends State<CustomAppBar> {
  double opacityAppbar = 0;
  Store<AppState> store;
  Widget title = Text("");
  IconData iconDataLeading;
  Function handleLeading;

  _CustomAppBarState(this.store, this.title, this.iconDataLeading, this.handleLeading);

  @override
  void initState() {
    // TODO: implement initState
    handleLeading = () => Navigator.of(context).pop();
    iconDataLeading = Icons.arrow_back;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.opacityAppbar = InheritedAppBarProvider.of(context).opacity;
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 7, top: 7),
        child: TextButton(
          onPressed: handleLeading,
          child: Icon(this.iconDataLeading, color: this.opacityAppbar <= 0.1 ? Colors.red : Colors.white, size: 20),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black26.withOpacity(this.opacityAppbar)),
          ),
        ),
      ),
      backgroundColor:
          this.opacityAppbar == 0 ? Colors.white.withOpacity(1 - this.opacityAppbar / 0.2) : Colors.transparent,
      elevation: 0.0,
      title: InheritedAppBarProvider.of(context).title,
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
            child: StoreConnector<AppState, List<CartModel>>(
              converter: (store) => store.state.myCartState.cartList,
              builder: (BuildContext context, List<CartModel> cartList) => Badge(
                badgeColor: Colors.red,
                position: BadgePosition.bottomStart(bottom: 10, start: 10),
                badgeContent: Text(cartList.length.toString(), style: TextStyle(color: Colors.white, fontSize: 10)),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: this.opacityAppbar <= 0.1 ? Colors.red : Colors.white,
                  semanticLabel: "MyCart",
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        // InheritedDataProvider(
        //   child: StoreActionAppbar(store: this.store),
        //   data: (1 - opacityAppbar) * 0.2,
        // ),
      ],
    );
  }
}
