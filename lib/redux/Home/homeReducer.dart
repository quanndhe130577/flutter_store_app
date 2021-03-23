import 'package:flutter_food_app/Model/HomeEntity.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/actions.dart';

AppState homeReducers(AppState state, dynamic action) {
  if (action is StartLoadingFirstState) {
    return AppState(
      dataList: state.dataList,
      searchList: state.searchList,
      isLoading: true,
    );
  } else if (action is FirstLoadHomeModelState) {
    return AppState(
      dataList: action.dataList,
      searchList: action.dataList,
      isLoading: false,
    );
  } else if (action is StartLoadMoreState) {
    return AppState(
      dataList: state.dataList,
      searchList: state.searchList,
      isLoadingMore: true,
      searchText: state.searchText,
    );
  } else if (action is LoadMoreDataState) {
    List<HomeModel> searchList = []
      ..addAll(state.searchList)
      ..addAll(action.moreData);
    List<HomeModel> dataList = []..addAll(state.dataList);
    if (state.searchText.isEmpty) {
      dataList.addAll(action.moreData);
    }
    return AppState(
      dataList: dataList,
      searchList: searchList,
      isLoadingMore: false,
      searchText: state.searchText,
    );
  } else if (action is StartLoadingSearchState) {
    return AppState(
      dataList: state.dataList,
      searchList: state.searchList,
      isLoading: true,
    );
  } else if (action is LoadingSearchState) {
    return AppState(
      dataList: state.dataList,
      searchText: action.keyword,
      searchList: action.searchList,
      isLoading: false,
    );
  } else if (action is RemoveSearchState) {
    return AppState(
      dataList: state.dataList,
      searchList: state.dataList,
      searchText: "",
    );
  }
  return state;
}
