import 'package:flutter_food_app/Model/HomeEntity.dart';
import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/Home/HomeMiddleware.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartMiddleware.dart';
import 'package:redux/redux.dart';
import 'package:firebase_database/firebase_database.dart';

import 'AppActions.dart';

Future<List<HomeModel>> _loadFirstHomeModelData(String keyword) async {
  List<HomeModel> dataList = [];

  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child("Data");
  await reference.once().then((DataSnapshot dataSnapShot) {
    var keys = dataSnapShot.value.keys;
    var values = dataSnapShot.value;

    var count = 0;
    for (var key in keys) {
      if (count >= 5) {
        break;
      }
      if (keyword.isNotEmpty) {
        if (!values[key]["name"].toString().contains(keyword)) {
          continue;
        }
      }
      HomeModel data = new HomeModel(
        key,
        values[key]["imgUrl"],
        values[key]["name"],
        double.parse(values[key]["price"].toString()),
        values[key]["material"],
      );
      dataList.add(data);
      count++;
    }
  });

  return dataList;
}

Future<List<CartModel>> _loadCartModelData(String uid) async {
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

void appStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  if (action.runtimeType.toString().endsWith("HomeState") ||
      action.runtimeType.toString().endsWith("HomeAction")) {
    homeStateMiddleware(store, action, next);
  } else if (action.runtimeType.toString().endsWith("MyCartState") ||
      action.runtimeType.toString().endsWith("MyCartAction")) {
    myCartStateMiddleware(store, action, next);
  } else if (action.runtimeType.toString().endsWith("AppAction") ||
      action.runtimeType.toString().endsWith("AppState")) {
    next(action);
    if (action.runtimeType.toString() == (InitAppAction).toString()) {
      store.dispatch(StartInitAppState());
      List<HomeModel> dataList = await _loadFirstHomeModelData("");
      List<CartModel> cartList = await _loadCartModelData(store.state.uid);
      store.dispatch(InitAppState(dataList, cartList));
    }
  }
}
