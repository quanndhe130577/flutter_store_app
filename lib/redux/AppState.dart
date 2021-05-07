import 'package:flutter_food_app/redux/Home/HomeState.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartState.dart';
import 'package:flutter_food_app/redux/MyFavorite/MyFavoriteState.dart';
import 'package:flutter_food_app/redux/Search/SearchState.dart';

class AppState {
  String uid;
  HomeState homeState;
  MyCartState myCartState;
  MyFavState myFavState;
  SearchState searchState;

  AppState(
    this.uid, {
    this.homeState,
    this.myCartState,
    this.myFavState,
    this.searchState,
  });

  AppState newState({HomeState homeState, MyCartState myCartState, MyFavState myFavState, SearchState searchState}) {
    return AppState(
      this.uid,
      homeState: homeState != null ? homeState : this.homeState,
      myCartState: myCartState != null ? myCartState : this.myCartState,
      myFavState: myFavState != null ? myFavState : this.myFavState,
      searchState: searchState != null ? searchState : this.searchState,
    );
  }

// AppState newHomeState({HomeState homeState}) {
//   return AppState(
//     homeState: homeState != null ? homeState : HomeState(),
//   );
// }
//
// AppState newMyCartState({MyCartState myCartState}) {
//   return AppState(
//     myCartState: myCartState != null ? myCartState : MyCartState(),
//   );
// }
}
