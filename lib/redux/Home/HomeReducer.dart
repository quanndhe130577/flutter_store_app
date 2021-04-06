import 'package:flutter_food_app/Model/HomeEntity.dart';
import 'package:flutter_food_app/redux/Home/HomeState.dart';
import 'HomeActions.dart';

HomeState homeReducers(HomeState state, dynamic action) {
  if (action.runtimeType.toString() == (StartRefreshDataHomeState).toString()) {
    return state.newState(
      isLoading: true,
    );
  } else if (action.runtimeType.toString() == (RefreshDataHomeState).toString()) {
    return state.newState(
      dataList: state.searchText.isEmpty ? action.dataList : state.dataList,
      searchList: action.dataList,
      isLoading: false,
    );
  } else if (action.runtimeType.toString() == (StartLoadMoreHomeState).toString()) {
    return state.newState(
      //isLoadingMore: true,
    );
  } else if (action.runtimeType.toString() == (LoadMoreDataHomeState).toString()) {
    List<HomeModel> searchList = []..addAll(state.searchList)..addAll(action.moreData);
    List<HomeModel> dataList = []..addAll(state.dataList);
    if (state.searchText.isEmpty) {
      dataList.addAll(action.moreData);
    }
    return state.newState(
      dataList: dataList,
      searchList: searchList,
      //isLoadingMore: false,
    );
  } else if (action.runtimeType.toString() == (StartLoadingSearchHomeState).toString()) {
    return state.newState(
      isLoading: true,
      //searchList: [],
    );
  } else if (action.runtimeType.toString() == (LoadingSearchHomeState).toString()) {
    return state.newState(
      searchText: action.keyword,
      searchList: action.searchList,
      isLoading: false,
    );
  } else if (action.runtimeType.toString() == (RemoveSearchHomeState).toString()) {
    return state.newState(searchText: "", searchList: state.dataList);
  }
  return state;
}
