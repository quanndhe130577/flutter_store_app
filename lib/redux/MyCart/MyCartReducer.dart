import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartState.dart';

import 'MyCartActions.dart';

MyCartState myCartReducers(MyCartState state, dynamic action) {
  if (action.runtimeType.toString() == (RemoveFromCartMyCartState).toString()) {
    List<CartModel> list = []..addAll(state.cartList);
    list.removeWhere(
        (element) => action.listId.any((subElement) => subElement == element.uploadId));
    return state.newState(
      cartList: list,
    );
  } else if (action.runtimeType.toString() == (HandleQuantityMyCartState).toString()) {
    List<CartModel> list = []..addAll(state.cartList);
    list.forEach((element) {
      if (element.uploadId == action.uploadId) {
        element.quantity = action.quantity;
      }
    });
    return state.newState(
      cartList: list,
    );
  } else if (action.runtimeType.toString() == (AddToCartMyCartState).toString()) {
    List<CartModel> list = []..addAll(state.cartList);
    if (list.any((element) => element.uploadId == action.item.uploadId)) {
      list.forEach((element) {
        if (element.uploadId == action.item.uploadId) {
          element.quantity = action.item.quantity;
        }
      });
    } else {
      list.add(action.item);
    }
    return state.newState(
      cartList: list,
    );
  }
  return state;
}
