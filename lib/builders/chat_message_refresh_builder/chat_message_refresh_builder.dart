// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
//
// import '../../core/network/dio_basenetwork.dart';
// import '../../core/ob/response_ob.dart';
// import '../../global.dart';
// import '../../widgets/err_state_widget/connection_timeout_widget.dart';
// import '../../widgets/err_state_widget/no_internet_widget.dart';
// import '../../widgets/err_state_widget/not_found_widget.dart';
// import '../../widgets/err_state_widget/server_err_widget.dart';
// import '../../widgets/err_state_widget/too_many_request_widget.dart';
// import '../../widgets/err_state_widget/unknown_err_widget.dart';
// import '../../widgets/loading_widget.dart';
// import '../typedef/type_def.dart';
// import 'chat_refresh_ui_bloc.dart';
//
//
// enum ChildWidgetPosition { top, bottom }
//
// typedef Widget ChatChildWidget(ChatMessageData? data, RefreshLoad func, bool isList, int index,
//     Function delete, Function replace);
//
// class ChatMessageRefreshUiBuilder extends StatefulWidget {
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
//   ChatChildWidget? chatChildWidget;
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
//   AutoScrollController? autoScrollController;
//   var scrollDirection;
//   bool? isCached;
//
//
//   String? roomId;
//   ChatRefreshUiBloc? bloc;
//
//   ChatMessageRefreshUiBuilder(
//       {
//         required this.url,
//         Key? key,
//         this.chatChildWidget,
//         this.isFirstLoad = true,
//         this.map,
//         this.footerWidget,
//         this.headerWidget,
//         this.scrollHeaderWidget,
//         this.autoScrollController,
//         this.scrollDirection,
//         this.isList = true,
//         this.requestType = ReqType.Get,
//         this.loadingWidget,
//         this.gridCount = 2,
//         this.successCallback,
//         this.customMoreCallback,
//         this.customErrorCallback,
//         this.gridChildRatio = 100 / 130,
//         this.onChildPress,
//         this.enablePullUp = false,
//         this.roomId,
//         this.isCached = false,
//         required this.bloc})
//       : super(key: key);
//
//   @override
//   ChatMessageRefreshUiBuilderState createState() => ChatMessageRefreshUiBuilderState(this.map);
// }
//
// class ChatMessageRefreshUiBuilderState<T> extends State<ChatMessageRefreshUiBuilder> with AutomaticKeepAliveClientMixin{
//   // late ChatRefreshUiBloc bloc;
//
//   // final _deleteBloc = RequestButtonBloc();
//
//   List<ChatMessageData>? ois = [];
//   late RefreshController _rController;
//   Map<String, dynamic>? map;
//
//   ChatMessageRefreshUiBuilderState(this.map);
//
//   void replace(ChatMessageData data, int index) {
//     widget.bloc!.replaceData(data, index);
//   }
//
//   void deleteData(ChatMessageData data) {
//     ChatDataUploadProvider postUploadProvider = Provider.of<ChatDataUploadProvider>(context, listen: false);
//     widget.bloc!.deleteCount += 1;
//     widget.bloc!.deleteData(data);
//     postUploadProvider.cancelUpload(null);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     // bloc = ChatRefreshUiBloc();
//     widget.bloc!.listenEvent();
//     _rController = RefreshController();
//     if (widget.isFirstLoad) {
//       widget.bloc!.getData(widget.url,
//           map: widget.map,
//           requestType: widget.requestType,
//           isCached: widget.isCached);
//     }
//     widget.bloc!.listStream().listen((rv) {
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
//   }
//
//   final pullUpSty = TextStyle(fontSize: 15, color: Colors.grey.shade400);
//
//   Future scrollToIndex(int index) async {
//     await widget.autoScrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     var size = MediaQuery.of(context).size;
//     return shopWidget(size);
//   }
//
//   func(
//       {Map<String, dynamic>? map,
//       ReqType? requestType = ReqType.Get,
//       bool? refreshShowLoading = true,
//       String? newUrl}) {
//     this.map = map;
//     setState(() {
//       widget.isFirstLoad = true;
//     });
//     widget.bloc!.getData(newUrl ?? widget.url,
//         map: map,
//         requestType: requestType,
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
//                     stream: widget.bloc!.listStream(),
//                     initialData: ResponseOb(data: null, message: MsgState.loading),
//                     builder: (context, AsyncSnapshot<ResponseOb> snap) {
//                       ResponseOb rv = snap.data!;
//                       if (rv.message == MsgState.loading) {
//                         return widget.loadingWidget != null
//                             ? widget.loadingWidget!
//                             : Center(
//                                 child: LoadingWidget(),
//                               );
//                       }
//                       else if (rv.message == MsgState.data) {
//                         if (rv.mode == RefreshUIMode.delete) {
//                           ois!.remove(rv.data);
//                         } else if (rv.mode == RefreshUIMode.replace) {
//                           var data = rv.data['data'];
//                           int index = rv.data['index'];
//                           ois![index] = data;
//                         } else if (rv.mode == RefreshUIMode.replaceChatInfoData) {
//                           int index = ois!.indexWhere((element) => element.id == rv.data['id']);
//
//                           if(index!=-1){
//                             ois![index] = rv.data['data'];
//                           }
//                         }
//                         else if (rv.mode == RefreshUIMode.edit) {
//                           ChatMessageData data = rv.data;
//                           int index = ois!.indexWhere((element) => element.id == data.id);
//
//                           if (index != -1) {
//                             ois![index] = rv.data;
//                           }
//                         } else if (rv.mode == RefreshUIMode.add) {
//
//                           Map<String, dynamic> map = rv.data;
//                           ChatMessageData data = map['data'];
//                           int index = ois!.indexWhere((element) => element.id == data.id);
//                           if (index == -1) {
//                             if (widget.roomId == map['room_id']) {
//                               ois!.insert(0, map['data']);
//                             }
//                           }
//                         } else if (rv.mode == RefreshUIMode.addLocalStorage) {
//                           Map<String, dynamic> map = rv.data;
//                           ChatMessageData data = map['data'];
//                           int index = ois!.indexWhere((element) => element.id == data.id);
//                           if(index==-1){
//                             ois!.insert(0, map['data']);
//                           }
//                         } else if(rv.mode == RefreshUIMode.replaceLocalStorage){
//                           int index = ois!.indexWhere((element) => element.id == rv.tempId);
//                           if(index!=-1){
//                             ois!.removeAt(index);
//                             ois!.insert(index, rv.data['data']);
//                           }
//                         } else if(rv.mode == RefreshUIMode.replaceFailedData){
//                           int index = ois!.indexWhere((element) => element.id == rv.tempId);
//                           for(var i=0;i<ois!.length;i++){
//                           }
//                           if(index!=-1){
//                             ois![index].id=ois![index].id.toString()+'SendFailed';
//                           }
//                         }
//                         else if(rv.mode == RefreshUIMode.replaceEditData){
//                           int index = ois!.indexWhere((element) => element.id == rv.tempId);
//                           if(index!=-1){
//                             ois!.insert(index, rv.data['data']);
//                             ois!.removeAt(index+1);
//                           }
//                         }
//                         else if(rv.mode == RefreshUIMode.editLocalStorage){
//
//                           int index = ois!.indexWhere((element) => element.id == rv.data['data'].id);
//
//                           if(index!=-1){
//                             ois!.insert(index, rv.data['data']);
//                             ois!.removeAt(index+1);
//                           }
//                         }
//                           else if (rv.mode == RefreshUIMode.none) {
//                           if (rv.pgState == PageState.first) {
//                             ois = rv.data.data;
//                           } else if (rv.pgState == PageState.no_more) {
//                             ois!.addAll(rv.data);
//                           } else {
//                             ois!.addAll(rv.data.data);
//                           }
//                         }
//                         return SmartRefresher(
//                             reverse: true,
//                             physics: BouncingScrollPhysics(),
//                             // scrollController: widget.scrollController,
//                             // primary: widget.scrollController == null ? true : false,
//                             controller: _rController,
//                             enablePullUp: widget.enablePullUp ? widget.enablePullUp : ois!.length > 19,
//                             // enablePullUp: true,
//                             header: CustomHeader(
//                               height: 10,
//                               completeDuration: Duration(milliseconds: 100),
//                               builder: (BuildContext context, RefreshStatus? mode) {
//                                 return Container();
//                               },
//                             ),
//                             footer: CustomFooter(
//                               builder: (context, loadStatus) {
//                                 if (loadStatus == LoadStatus.loading) {
//                                   return Center(
//                                     child: CupertinoActivityIndicator(
//                                       animating: true,
//                                     ),
//                                   );
//                                 } else if (loadStatus == LoadStatus.failed) {
//                                   return Center(child: Text("Load fail!", style: pullUpSty));
//                                 } else if (loadStatus == LoadStatus.canLoading) {
//                                   return Center(child: Text('Release to load more', style: pullUpSty));
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
//                               //     ,
//                               //     isCached: widget.isCached);
//                               _rController.refreshCompleted();
//                               _rController.resetNoData();
//                               _rController.loadComplete();
//                             },
//                             onLoading: () {
//                               widget.bloc!.getLoad(widget.url, map,
//                                   requestType: widget.requestType,
//
//                                   isCached: widget.isCached);
//                             },
//                             child: ois!.length == 0
//                                 ?
//                             Container()
//                             // Column(
//                             //   mainAxisAlignment: MainAxisAlignment.center,
//                             //   children: <Widget>[
//                             //     Text(
//                             //       "No Messages!",
//                             //       textAlign: TextAlign.center,
//                             //       style: TextStyle(
//                             //         fontSize: 18,
//                             //         fontWeight: FontWeight.bold,
//                             //       ),
//                             //     ),
//                             //     SizedBox(height: 10,),
//                             //     Text(
//                             //       "Let's start the conversation Now!",
//                             //       textAlign: TextAlign.center,
//                             //       style: TextStyle(
//                             //         color: Colors.green,
//                             //         fontWeight: FontWeight.bold,
//                             //       ),
//                             //     ),
//                             //   ],
//                             // )
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
//                             widget.bloc!.getData(widget.url,
//                                 map: widget.map,
//                                 requestType: widget.requestType,
//                                 );
//                           });
//                         } else if (rv.errState == ErrState.not_found) {
//                           return NotFoundWidget();
//                         } else if (rv.errState == ErrState.connection_timeout) {
//                           return ConnectionTimeoutWidget(fun: () {
//                             widget.bloc!.getData(widget.url,
//                                 map: widget.map,
//                                 requestType: widget.requestType,
//                                 );
//                           });
//                         } else if (rv.errState == ErrState.too_many_request) {
//                           return TooManyRequestWidget(
//                             fun: () {
//                               widget.bloc!.getData(widget.url,
//                                   map: widget.map,
//                                   requestType: widget.requestType,
//                                   );
//                             },
//                           );
//                         } else if (rv.errState == ErrState.server_error) {
//                           return ServerErrWidget(fun: () {
//                             widget.bloc!.getData(widget.url,
//                                 map: widget.map,
//                                 requestType: widget.requestType,
//                                 );
//                           });
//                         } else if (rv.errState == ErrState.unknown_err) {
//                           return UnknownErrWidget(
//                             fun: () {
//                               widget.bloc!.getData(widget.url,
//                                   map: widget.map,
//                                   requestType: widget.requestType,
//                                   );
//                             },
//                           );
//                         } else {
//                           return UnknownErrWidget(
//                             fun: () {
//                               widget.bloc!.getData(widget.url,
//                                   map: widget.map,
//                                   requestType: widget.requestType,
//                                   );
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
//                               Text(
//                                 rv.data['message'].toString(),
//                                 style: Theme.of(context).textTheme.subtitle1,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         );
//                       } else {
//                         return UnknownErrWidget(
//                           fun: () {
//                             widget.bloc!.getData(widget.url,
//                                 map: widget.map,
//                                 requestType: widget.requestType,
//                                 );
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
//   Widget mainList(List<ChatMessageData>? ois) {
//     return widget.isList
//         ? ListView.builder(
//             scrollDirection: widget.scrollDirection,
//             controller: widget.autoScrollController,
//             shrinkWrap: widget.scrollHeaderWidget != null ? true : false,
//             physics: widget.scrollHeaderWidget != null ? ClampingScrollPhysics() : null,
//             itemBuilder: (context, index) {
//               ChatMessageData? data = ois[index];
//               return AutoScrollTag(
//                 key: ValueKey(index),
//                 controller: widget.autoScrollController!,
//                 index: index,
//                 child:
//                     widget.chatChildWidget!(data, func, widget.isList, index, deleteData, replace,),
//               );
//
//             },
//             itemCount: ois!.length,
//           )
//         : GridView.builder(
//             shrinkWrap: widget.scrollHeaderWidget != null ? true : false,
//             physics: widget.scrollHeaderWidget != null ? ClampingScrollPhysics() : null,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: widget.gridCount, childAspectRatio: widget.gridChildRatio),
//             itemBuilder: (context, index) {
//               ChatMessageData? data = ois[index];
//               return widget.chatChildWidget!(data, func, widget.isList, index, deleteData, replace,);
//
//             },
//             itemCount: ois!.length,
//           );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//
//   }
//
//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
// }
