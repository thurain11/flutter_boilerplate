// import 'dart:async';
// import 'package:rxdart/rxdart.dart';
//
// import '../../core/network/dio_basenetwork.dart';
// import '../../core/ob/response_ob.dart';
// import '../../core/constants/app_constants.dart';
// import '../../core/services/service_locator.dart';
// import '../../core/socket/dart_pusher.dart';
//
//
//
// //final factories = <Type, Function>{ObClass: (int x) => ObClass.fromJson(x)};
//
// class ChatRefreshUiBloc extends DioBaseNetwork {
//   ChatRefreshUiBloc() {}
//
//   PublishSubject<ResponseOb> publishSubject = PublishSubject();
//
//   Stream<ResponseOb> listStream() => publishSubject.stream;
//
//   String nextPageUrl = "";
//
//   int deleteCount = 0;
//
//
//   Map<String, dynamic>? eventMap;
//   Timer? _debounceTyping;
//   ChatMessageData? eventChatMessageData;
//
//   void listenEvent() {
//     getIt<DartPusher>().messageSentStream().listen((event) {
//       Map<String, dynamic> listenMap = event as Map<String, dynamic>;
//
//       eventMap = listenMap;
//       if (listenMap['is_message'] == true) {
//         eventChatMessageData = ChatMessageData.fromJson(listenMap['messages'][0]);
//         addDataFromBloc(eventChatMessageData!, roomId: listenMap['room_id']);
//       } else if (listenMap['is_reply'] == true) {
//         eventChatMessageData = ChatMessageData.fromJson(listenMap['message']);
//         addDataFromBloc(eventChatMessageData!, roomId: listenMap['room_id']);
//       } else if (listenMap['is_edit'] == true) {
//         eventChatMessageData = ChatMessageData.fromJson(listenMap['message']);
//         editMessageEvent(eventChatMessageData!);
//       } else if (listenMap['is_delete'] == true) {
//         eventChatMessageData = ChatMessageData.fromJson(listenMap['message']);
//         editMessageEvent(eventChatMessageData!);
//       } else if (listenMap['is_seen'] == true) {}
//       else if (listenMap['is_optimizing'] == true) {
//         eventChatMessageData = ChatMessageData.fromJson(listenMap['message']);
//         editMessageEvent(eventChatMessageData!);
//
//       }
//     }).onDone(() {});
//
//     getIt<DartPusher>().chatListListenStream().listen((event) {
//       Map<String, dynamic> listenMap = event as Map<String, dynamic>;
//       eventMap = listenMap;
//       if (listenMap['is_message'] == true || listenMap['is_incoming_message']==true) {
//         eventChatMessageData = ChatMessageData.fromJson(listenMap['message']);
//         addDataFromBloc(eventChatMessageData!, roomId: listenMap['room']['id']);
//       }
//     }).onDone(() {});
//   }
//
//   void getData(String url,
//       {Map<String, dynamic>? map,
//       ReqType? requestType = ReqType.Get,
//       bool requestShowLoading = true,
//       bool? isCached}) async {
//     ResponseOb resp = ResponseOb(data: null, message: MsgState.loading);
//     if (requestShowLoading) {
//       publishSubject.sink.add(resp);
//     }
//     // if (map != null) {
//     //   map['delete_count'] = deleteCount;
//     // } else {
//     //   map = {};
//     //   map['delete_count'] = deleteCount;
//     // }
//
//     dioReq(requestType, url: BASE_URL + url, params: map, isCached: isCached,
//         callBack: (ResponseOb rv) {
//       deleteCount = 0;
//       if (rv.message == MsgState.data) {
//         if (rv.data["result"].toString() == "1") {
//           MessageOb flv = MessageOb.fromJson(rv.data);
//           nextPageUrl = flv.links!.next.toString();
//
//           resp.message = MsgState.data;
//           resp.pgState = PageState.first;
//           resp.data = flv;
//
//           publishSubject.sink.add(resp);
//         } else if (rv.data['result'].toString() == "0") {
//           resp.message = MsgState.more;
//           resp.data = rv.data;
//           publishSubject.sink.add(resp);
//         } else {
//           publishSubject.sink.add(rv);
//         }
//       } else {
//         publishSubject.sink.add(rv);
//       }
//     });
//   }
//
//   void getLoad(String url, Map<String, dynamic>? map,
//       {ReqType requestType = ReqType.Get, bool? isCached}) async {
//     ResponseOb resp = ResponseOb(data: null, message: MsgState.loading);
//     if (nextPageUrl != "null" && nextPageUrl != "") {
//       if (map != null) {
//         map['delete_count'] = deleteCount;
//       } else {
//         map = {};
//         map['delete_count'] = deleteCount;
//       }
//
//       dioReq(requestType, url: nextPageUrl, params: map, isCached: isCached,
//           callBack: (ResponseOb rv) {
//         deleteCount = 0;
//
//         if (rv.message == MsgState.data) {
//           if (rv.data["result"].toString() == "1") {
//             MessageOb flv = MessageOb.fromJson(rv.data);
//             nextPageUrl = flv.links!.next.toString();
//             resp.message = MsgState.data;
//             resp.pgState = PageState.other;
//             resp.data = flv;
//             publishSubject.sink.add(resp);
//           } else if (rv.data['result'].toString() == "0") {
//             resp.message = MsgState.more;
//             resp.data = rv.data;
//             publishSubject.sink.add(resp);
//           } else {
//             publishSubject.sink.add(rv);
//           }
//         } else {
//           publishSubject.sink.add(rv);
//         }
//       });
//     } else {
//       List<ChatMessageData> list = [];
//       resp.message = MsgState.data;
//       resp.data = list;
//       resp.pgState = PageState.no_more;
//       publishSubject.sink.add(resp);
//     }
//   }
//
//   void addDataFromBloc(ChatMessageData myData, {String roomId = ""}) {
//     ResponseOb resp = ResponseOb(
//         data: {'data': myData, 'room_id': roomId}, mode: RefreshUIMode.add, message: MsgState.data);
//     publishSubject.sink.add(resp);
//   }
//
//   void addLocalStorage(ChatMessageData myData, {String roomId = ""}) {
//
//     ResponseOb resp = ResponseOb(
//         data: {'data': myData, 'room_id': roomId}, mode: RefreshUIMode.addLocalStorage, message: MsgState.data);
//     publishSubject.sink.add(resp);
//   }
//
//   void editLocalStorage(ChatMessageData data, String tempId) {
//     ResponseOb resp =
//     ResponseOb(data: {"data": data}, mode: RefreshUIMode.editLocalStorage, message: MsgState.data, tempId: tempId);
//     publishSubject.sink.add(resp);
//   }
//
//   // void replaceLocalStorage(ChatMessageData myData, int index) {
//   //   ResponseOb resp = ResponseOb(
//   //       data: {'data': myData, 'room_id': roomId}, mode: RefreshUIMode.addLocalStorage, message: MsgState.data);
//   //   publishSubject.sink.add(resp);
//   // }
//
//   void editMessageEvent(ChatMessageData data) {
//     ResponseOb resp = ResponseOb(data: data, mode: RefreshUIMode.edit, message: MsgState.data);
//     publishSubject.sink.add(resp);
//   }
//
//   void deleteData(ChatMessageData data) {
//     ResponseOb resp = ResponseOb(data: data, mode: RefreshUIMode.delete, message: MsgState.data);
//     publishSubject.sink.add(resp);
//   }
//
//   void replaceData(ChatMessageData data, int index) {
//     ResponseOb resp =
//         ResponseOb(data: {"data": data, "index": index}, mode: RefreshUIMode.replace, message: MsgState.data);
//     publishSubject.sink.add(resp);
//   }
//
//   void replaceChatInfoData({required ChatMessageData data, required String id}){
//     ResponseOb resp =
//     ResponseOb(data: {"data": data, "id": id}, mode: RefreshUIMode.replaceChatInfoData, message: MsgState.data);
//     publishSubject.sink.add(resp);
//   }
//
//   void replaceLocalData(ChatMessageData data, String tempId) {
//     ResponseOb resp =
//     ResponseOb(data: {"data": data}, mode: RefreshUIMode.replaceLocalStorage, message: MsgState.data, tempId: tempId);
//     publishSubject.sink.add(resp);
//   }
//
//   void replaceEditData(ChatMessageData data, String tempId) {
//     ResponseOb resp =
//     ResponseOb(data: {"data": data}, mode: RefreshUIMode.replaceEditData, message: MsgState.data, tempId: tempId);
//     publishSubject.sink.add(resp);
//   }
//
//   void replaceFailedData(String tempId) {
//     ResponseOb resp =
//     ResponseOb(mode: RefreshUIMode.replaceFailedData, message: MsgState.data, tempId: tempId);
//     publishSubject.sink.add(resp);
//   }
//
//   void dispose() {
//     publishSubject.close();
//   }
// }
