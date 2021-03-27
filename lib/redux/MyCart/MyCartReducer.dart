import 'package:flutter_food_app/redux/MyCart/MyCartState.dart';

import 'MyCartActions.dart';

MyCartState myCartReducers(MyCartState state, dynamic action) {
  if (action.runtimeType.toString() ==
      (FirstLoadCartModelMyCartState).toString()) {
    return state.newState(
      cartList: action.cartList,
    );
  }
  return state;
}
