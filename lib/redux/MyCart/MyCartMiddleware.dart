import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/redux/AppState.dart';

import 'package:redux/redux.dart';

import 'MyCartActions.dart';

import 'package:firebase_database/firebase_database.dart';

Future<List<CartModel>> _getDataMyCart(String uid) async {
  List<CartModel> cartList = [];

  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child("Data");
  await reference.once().then((DataSnapshot dataSnapShot) async {
    var keys = dataSnapShot.value.keys;
    var values = dataSnapShot.value;

    for (var key in keys) {
      DatabaseReference inCartRef = FirebaseDatabase.instance
          .reference()
          .child("Data")
          .child(key)
          .child("InCart")
          .child(uid);

      await inCartRef.once().then((inCartItem) {
        if (inCartItem.value != null && inCartItem.value["state"] == true) {
          CartModel data = new CartModel(
              key,
              values[key]["imgUrl"],
              values[key]["name"],
              double.parse(values[key]["price"].toString()),
              inCartItem.value["quantity"]);
          cartList.add(data);
        }
      });
    }
    //dataList.sort((a, b) => a.name.compareTo(b.name));
  });
  return cartList;
}

void myCartStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  if (action.runtimeType.toString() ==
      (FirstLoadCartModelMyCartAction).toString()) {
    await _getDataMyCart(action.uid).then(
        (cartList) => store.dispatch(FirstLoadCartModelMyCartState(cartList)));
  }
}
