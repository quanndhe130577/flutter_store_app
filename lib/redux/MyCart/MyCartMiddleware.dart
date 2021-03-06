import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/redux/AppState.dart';

import 'package:redux/redux.dart';

import 'MyCartActions.dart';

import 'package:firebase_database/firebase_database.dart';

Future<void> _removeFromCartHandle(List<String> listId, String uid) async {
  DatabaseReference dataRef = FirebaseDatabase.instance.reference().child("Data");
  for (int i = 0; i < listId.length; i++) {
    DatabaseReference favRef = dataRef.child(listId[i]).child("InCart").child(uid);
    await favRef.child("state").set(false);
    await favRef.child("quantity").set(0);
  }
}

Future<int> _quantityHandle(String uploadId, int type, String uid) async {
  int number = 0;
  DatabaseReference favRef = FirebaseDatabase.instance
      .reference()
      .child("Data")
      .child(uploadId)
      .child("InCart")
      .child(uid);
  await favRef.once().then((item) async {
    if (item.value["state"] != null) {
      if (item.value["state"] == true) {
        number = item.value["quantity"];
        if (type == 0) {
          await favRef.child("quantity").set(++number);
        } else if (type == 1 && item.value["quantity"] > 1) {
          await favRef.child("quantity").set(--number);
        }
      }
    }
  });
  return number;
}

Future<CartModel> _addToCartHandle(String uploadId, String uid) async {
  CartModel pro = new CartModel(uploadId, "", "", 0, 1);

  DatabaseReference itemRef = FirebaseDatabase.instance.reference().child("Data").child(uploadId);

  await itemRef.once().then((item) async {
    pro.imgUrl = item.value["imgUrl"].toString();
    pro.name = item.value["name"].toString();
    pro.price = double.parse(item.value["price"].toString());

    if (item.value["InCart"] == null || item.value["InCart"][uid] == null) {
      await itemRef.child("InCart").child(uid).child("state").set(true);
      await itemRef.child("InCart").child(uid).child("quantity").set(1);
    } else {
      await itemRef.child("InCart").child(uid).once().then((itemInCart) async {
        if (itemInCart.value["state"] == true) {
          pro.quantity = itemInCart.value["quantity"] + 1;
          await itemRef
              .child("InCart")
              .child(uid)
              .child("quantity")
              .set(itemInCart.value["quantity"] + 1);
        } else {
          await itemRef.child("InCart").child(uid).child("state").set(true);
          await itemRef.child("InCart").child(uid).child("quantity").set(1);
        }
      });
    }
  });
  return pro;
}

void myCartStateMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  // if (action.runtimeType.toString() == (FirstLoadCartModelMyCartAction).toString()) {
  //   await _getDataMyCart(action.uid)
  //       .then((cartList) => store.dispatch(FirstLoadCartModelMyCartState(cartList)));
  // } else
  if (action.runtimeType.toString() == (RemoveFromCartMyCartAction).toString()) {
    await _removeFromCartHandle(action.listId, store.state.uid)
        .then((value) => store.dispatch(RemoveFromCartMyCartState(action.listId)));
  } else if (action.runtimeType.toString() == (HandleQuantityMyCartAction).toString()) {
    await _quantityHandle(action.uploadId, action.type, store.state.uid)
        .then((quantity) => store.dispatch(HandleQuantityMyCartState(action.uploadId, quantity)));
  } else if (action.runtimeType.toString() == (AddToCartMyCartAction).toString()) {
    await _addToCartHandle(action.uploadId, store.state.uid)
        .then((item) => store.dispatch(AddToCartMyCartState(item)));
  }
}
