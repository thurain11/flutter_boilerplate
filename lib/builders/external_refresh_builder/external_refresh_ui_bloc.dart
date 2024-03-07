import 'package:rxdart/rxdart.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/dio_basenetwork.dart';
import '../../core/ob/response_ob.dart';
import '../factory/factory_builder.dart';
//final factories = <Type, Function>{ObClass: (int x) => ObClass.fromJson(x)};

class DataRefreshUiBloc<T> extends DioBaseNetwork {
  PublishSubject<ResponseOb> publishSubject = PublishSubject();
  Stream<ResponseOb> shopStream() => publishSubject.stream;

  int page = 1;

  void getData(String url, {Map<String, dynamic>? map, ReqType? requestType = ReqType.Get, bool requestShowLoading = true}) async {
    page = 1;
    ResponseOb resp = ResponseOb(data: null, message: MsgState.loading);
    if (requestShowLoading) {
      publishSubject.sink.add(resp);
    }
    if (map != null) {
      map['page'] = page;
    } else {
      map = {"page": page};
    }

    dioReq(requestType, url: BASE_URL + url, params: map, callBack: (ResponseOb rv) {
      if (rv.message == MsgState.data) {
        if (rv.data["result"].toString() == "1") {
          T? ob = objectFactories[T]!(rv.data);
          resp.message = MsgState.data;
          resp.pgState = PageState.first;
          resp.data = ob;
          publishSubject.sink.add(resp);
        } else if (rv.data['result'].toString() == "0") {
          resp.message = MsgState.more;
          resp.data = rv.data;
          publishSubject.sink.add(resp);
        } else {
          publishSubject.sink.add(rv);
        }
      } else {
        publishSubject.sink.add(rv);
      }
    });
  }

  void getLoad(String url, {Map<String, dynamic>? map, ReqType requestType = ReqType.Get,}) async {
    page++;
    ResponseOb resp = ResponseOb(data: null, message: MsgState.loading);
    if (map != null) {
      map['page'] = page;
    } else {
      map = {"page": page};
    }

    dioReq(requestType, url: BASE_URL + url, params: map, callBack: (ResponseOb rv) {
      if (rv.message == MsgState.data) {
        if (rv.data["result"].toString() == "1") {
          Map<String, dynamic> map = rv.data;
          List list = map['data'];
          if (list.length > 0) {
            T? ob = objectFactories[T]!(rv.data);
            resp.message = MsgState.data;
            resp.pgState = PageState.other;
            resp.data = ob;
            publishSubject.sink.add(resp);
          } else {
            T? ob = objectFactories[T]!(rv.data);
            resp.message = MsgState.data;
            resp.data = ob;
            resp.pgState = PageState.no_more;
            publishSubject.sink.add(resp);
          }
        } else if (rv.data['result'].toString() == "0") {
          resp.message = MsgState.more;
          resp.data = rv.data;
          publishSubject.sink.add(resp);
        } else {
          publishSubject.sink.add(rv);
        }
      } else {
        publishSubject.sink.add(rv);
      }
    });

  }

  void deleteData(T data) {
    ResponseOb resp = ResponseOb(data: data, mode: RefreshUIMode.delete, message: MsgState.data);
    publishSubject.sink.add(resp);
  }

  void replaceData(T data, int index) {
    ResponseOb resp = ResponseOb(data: {"data": data, "index": index}, mode: RefreshUIMode.replace, message: MsgState.data);
    publishSubject.sink.add(resp);
  }

  void dispose() {
    publishSubject.close();
  }
}
