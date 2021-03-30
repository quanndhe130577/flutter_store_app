import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartState.dart';

import 'MyCartActions.dart';

MyCartState myCartReducers(MyCartState state, dynamic action) {
  if (action.runtimeType.toString() == (FirstLoadCartModelMyCartState).toString()) {
    return state.newState(
      cartList: action.cartList,
    );
  } else if (action.runtimeType.toString() == (RemoveFromCartMyCartState).toString()) {
    List<CartModel> list = []..addAll(state.cartList);
    list.removeWhere((element) => element.uploadId == action.productId);
    return state.newState(
      cartList: list,
    );
  } else if (action.runtimeType.toString() == (HandleQuantityCartState).toString()) {
    List<CartModel> list = []..addAll(state.cartList);
    list.forEach((element) {
      if (element.uploadId == action.uploadId) {
        if (action.type == 0) {
          element.quantity++;
        } else if (action.type == 1 && element.quantity > 1) {
          element.quantity--;
        }
      }
    });
    return state.newState(
      cartList: list,
    );
  }
  return state;
}
