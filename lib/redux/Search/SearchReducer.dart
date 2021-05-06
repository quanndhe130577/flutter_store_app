import 'package:flutter_food_app/Model/SearchEntity.dart';

import 'SearchActions.dart';
import 'SearchState.dart';

SearchState searchReducers(SearchState state, dynamic action) {
  if (action.runtimeType.toString() == (StartLoadingSearchState).toString()) {
    return state.newState(
      isLoading: true,
    );
  } else if (action.runtimeType.toString() == (LoadMoreDataSearchState).toString()) {
    List<SearchModel> dataList = []..addAll(state.dataList)..addAll(action.moreData);
    if (state.searchText.isEmpty) {
      return state.newState();
    }
    return state.newState(
      dataList: dataList,
      isLoading: false,
    );
  } else if (action.runtimeType.toString() == (LoadDataSearchState).toString()) {
    List<SearchModel> dataList = []..addAll(action.dataList);
    if (state.searchText.isEmpty) {
      return state.newState();
    }
    return state.newState(
      dataList: dataList,
      isLoading: false,
    );
  }
  return state;
}
