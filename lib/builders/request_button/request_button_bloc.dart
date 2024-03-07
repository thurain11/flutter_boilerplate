import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/dio_basenetwork.dart';
import '../../core/ob/response_ob.dart';
import '../../core/utils/logger.dart';

class RequestButtonBloc extends DioBaseNetwork {
  PublishSubject<ResponseOb> requestButtonController = PublishSubject();
  Stream<ResponseOb> getRequestStream() => requestButtonController.stream;

  postData(url,
      {
        FormData? fd,
        Map<String, dynamic>? map,
        ReqType requestType = ReqType.Post,

      bool requestShowLoading = true,
      bool? isBaseUrl,
        String? tempId = '',
      }) async {
    ResponseOb resp = ResponseOb(data: null, message: MsgState.loading);
    if (requestShowLoading) {
      requestButtonController.sink.add(resp);
    }
    dioReq(requestType, url:  BASE_URL + url , params: map, fd: fd,
        callBack: (ResponseOb rv) {

      if (rv.message == MsgState.data) {
        if (rv.data["result"].toString() == "1") {

          resp.message = MsgState.data;
          resp.data = rv.data;
          resp.tempId=tempId;
          requestButtonController.sink.add(resp);
        } else if (rv.data['result'].toString() == "0") {
          resp.message = MsgState.more;
          resp.data = rv.data; //map['message'].toString();
          requestButtonController.sink.add(resp);
        } else {
          requestButtonController.sink.add(rv);
        }
      } else {
        requestButtonController.sink.add(rv);

      }
    }).catchError((e) {
      eLog("Java -> $e");
    });
  }

  void disponse() {
    requestButtonController.close();
  }
}

//  url: isBaseUrl == true ? BASE_URL + url : url,
