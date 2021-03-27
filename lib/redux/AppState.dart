import 'package:flutter/cupertino.dart';
import 'package:flutter_food_app/redux/Home/HomeState.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartState.dart';

class AppState {
  String uid;
  HomeState homeState;
  MyCartState myCartState;

  AppState(
    this.uid, {
    this.homeState,
    this.myCartState,
  });

  AppState newState({HomeState homeState, MyCartState myCartState}) {
    return AppState(
      this.uid,
      homeState: homeState != null ? homeState : HomeState(),
      myCartState: myCartState != null ? myCartState : MyCartState(),
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
