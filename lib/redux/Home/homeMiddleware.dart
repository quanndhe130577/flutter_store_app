import 'package:flutter_food_app/Model/HomeEntity.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:redux/redux.dart';
import 'package:firebase_database/firebase_database.dart';

import '../actions.dart';

Future<List<HomeModel>> loadMoreData(int currentNumber, String keyword) async {
  List<HomeModel> dataList = [];

  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child("Data");
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
      } else if (count >= currentNumber + 2) {
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

Future<List<HomeModel>> loadFirstData() async {
  List<HomeModel> dataList = [];

  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child("Data");
  await reference.once().then((DataSnapshot dataSnapShot) async {
    //dataList.clear();
    var keys = dataSnapShot.value.keys;
    var values = dataSnapShot.value;

    var count = 0;
    for (var key in keys) {
      if (count >= 5) {
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

Future<List<HomeModel>> loadFirstSearchList(String keyword) async {
  List<HomeModel> dataList = [];

  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child("Data");
  await reference.once().then((DataSnapshot dataSnapShot) {
    var keys = dataSnapShot.value.keys;
    var values = dataSnapShot.value;

    var count = 0;
    for (var key in keys) {
      if (count >= 5) {
        break;
      }
      if (values[key]["name"].toString().contains(keyword)) {
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
    }
  });

  return dataList;
}

Future<List<HomeModel>> refreshData(int number, String keyword) async {
  List<HomeModel> dataList = [];

  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child("Data");
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

void appStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  if (action is LoadMoreDataAction) {
    store.dispatch(StartLoadMoreState());
    await loadMoreData(store.state.dataList.length, store.state.searchText)
        .then((moreData) => store.dispatch(LoadMoreDataState(moreData)));
  } else if (action is FirstLoadHomeModelAction) {
    store.dispatch(StartLoadingFirstState());
    await loadFirstData()
        .then((dataList) => store.dispatch(FirstLoadHomeModelState(dataList)));
  } else if (action is SearchAction) {
    store.dispatch(StartLoadingSearchState());
    await loadFirstSearchList(action.keyword).then((searchList) =>
        store.dispatch(LoadingSearchState(action.keyword, searchList)));
  } else if (action is RefreshDataAction) {
    store.dispatch(StartLoadingFirstState());
    await refreshData(store.state.searchList.length, store.state.searchText)
        .then((dataList) => store.dispatch(FirstLoadHomeModelState(dataList)));
  }
}
