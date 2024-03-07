import 'package:rxdart/rxdart.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/dio_basenetwork.dart';
import '../../core/ob/pin_ob.dart';
import '../../core/ob/response_ob.dart';


//final factories = <Type, Function>{ObClass: (int x) => ObClass.fromJson(x)};

class RefreshUiBloc<T extends Object?> extends DioBaseNetwork {
  PublishSubject<ResponseOb> publishSubject = PublishSubject();

  Stream<ResponseOb> shopStream() => publishSubject.stream;

  String nextPageUrl = "";

  void getData(String url,
      {Map<String, dynamic>? map,
        ReqType? requestType = ReqType.Get,
      bool requestShowLoading = true,
      bool? isCached,
      bool isBaseUrl = true}) async {
    ResponseOb resp = ResponseOb(data: null, message: MsgState.loading);
    // publishSubject.sink.add(resp);
    if (requestShowLoading) {
      publishSubject.sink.add(resp);
    }

    dioReq(requestType, url: isBaseUrl ? BASE_URL + url : url, params: map, isCached: isCached,
        callBack: (ResponseOb rv) {

      if (rv.message == MsgState.data) {
        if (rv.data["result"].toString() == "1") {
          PnObClass<T> flv = PnObClass.fromJson(rv.data);
          nextPageUrl = flv.links!.next.toString();
          resp.message = MsgState.data;
          resp.pgState = PageState.first;
          resp.meta = flv.meta;
          resp.data = flv.data;
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

  void getLoad(String? url, Map<String, dynamic>? map,
      {ReqType requestType = ReqType.Get, bool? isCached}) async {
    ResponseOb resp = ResponseOb(data: null, message: MsgState.loading);
    if (nextPageUrl != "null" && nextPageUrl != "") {
      dioReq(requestType, url: nextPageUrl, params: map, isCached: isCached, callBack: (ResponseOb rv) {

        if (rv.message == MsgState.data) {
          if (rv.data["result"].toString() == "1") {
            PnObClass<T> flv = PnObClass.fromJson(rv.data);
            nextPageUrl = flv.links!.next.toString();
            resp.message = MsgState.data;
            resp.pgState = PageState.other;
            resp.data = flv.data;
            resp.meta = flv.meta;
            // resp.data = flv;
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
    } else {
      List<T> l = [];
      resp.message = MsgState.data;
      resp.data = l;
      resp.pgState = PageState.no_more;
      publishSubject.sink.add(resp);
    }
  }

  void dispose() {
    publishSubject.close();
  }

  void replaceChatInfoData({required String id}){
    ResponseOb resp =
    ResponseOb(data: {"id": id}, mode: RefreshUIMode.replaceChatInfoData, message: MsgState.data);
    publishSubject.sink.add(resp);
  }
}
