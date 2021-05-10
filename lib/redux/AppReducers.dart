import 'package:flutter_food_app/redux/AppActions.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/Home/HomeReducer.dart';
import 'package:flutter_food_app/redux/Home/HomeState.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartReducer.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartState.dart';
import 'package:flutter_food_app/redux/MyFavorite/MyFavoriteReducer.dart';
import 'package:flutter_food_app/redux/MyFavorite/MyFavoriteState.dart';
import 'package:flutter_food_app/redux/Search/SearchReducer.dart';
import 'package:flutter_food_app/redux/Search/SearchState.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action.runtimeType.toString() == (InitAppState).toString()) {
    return state.newState(
      isInitLoad: false,
      homeState: state.homeState.newState(
        dataList: action.dataList,
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
      isInitLoad: true,
      homeState: new HomeState(),
      myCartState: new MyCartState(),
      myFavState: new MyFavState(),
      searchState: new SearchState(),
    );
  } else if (action.runtimeType.toString() == (ClearStateAppState).toString()) {
    return state.newState(
      isInitLoad: false,
      homeState: new HomeState(),
      myCartState: new MyCartState(),
      myFavState: new MyFavState(),
    );
  } else if (action.runtimeType.toString().endsWith("HomeState")) {
    return state.newState(homeState: homeReducers(state.homeState, action));
  } else if (action.runtimeType.toString().endsWith("MyCartState")) {
    return state.newState(myCartState: myCartReducers(state.myCartState, action));
  } else if (action.runtimeType.toString().endsWith("SearchState")) {
    return state.newState(searchState: searchReducers(state.searchState, action));
  } else if (action.runtimeType.toString().endsWith("MyFavState")) {
    return state.newState(myFavState: myFavReducers(state.myFavState, action));
  }
  return state;
  // return state.newState(
  //   homeState: homeReducers(
  //     state.homeState,
  //     action,
  //   ),
  //   myCartState: myCartReducers(
  //     state.myCartState,
  //     action,
  //   ),
  //   myFavState: myFavReducers(
  //     state.myFavState,
  //     action,
  //   ),
  //   searchState: searchReducers(
  //     state.searchState,
  //     action,
  //   ),
  // );
}
