import 'package:flutter_food_app/Model/SearchEntity.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:redux/redux.dart';
import 'package:firebase_database/firebase_database.dart';

import 'SearchActions.dart';

final int stepLoadMore = 2;

Future<List<SearchModel>> _loadMoreData(int currentNumber, String keyword) async {
  List<SearchModel> dataList = [];

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

      SearchModel data = new SearchModel(
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

Future<List<SearchModel>> _loadFirstData(String keyword) async {
  List<SearchModel> dataList = [];
  if (keyword.isEmpty) {
    return dataList;
  }

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
        if (!values[key]["name"].toString().toLowerCase().contains(keyword.toLowerCase())) {
          continue;
        }
      }
      SearchModel data = new SearchModel(
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

void searchStateMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);
  if (action.runtimeType.toString() == (LoadMoreDataSearchAction).toString()) {
    store.dispatch(StartLoadingSearchState(store.state.searchState.searchText));
    await _loadMoreData(store.state.searchState.searchList.length, store.state.searchState.searchText)
        .then((moreData) => store.dispatch(LoadMoreDataSearchState(moreData)));
  } else if (action.runtimeType.toString() == (FirstLoadSearchAction).toString()) {
    store.dispatch(StartLoadingSearchState(action.keyword));
    await _loadFirstData(action.keyword).then((dataList) => store.dispatch(LoadDataSearchState(dataList)));
  } else if (action.runtimeType.toString() == (ClearDataSearchAction).toString()) {
    store.dispatch(ClearDataSearchState());
  }
}
