import 'package:flutter_food_app/Model/HomeEntity.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:redux/redux.dart';
import 'package:firebase_database/firebase_database.dart';

import 'HomeActions.dart';

final int stepLoadMore = 2;

Future<List<HomeModel>> _loadMoreData(int currentNumber, String keyword) async {
  List<HomeModel> dataList = [];

  DatabaseReference reference = FirebaseDatabase.instance.reference().child("Data");
  await reference.once().then((DataSnapshot dataSnapShot) {
    var keys = dataSnapShot.value.keys;
    var values = dataSnapShot.value;

    var count = 0;
    for (var key in keys) {
      if (keyword.isNotEmpty) {
        if (!values[key]["name"].toString().contains(keyword)) {
          continue;
        }
      }

      if (count < currentNumber) {
        count++;
        continue;
      } else if (count >= currentNumber + stepLoadMore) {
        break;
      }

      HomeModel data = new HomeModel(
        key,
        values[key]["imgUrl"],
        values[key]["name"],
        double.parse(values[key]["price"].toString()),
        values[key]["material"],
      );

      dataList.add(data);

      count++;
    }
  });

  return dataList;
}

Future<List<HomeModel>> _loadFirstData(String keyword) async {
  List<HomeModel> dataList = [];

  DatabaseReference reference = FirebaseDatabase.instance.reference().child("Data");
  await reference.once().then((DataSnapshot dataSnapShot) {
    var keys = dataSnapShot.value.keys;
    var values = dataSnapShot.value;

    var count = 0;
    for (var key in keys) {
      if (count >= 5) {
        break;
      }
      if (keyword.isNotEmpty) {
        if (!values[key]["name"].toString().contains(keyword)) {
          continue;
        }
      }
      HomeModel data = new HomeModel(
        key,
        values[key]["imgUrl"],
        values[key]["name"],
        double.parse(values[key]["price"].toString()),
        values[key]["material"],
      );
      dataList.add(data);
      count++;
    }
  });

  return dataList;
}

Future<List<HomeModel>> _refreshData(int number, String keyword) async {
  List<HomeModel> dataList = [];

  DatabaseReference reference = FirebaseDatabase.instance.reference().child("Data");
  await reference.once().then((DataSnapshot dataSnapShot) async {
    //dataList.clear();
    var keys = dataSnapShot.value.keys;
    var values = dataSnapShot.value;

    var count = 0;
    for (var key in keys) {
      if (keyword.isNotEmpty) {
        if (!values[key]["name"].toString().contains(keyword)) {
          continue;
        }
      }
      if (count >= number) {
        break;
      }
      HomeModel data = new HomeModel(
        key,
        values[key]["imgUrl"],
        values[key]["name"],
        double.parse(values[key]["price"].toString()),
        values[key]["material"],
      );

      dataList.add(data);

      count++;
    }
  });

  return dataList;
}

void homeStateMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);
  if (action.runtimeType.toString() == (LoadMoreDataHomeAction).toString()) {
    store.dispatch(StartLoadMoreHomeState());
    await _loadMoreData(store.state.homeState.searchList.length, store.state.homeState.searchText)
        .then((moreData) => store.dispatch(LoadMoreDataHomeState(moreData)));
  } else if (action.runtimeType.toString() == (SearchHomeAction).toString()) {
    store.dispatch(StartLoadingSearchHomeState());
    await _loadFirstData(action.keyword)
        .then((searchList) => store.dispatch(LoadingSearchHomeState(action.keyword, searchList)));
  } else if (action.runtimeType.toString() == (RefreshDataHomeAction).toString()) {
    store.dispatch(StartRefreshDataHomeState());
    await _refreshData(store.state.homeState.searchList.length, store.state.homeState.searchText)
        .then((dataList) => store.dispatch(RefreshDataHomeState(dataList)));
  }
}
