import 'package:flutter_food_app/redux/AppActions.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/Home/HomeReducer.dart';
import 'package:flutter_food_app/redux/Home/HomeState.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartReducer.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartState.dart';
import 'package:flutter_food_app/redux/MyFavorite/MyFavoriteReducer.dart';
import 'package:flutter_food_app/redux/Search/SearchReducer.dart';

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
      myFavState: state.myFavState.newState(
        favList: action.favList,
      ),
    );
  } else if (action.runtimeType.toString() == (StartInitAppState).toString()) {
    return state.newState(
      homeState: state.homeState.newState(
        isLoading: true,
      ),
      myCartState: state.myCartState.newState(),
      myFavState: state.myFavState.newState(),
    );
  } else if (action.runtimeType.toString() == (ClearStateAppState).toString()) {
    return state.newState(
      homeState: new HomeState(),
      myCartState: new MyCartState(),
    );
  } else if (action.runtimeType.toString().endsWith("HomeState")) {
    homeReducers(state.homeState, action);
  } else if (action.runtimeType.toString().endsWith("MyCartState")) {
    myCartReducers(state.myCartState, action);
  } else if (action.runtimeType.toString().endsWith("SearchState")) {
    searchReducers(state.searchState, action);
  } else if (action.runtimeType.toString().endsWith("MyFavState")) {
    myFavReducers(state.myFavState, action);
  }
  return state;
  /*return state.newState(
    homeState: homeReducers(
      state.homeState,
      action,
    ),
    myCartState: myCartReducers(
      state.myCartState,
      action,
    ),
    myFavState: myFavReducers(
      state.myFavState,
      action,
    ),
    searchState: searchReducers(
      state.searchState,
      action,
    ),
  );*/
}
