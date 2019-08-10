

import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skyroad/common/dao/user_dao.dart';
import 'package:skyroad/common/model/user_model.dart';
import 'package:skyroad/common/redux/middleware/epic.dart';
import 'package:skyroad/common/redux/middleware/epic_store.dart';
/**
 *
 * Project Name: skyRoad
 * Package Name: common.redux
 * File Name: user_redux
 * USER: Aige
 * Create Time: 2019-08-08-18:17
 *
 */



import 'gosund_state.dart';

final UserReducer = combineReducers<UserInfo>([
  TypedReducer<UserInfo, UpdateUserAction>(_updateUserInfo),
]);

UserInfo _updateUserInfo(userInfo, action) {
  final userInfo = action.userInfo;
  return userInfo;
}

class UpdateUserAction {
  final UserInfo userInfo;

  UpdateUserAction(this.userInfo);
}

class UserInfoMiddleware implements MiddlewareClass<GosundState> {
  @override
  void call(Store store, action, NextDispatcher next) {
    if (action is UpdateUserAction) {
      print("*********** UserInfoMiddleware *********** ");
    }
    next(action);
  }
}

class FetchUserAction {}

class UserInfoEpic implements EpicClass<GosundState> {
  @override
  Stream call(Stream actions, EpicStore<GosundState> store) {
    // TODO: implement call
    return Observable(actions)
        // to UpdateUserAction actions
        .ofType(TypeToken<FetchUserAction>())
        // Don't start  until the 10ms
        .debounceTime(Duration(milliseconds: 10))
        .switchMap((action) => _loadUserInfo());
  }

  // Use the async* function to make easier
  Stream<dynamic> _loadUserInfo() async* {
    print("*********** userInfoEpic _loadUserInfo ***********");
    var res = await UserDao.getUserInfo();
    yield UpdateUserAction(res.data);
  }
}
