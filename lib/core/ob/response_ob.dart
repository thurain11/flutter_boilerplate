
import 'package:flutter_setup/core/ob/pin_ob.dart';

class ResponseOb {
  dynamic data;
  Map<String, dynamic>? map;
  MsgState? message;
  ErrState? errState;
  PageState? pgState;
  String? pageName;
  RefreshUIMode mode;
  Meta? meta;
  String? tempId;
  int? success;

  ResponseOb({this.data, this.message, this.pageName, this.pgState, this.errState, this.mode = RefreshUIMode.none, this.meta, this.map,
    this.tempId='', this.success});
}


enum MsgState { error, loading, data, more, server }
enum ErrState {
  no_internet,
  connection_timeout,
  not_found,
  server_error,
  too_many_request,
  unknown_err,
  validate_err,
  not_supported,
  no_login, //401
  server_maintain
}

enum PageState { first, other, no_more }

enum RefreshUIMode {
  replace,
  edit,
  delete,
  none,
  status,
  add,
  addLocalStorage,
  replaceLocalStorage,
  replaceChatInfoData,
  editLocalStorage,
  replaceEditData,
  replaceFailedData
}
