import 'package:rxdart/rxdart.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/dio_basenetwork.dart';
import '../../core/ob/response_ob.dart';
import '../factory/factory_builder.dart';



class SingleUiBloc<T> extends DioBaseNetwork {
  String url;
  bool isBaseUrl;
  SingleUiBloc(this.url, {this.isBaseUrl = true});
  PublishSubject<ResponseOb> publishSubject = PublishSubject();
  Stream<ResponseOb> shopStream() => publishSubject.stream;

  void getData(
      {Map<String, dynamic>? map,
        ReqType? requestType = ReqType.Get,
        bool requestShowLoading = true,
        bool? isCached}) async {
    ResponseOb resp = ResponseOb(data: null, message: MsgState.loading);
    if (requestShowLoading) {
      publishSubject.sink.add(resp);
    }

    dioReq(requestType, url: isBaseUrl ? BASE_URL + url : url, params: map, isCached: isCached, callBack: (ResponseOb rv) {

      if (rv.message == MsgState.data) {

        if (rv.data["result"].toString() == "1") {
          T? ob = objectFactories[T]!(rv.data); //
          resp.message = MsgState.data;
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

  void dispose() {
    publishSubject.close();
  }
}
