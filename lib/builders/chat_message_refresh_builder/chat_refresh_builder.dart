// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:star_fish/builder/factory_builder.dart';
// import 'package:star_fish/builder/my_scaffold_builder/my_scaffold_builder.dart';
// import 'package:star_fish/builder/single_ui_builder/single_ui_builder.dart';
// import 'package:star_fish/globals.dart';
// import 'package:star_fish/view/page/apex_setting/service_request_page.dart';
// import 'package:star_fish/view/page/chat/page/bloc/delete_button_bloc.dart';
// import 'package:star_fish/view/page/chat/page/dart_pusher_setup/dart_pusher.dart';
// import 'package:star_fish/view/page/chat/page/room/ob/chat_message_list_ob.dart';
// import 'package:star_fish/view/widgets/err_state_widget/connection_timeout_widget.dart';
// import 'package:star_fish/view/widgets/err_state_widget/no_internet_widget.dart';
// import 'package:star_fish/view/widgets/err_state_widget/not_found_widget.dart';
// import 'package:star_fish/view/widgets/err_state_widget/server_err_widget.dart';
// import 'package:star_fish/view/widgets/err_state_widget/too_many_request_widget.dart';
// import 'package:star_fish/view/widgets/err_state_widget/unknown_err_widget.dart';
// import 'package:star_fish/view/widgets/request_button/request_button_bloc.dart';
//
// import 'chat_refresh_ui_bloc.dart';
//
// enum ChildWidgetPosition { top, bottom }
//
// typedef Widget ChatChildWidget<T>(T? data, RefreshLoad func, bool isList, int index,
//     Function delete, Function replace, Function addData);
//
// class ChatRefreshUiBuilder<T> extends StatefulWidget {
//   /// request link ရေးရန်
//   String url;
//
//   /// request body ရေးရန်
//   Map<String, dynamic>? map;
//
//   /// listview  နဲ့ ဖော်ပြမယ်ဆိုရင် true, gridview နဲ့ ဖော်ပြမယ်ဆိုရင် false
//   bool isList;
//
//   /// RequestType က Get ဒါမှမဟုတ် Post
//   ReqType requestType;
//
//   /// HeaderType က ယခု apex project အတွက် သီးသန့်ဖြစ်ပြီး customer, normal,agent ; default က normal
//   HeaderType headerType;
//
//   /// ကိုယ်တိုင် loading widget ရေးချင်တဲ့အချိန်မှာ ထည့်ပေးရန် ; default က widget folder အောက်က LoadingWidget
//   Widget? loadingWidget;
//
//   /// girdView အသုံးပြုတဲ့အခါ ဖော်ပြမယ့် gridCount
//   int gridCount;
//
//   /// gridChildRatio က gridview ရဲ့ child တွေ size သတ်မှတ်ဖို့ အသုံးပြုပါတယ်
//   double gridChildRatio;
//
//   /// successResponse ကို စစ်ရန်
//   SuccessCallback? successCallback;
//
//   /// customMoreResponse
//   CustomMoreCallback? customMoreCallback;
//
//   /// errorMoreResponse
//   CustomErrorCallback? customErrorCallback;
//
//   ////]
//   ChatChildWidget<T>? chatChildWidget;
//
//   /// footerWidget mainWidget ရဲ့ အောက်ခြေ widget
//   FooterWidget? footerWidget;
//
//   /// headerWidget mainWidget ရဲ့ အပေါ်ပိုင်း widget
//   HeaderWidget? headerWidget;
//
//   Widget? scrollHeaderWidget;
//
//   /// စာမျက်အစမှာ data ရယူချင်ရင် true, မယူချင်ရင် false,  default က true
//   bool isFirstLoad;
//
//   /// child widget ကို နှိပ်ရင် အလုပ်လုပ်မယ့် method
//   Function? onChildPress;
//
//   bool enablePullUp = false;
//
//   ScrollController? scrollController;
//
//   bool? isCached;
//
//   DartPusher? pusher;
//
//   ChatRefreshUiBuilder(
//       {required this.url,
//       Key? key,
//       this.scrollController,
//       this.chatChildWidget,
//       this.isFirstLoad = true,
//       this.map,
//       this.footerWidget,
//       this.headerWidget,
//       this.scrollHeaderWidget,
//       this.isList = true,
//       this.requestType = ReqType.Get,
//       this.loadingWidget,
//       this.gridCount = 2,
//       this.successCallback,
//       this.customMoreCallback,
//       this.customErrorCallback,
//       this.gridChildRatio = 100 / 130,
//       this.onChildPress,
//       this.enablePullUp = false,
//       this.headerType = HeaderType.Normal,
//       this.pusher,
//       this.isCached = true})
//       : super(key: key);
//
//   @override
//   ChatRefreshUiBuilderState createState() => ChatRefreshUiBuilderState<T>(this.map);
// }
//
// class ChatRefreshUiBuilderState<T> extends State<ChatRefreshUiBuilder> {
//   late ChatRefreshUiBloc<T> bloc;
//
//   // final _deleteBloc = RequestButtonBloc();
//
//   List<T?>? ois = [];
//   late RefreshController _rController;
//   Map<String, dynamic>? map;
//
//   ChatRefreshUiBuilderState(this.map);
//
//   //
//   // bool isEdit = false;x
//   //
//   // void addData(T data) {
//   //   isEdit = true;
//   //   setState(() {
//   //     ois.insert(0, data);
//   //   });
//   // }
//   //
//   void replace(T data, int index) {
//     bloc.replaceData(data, index);
//   }
//
//   void deleteData(T data) {
//     bloc.deleteCount += 1;
//     bloc.deleteData(data);
//   }
//
//   void addData(ChatMessageData data) {
//     // bloc.addData(data);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     bloc = ChatRefreshUiBloc<T>(widget.pusher);
//     bloc.listenEvent();
//     _rController = RefreshController();
//     if (widget.isFirstLoad) {
//       bloc.getData(widget.url,
//           map: widget.map,
//           requestType: widget.requestType,
//           headerType: widget.headerType,
//           isCached: widget.isCached);
//     }
//     bloc.listStream().listen((rv) {
//       if (rv.pgState != null) {
//         if (rv.pgState == PageState.first) {
//           _rController.refreshCompleted();
//           _rController.resetNoData();
//           _rController.loadComplete();
//         } else {
//           if (rv.message == MsgState.data) {
//             if (rv.pgState == PageState.no_more) {
//               _rController.loadNoData();
//             } else {
//               _rController.loadComplete();
//             }
//           }
//         }
//       }
//       if (rv.message == MsgState.data) {
//         if (widget.successCallback != null) {
//           widget.successCallback!(rv);
//         }
//       }
//       if (rv.message == MsgState.error) {
//         if (widget.customErrorCallback != null) {
//           widget.customErrorCallback!(rv);
//         }
//       }
//       if (rv.message == MsgState.more) {
//         if (widget.customMoreCallback != null) {
//           widget.customMoreCallback!(rv);
//         }
//       }
//     });
//
//     /// Delete Bloc
//     // _deleteBloc.getRequestStream().listen((ResponseOb resp) {
//     //   if (resp.message == MsgState.data) {
//     //
//     //     Map<String, dynamic> myMap = resp.data;
//     //
//     //     T messageData = objectFactories[T]!(myMap['data']);
//     //
//     //
//     //     int place = ois!.indexWhere((element) => element == messageData);
//     //
//     //     ois!.forEach((element) {
//     //     });
//     //
//     //     if (place != -1) {
//     //       ois![place] = messageData;
//     //     }
//     //
//     //
//     //     setState(() {});
//     //   }
//     // });
//   }
//
//   final pullUpSty = TextStyle(fontSize: 15, color: Colors.grey.shade400);
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return shopWidget(size);
//   }
//
//   func(
//       {Map<String, dynamic>? map,
//       ReqType? requestType = ReqType.Get,
//       HeaderType? headerType,
//       bool? refreshShowLoading = true,
//       String? newUrl}) {
//     this.map = map;
//     setState(() {
//       widget.isFirstLoad = true;
//     });
//     bloc.getData(newUrl ?? widget.url,
//         map: map,
//         requestType: requestType,
//         headerType: headerType ?? widget.headerType,
//         requestShowLoading: refreshShowLoading!,
//         isCached: widget.isCached);
//   }
//
//   Widget shopWidget(Size size) {
//     return Column(
//       children: [
//         //child widget
//         widget.headerWidget != null ? widget.headerWidget!() : Container(),
//         //end child widget
//         !widget.isFirstLoad
//             ? Container()
//             : Expanded(
//                 child: StreamBuilder<ResponseOb>(
//                     stream: bloc.listStream(),
//                     initialData: ResponseOb(data: null, message: MsgState.loading),
//                     builder: (context, AsyncSnapshot<ResponseOb> snap) {
//                       ResponseOb rv = snap.data!;
//
//                       if (rv.message == MsgState.loading) {
//                         return widget.loadingWidget != null
//                             ? widget.loadingWidget!
//                             : Center(
//                                 child: Container(),
//                               );
//                       } else if (rv.message == MsgState.data) {
//                         if (rv.mode == RefreshUIMode.delete) {
//                           ois!.remove(rv.data);
//                         } else if (rv.mode == RefreshUIMode.replace) {
//                           var data = rv.data['data'];
//                           int index = rv.data['index'];
//                           ois![index] = data;
//                         } else if (rv.mode == RefreshUIMode.edit) {
//                           int index = ois!.indexOf(rv.data);
//
//                         } else if (rv.mode == RefreshUIMode.add) {
//                           if (!ois!.contains(rv.data)) {
//                             ois!.insert(0, rv.data);
//                           }
//                         } else if (rv.mode == RefreshUIMode.none) {
//                           if (rv.pgState == PageState.first) {
//                             ois = rv.data;
//                           } else {
//                             ois!.addAll(rv.data);
//                           }
//                         }
//                         return SmartRefresher(
//                             reverse: true,
//                             physics: BouncingScrollPhysics(),
//                             scrollController: widget.scrollController,
//                             primary: widget.scrollController == null ? true : false,
//                             controller: _rController,
//                             enablePullUp:
//                                 widget.enablePullUp ? widget.enablePullUp : ois!.length > 9,
//                             // enablePullUp: true,
//                             footer: CustomFooter(
//                               builder: (context, loadStatus) {
//                                 if (loadStatus == LoadStatus.loading) {
//                                   return Container();
//                                 } else if (loadStatus == LoadStatus.failed) {
//                                   return Center(child: Text("Load fail!", style: pullUpSty));
//                                 } else if (loadStatus == LoadStatus.canLoading) {
//                                   return Center(
//                                       child: Text('Release to load more', style: pullUpSty));
//                                 } else if (loadStatus == LoadStatus.idle) {
//                                   return Center(child: Text('Pull up to load', style: pullUpSty));
//                                 } else {
//                                   return Center();
//                                 }
//                               },
//                             ),
//                             onRefresh: () {
//                               // bloc.getData(widget.url,
//                               //     map: map,
//                               //     requestType: widget.requestType,
//                               //     headerType: widget.headerType,
//                               //     isCached: widget.isCached);
//                               _rController.refreshCompleted();
//                               _rController.resetNoData();
//                               _rController.loadComplete();
//                             },
//                             onLoading: () {
//                               bloc.getLoad(widget.url, map,
//                                   requestType: widget.requestType,
//                                   headerType: widget.headerType,
//                                   isCached: widget.isCached);
//                             },
//                             child: ois!.length == 0
//                                 ? ListView(
//                                     children: <Widget>[
//                                       SizedBox(
//                                         height: size.height * 0.20,
//                                       ),
//                                       Container(
//                                         child: Image.asset('assets/images/empty_slip.png'),
//                                         width: 180,
//                                         height: 180,
//                                       ),
//                                       SizedBox(
//                                         height: 10.0,
//                                       ),
//                                       Text(
//                                         AppTranslations.of(context)!.trans("no_data"),
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : widget.scrollHeaderWidget == null
//                                     ? mainList(ois)
//                                     : SingleChildScrollView(
//                                         child: Column(
//                                           children: [widget.scrollHeaderWidget!, mainList(ois)],
//                                         ),
//                                       )
//                             // mainList(ois)
//                             );
//                       } else if (rv.message == MsgState.error) {
//                         if (rv.errState == ErrState.no_internet) {
//                           return NoInternetWidget(fun: () {
//                             bloc.getData(widget.url,
//                                 map: widget.map,
//                                 requestType: widget.requestType,
//                                 headerType: widget.headerType);
//                           });
//                         } else if (rv.errState == ErrState.not_found) {
//                           return NotFoundWidget();
//                         } else if (rv.errState == ErrState.connection_timeout) {
//                           return ConnectionTimeoutWidget(fun: () {
//                             bloc.getData(widget.url,
//                                 map: widget.map,
//                                 requestType: widget.requestType,
//                                 headerType: widget.headerType);
//                           });
//                         } else if (rv.errState == ErrState.too_many_request) {
//                           return TooManyRequestWidget(
//                             fun: () {
//                               bloc.getData(widget.url,
//                                   map: widget.map,
//                                   requestType: widget.requestType,
//                                   headerType: widget.headerType);
//                             },
//                           );
//                         } else if (rv.errState == ErrState.server_error) {
//                           return ServerErrWidget(fun: () {
//                             bloc.getData(widget.url,
//                                 map: widget.map,
//                                 requestType: widget.requestType,
//                                 headerType: widget.headerType);
//                           });
//                         } else if (rv.errState == ErrState.unknown_err) {
//                           return UnknownErrWidget(
//                             fun: () {
//                               bloc.getData(widget.url,
//                                   map: widget.map,
//                                   requestType: widget.requestType,
//                                   headerType: widget.headerType);
//                             },
//                           );
//                         } else {
//                           return UnknownErrWidget(
//                             fun: () {
//                               bloc.getData(widget.url,
//                                   map: widget.map,
//                                   requestType: widget.requestType,
//                                   headerType: widget.headerType);
//                             },
//                           );
//                         }
//                       } else if (rv.message == MsgState.more) {
//                         return SingleChildScrollView(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             // crossAxisAlignment: CrossAxisAlignment.stretch,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SizedBox(
//                                 height: size.height * 0.2,
//                               ),
//                               if (rv.data["target"] == "send-request")
//                                 Container(
//                                     height: 200,
//                                     width: 200,
//                                     child: Image.asset(
//                                       'assets/icons/denied_removebg.png',
//                                       fit: BoxFit.fill,
//                                     )),
//                               Text(
//                                 rv.data['message'].toString(),
//                                 style: Theme.of(context).textTheme.subtitle1,
//                                 textAlign: TextAlign.center,
//                               ),
//                               // send-request
//                               if (rv.data["target"] == "send-request")
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                               if (rv.data["target"] == "send-request")
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     TextButton(
//                                       // style: TextButton.styleFrom(
//                                       //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                       //     backgroundColor: Theme.of(context).primaryColor,
//                                       //     foregroundColor: Colors.white),
//                                       onPressed: () {
//                                         context.offAll(StarFishPage());
//                                       },
//                                       child: Text("BACK TO HOME"),
//                                       // color: Theme.of(context).primaryColor,
//                                       // textColor: Colors.white,
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     TextButton(
//                                       // style: TextButton.styleFrom(
//                                       //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                       //     backgroundColor: Theme.of(context).primaryColor,
//                                       //     foregroundColor: Colors.white),
//                                       onPressed: () {
//                                         context.to(ApexServiceRequestPage());
//                                       },
//                                       child: Text("SEND REQUEST"),
//                                     ),
//                                   ],
//                                 )
//                             ],
//                           ),
//                         );
//                       } else {
//                         return UnknownErrWidget(
//                           fun: () {
//                             bloc.getData(widget.url,
//                                 map: widget.map,
//                                 requestType: widget.requestType,
//                                 headerType: widget.headerType);
//                           },
//                         );
//                       }
//                     }),
//               ),
//         widget.footerWidget != null ? widget.footerWidget!(func) : Container(),
//       ],
//     );
//   }
//
//   Widget mainList(List<T?>? ois) {
//     return widget.isList
//         ? ListView.builder(
//             // reverse: true,
//
//             shrinkWrap: widget.scrollHeaderWidget != null ? true : false,
//             physics: widget.scrollHeaderWidget != null ? ClampingScrollPhysics() : null,
//             itemBuilder: (context, index) {
//               T? data = ois![index];
//               return widget.chatChildWidget!(
//                   data, func, widget.isList, index, deleteData, replace, addData);
//               // return widgetFactories[T]!(ois[index], ({bool requestShowLoading = true}) {
//               //   return bloc.getData(widget.url,
//               //       map: widget.map,
//               //       requestType: widget.requestType,
//               //       headerType: widget.headerType,
//               //       requestShowLoading: requestShowLoading);
//               // }, widget.onChildPress, widget.isList, delete: deleteData, index: index, replace: replace);
//             },
//             itemCount: ois!.length,
//           )
//         : GridView.builder(
//             shrinkWrap: widget.scrollHeaderWidget != null ? true : false,
//             physics: widget.scrollHeaderWidget != null ? ClampingScrollPhysics() : null,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: widget.gridCount, childAspectRatio: widget.gridChildRatio),
//             itemBuilder: (context, index) {
//               T? data = ois![index];
//               return widget.chatChildWidget!(
//                   data, func, widget.isList, index, deleteData, replace, addData);
//               // return widget.childWidget(ois[index],func,widget.isList);
//
//               // return widgetFactories[T](ois[index], () {
//               //   return bloc.getData(widget.url, map: widget.map, requestType: widget.requestType, headerType: widget.headerType);
//               // }, widget.onChildPress, widget.isList, delete: deleteData, index:index, replace: replace);
//             },
//             itemCount: ois!.length,
//           );
//
//     // GridView.count(
//     //   shrinkWrap: widget.scrollHeaderWidget!=null?true:false,
//     //   physics: widget. !=null?ClampingScrollPhysics():null,
//     //   childAspectRatio: widget.gridChildRatio,
//     //   children: ois.map<Widget>((f) {
//     //     return widgetFactories[T](f, () {
//     //       return bloc.getData(widget.url,
//     //           map: widget.map,
//     //           requestType: widget.requestType,
//     //           headerType: widget.headerType);
//     //     }, widget.onChildPress,widget.isList,deleteData,index,replace);
//     //   }).toList(),
//     // );
//   }
// }
