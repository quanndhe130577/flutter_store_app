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
      dataList: state.dataList,
      isLoading: false,
    );
  } else if (action.runtimeType.toString() == (StartLoadMoreHomeState).toString()) {
    return state.newState(isLoading: true);
  } else if (action.runtimeType.toString() == (LoadMoreDataHomeState).toString()) {
    List<HomeModel> dataList = []..addAll(state.dataList)..addAll(action.moreData);

    return state.newState(
      dataList: dataList,
      isLoading: false,      //isLoadingMore: false,
    );
  }
  return state;
}
