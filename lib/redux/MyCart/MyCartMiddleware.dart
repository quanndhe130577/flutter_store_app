import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/redux/AppState.dart';

import 'package:redux/redux.dart';

import 'MyCartActions.dart';

import 'package:firebase_database/firebase_database.dart';

Future<List<CartModel>> _getDataMyCart(String uid) async {
  List<CartModel> cartList = [];

  DatabaseReference reference = FirebaseDatabase.instance.reference().child("Data");
  await reference.once().then((DataSnapshot dataSnapShot) async {
    var keys = dataSnapShot.value.keys;
    var values = dataSnapShot.value;

    for (var key in keys) {
      DatabaseReference inCartRef =
          FirebaseDatabase.instance.reference().child("Data").child(key).child("InCart").child(uid);

      await inCartRef.once().then((inCartItem) {
        if (inCartItem.value != null && inCartItem.value["state"] == true) {
          CartModel data = new CartModel(key, values[key]["imgUrl"], values[key]["name"],
              double.parse(values[key]["price"].toString()), inCartItem.value["quantity"]);
          cartList.add(data);
        }
      });
    }
    //dataList.sort((a, b) => a.name.compareTo(b.name));
  });
  return cartList;
}

Future<void> _removeFromCartHandle(String uploadId, String uid) async {
  DatabaseReference favRef = FirebaseDatabase.instance
      .reference()
      .child("Data")
      .child(uploadId)
      .child("InCart")
      .child(uid);
  await favRef.child("state").set(false);
  await favRef.child("quantity").set(0);
}

Future<void> _quantityHandle(String uploadId, int type, String uid) async {
  DatabaseReference favRef = FirebaseDatabase.instance
      .reference()
      .child("Data")
      .child(uploadId)
      .child("InCart")
      .child(uid);
  await favRef.once().then((item) async {
    if (item.value["state"] != null) {
      if (item.value["state"] == true) {
        if (type == 0) {
          await favRef.child("quantity").set(item.value["quantity"] + 1);
        } else if (type == 1 && item.value["quantity"] > 1) {
          await favRef.child("quantity").set(item.value["quantity"] - 1);
        }
      }
    }
  });
}

Future<CartModel> _addToCartHandle(String uploadId, String uid) async {
  CartModel pro = new CartModel(uploadId, "", "", 0, 1);

  DatabaseReference itemRef = FirebaseDatabase.instance.reference().child("Data").child(uploadId);

  itemRef.once().then((item) {
    pro.imgUrl = item.value["imgUrl"].toString();
    pro.name = item.value["name"].toString();
    pro.price = double.parse(item.value["price"].toString());

    if (item.value["InCart"] == null || item.value["InCart"][uid] == null) {
      itemRef.child("InCart").child(uid).child("state").set(true);
      itemRef.child("InCart").child(uid).child("quantity").set(1);
    } else {
      itemRef.child("InCart").child(uid).once().then((itemInCart) {
        //if (item.value["state"] != null) {
        if (itemInCart.value["state"] == true) {
          itemRef
              .child("InCart")
              .child(uid)
              .child("quantity")
              .set(itemInCart.value["quantity"] + 1);
        } else {
          itemRef.child("InCart").child(uid).child("state").set(true);
          itemRef.child("InCart").child(uid).child("quantity").set(1);
        }
        //}
      });
    }
  });
  return pro;
}

void myCartStateMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  if (action.runtimeType.toString() == (FirstLoadCartModelMyCartAction).toString()) {
    await _getDataMyCart(action.uid)
        .then((cartList) => store.dispatch(FirstLoadCartModelMyCartState(cartList)));
  } else if (action.runtimeType.toString() == (RemoveFromCartMyCartAction).toString()) {
    await _removeFromCartHandle(action.productId, store.state.uid)
        .then((value) => store.dispatch(RemoveFromCartMyCartState(action.productId)));
  } else if (action.runtimeType.toString() == (HandleQuantityMyCartAction).toString()) {
    await _quantityHandle(action.uploadId, action.type, store.state.uid)
        .then((value) => store.dispatch(HandleQuantityMyCartState(action.uploadId, action.type)));
  } else if (action.runtimeType.toString() == (AddToCartMyCartAction).toString()) {
    await _addToCartHandle(action.uploadId, store.state.uid)
        .then((item) => store.dispatch(AddToCartMyCartState(item)));
  }
}
