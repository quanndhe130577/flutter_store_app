import 'package:flutter_food_app/Model/SearchEntity.dart';

import 'SearchActions.dart';
import 'SearchState.dart';

SearchState searchReducers(SearchState state, dynamic action) {
  if (action.runtimeType.toString() == (StartLoadingSearchState).toString()) {
    return state.newState(
      isLoading: true,
      searchText: action.keyword,
    );
  } else if (action.runtimeType.toString() == (LoadMoreDataSearchState).toString()) {
    List<SearchModel> dataList = []..addAll(state.searchList)..addAll(action.moreData);
    return state.newState(
      searchList: dataList,
      isLoading: false,
    );
  } else if (action.runtimeType.toString() == (LoadDataSearchState).toString()) {
    List<SearchModel> dataList = []..addAll(action.dataList);
    return state.newState(
      searchList: dataList,
      isLoading: false,
    );
  } else if (action.runtimeType.toString() == (ClearDataSearchState).toString()) {
    return SearchState();
  }
  return state;
}
