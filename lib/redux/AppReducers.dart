import 'package:flutter_food_app/redux/AppActions.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/Home/HomeReducer.dart';
import 'package:flutter_food_app/redux/Home/HomeState.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartReducer.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartState.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action.runtimeType.toString() == (InitAppState).toString()) {
    return state.newState(
      homeState: state.homeState.newState(
        dataList: action.dataList,
        searchList: action.dataList,
        isLoading: false,
      ),
      myCartState: state.myCartState.newState(
        cartList: action.cartList,
      ),
    );
  } else if (action.runtimeType.toString() == (StartInitAppState).toString()) {
    return state.newState(
      homeState: state.homeState.newState(
        isLoading: true,
      ),
    );
  } else if (action.runtimeType.toString() == (ClearStateAppState).toString()) {
    return state.newState(
      homeState: new HomeState(),
      myCartState: new MyCartState(),
    );
  }
  return state.newState(
    homeState: homeReducers(
      state.homeState,
      action,
    ),
    myCartState: myCartReducers(
      state.myCartState,
      action,
    ),
  );
}
