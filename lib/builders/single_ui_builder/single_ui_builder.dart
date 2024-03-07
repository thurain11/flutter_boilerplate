
import '../../core/network/dio_basenetwork.dart';
import '../../core/ob/response_ob.dart';
import '../../global.dart';
import '../../widgets/err_state_widget/connection_timeout_widget.dart';
import '../../widgets/err_state_widget/maintain_widget.dart';
import '../../widgets/err_state_widget/no_internet_widget.dart';
import '../../widgets/err_state_widget/no_login_widget.dart';
import '../../widgets/err_state_widget/not_found_widget.dart';
import '../../widgets/err_state_widget/server_err_widget.dart';
import '../../widgets/err_state_widget/too_many_request_widget.dart';
import '../../widgets/err_state_widget/unknown_err_widget.dart';
import '../../widgets/loading_widget.dart';
import '../typedef/type_def.dart';
import 'single_ui_bloc.dart';

typedef Widget MainWidget(dynamic data, RefreshLoad reload);
typedef Widget More(dynamic data, RefreshLoad reload);
typedef void RefreshLoad({Map<String, dynamic>? map, ReqType? requestType, bool? refreshShowLoading});

class SingleUiBuilder<T extends Object> extends StatefulWidget {

  /// request လုပ်မယ် url
  String url;

  bool isBaseUrl;

  String urlId;

  /// data passing လုပ်မယ် data ကို map data type ဖြင့်ပို့ပေးရန်
  Map<String, dynamic>? map;

  /// RequestType.Get or RequestType.Post/ default ->Get
  ReqType requestType;

  /// Customer, Normal, Agent/ default ->Normal

  /// data ရလျှင်ပြမည့် widget
  MainWidget widget;

  Widget? errorWidget;

  /// customLoading widget
  Widget? customLoadingWidget;

  /// စာမျက်နှာအစကတည်းက data ယူမယ်/ default -> true
  bool isInitLoading;

  /// footerWidget mainWidget ရဲ့ အောက်ခြေ widget
  FooterWidget? footerWidget;

  /// headerWidget mainWidget ရဲ့ အပေါ်ပိုင်း widget
  HeaderWidget? headerWidget;

  /// successResponse ကို စစ်ရန်
  SuccessCallback? successCallback;

  /// customMoreResponse
  CustomMoreCallback? customMoreCallback;

  /// Option More Widget
  More? moreWidget;

  /// errorMoreResponse
  CustomErrorCallback? customErrorCallback;

  /// error ကို screen တွင် ပြရုံသာမက alert နဲ့ပါ ထပ်ပြချင်တယ် ဆိုရင် true ပေးပါ
  /// defaul က false
  bool isShowAlertError = false;

  // error widget size
  double? widgetSize;

  // no login error widget

  // isCached
  bool? isCached;

  SingleUiBuilder(
      {Key? key,
      required this.url,
      required this.widget,
      this.urlId = "",
      this.isBaseUrl = true,
      this.map,
      this.requestType = ReqType.Get,
      this.customLoadingWidget,
      this.isInitLoading = true,
      this.footerWidget,
      this.headerWidget,
      this.isShowAlertError = false,
      this.successCallback,
      this.customMoreCallback,
      this.moreWidget,
      this.customErrorCallback,
      this.errorWidget,
      this.widgetSize,
      this.isCached = false})
      : super(key: key);

  @override
  SingleUiBuilderState createState() => SingleUiBuilderState<T>();
}

class SingleUiBuilderState<T> extends State<SingleUiBuilder> {
  late SingleUiBloc<T> bloc;
  @override
  void initState() {
    super.initState();

    bloc = SingleUiBloc<T>(widget.url + widget.urlId, isBaseUrl: widget.isBaseUrl);


    bloc.getData(map: widget.map, requestType: widget.requestType, isCached: widget.isCached);

    bloc.shopStream().listen((rv) {
      print("ANd  rv is ${rv.message} ${rv.data} ");
      if (rv.message == MsgState.data) {
        if (widget.successCallback != null) {
          widget.successCallback!(rv);
        }
      }
      if (rv.message == MsgState.error) {
        if (widget.customErrorCallback != null) {
          widget.customErrorCallback!(rv);
        }
      }
      if (rv.message == MsgState.more) {
        if (widget.customMoreCallback != null) {
          widget.customMoreCallback!(rv);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  func(
      {Map<String, dynamic>? map,
        ReqType? requestType = ReqType.Get,
      bool? refreshShowLoading = true}) {
    bloc.getData(
        map: map, requestType: requestType, requestShowLoading: refreshShowLoading!, isCached: widget.isCached);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return mainWidget(size);
  }

  Widget mainWidget(Size size) {
    return StreamBuilder<ResponseOb>(
        stream: bloc.shopStream(),
        initialData: ResponseOb(data: null, message: MsgState.loading),
        builder: (context, AsyncSnapshot<ResponseOb> snap) {
          ResponseOb rv = snap.data!;
          if (rv.message == MsgState.loading) {
            return widget.customLoadingWidget != null ? widget.customLoadingWidget! : Center(child: LoadingWidget());
          } else if (rv.message == MsgState.data) {
            T? data = rv.data as T?;
            return widget.widget(data, func);
          } else if (rv.message == MsgState.error) {
            if (widget.errorWidget == null) {
              if (rv.errState == ErrState.no_internet) {
                return NoInternetWidget(
                  fun: () {
                    bloc.getData(map: widget.map, requestType: widget.requestType, );
                  },
                  imgSize: widget.widgetSize,
                );
              } else if (rv.errState == ErrState.not_found) {
                return NotFoundWidget(
                  widgetSize: widget.widgetSize,
                );
              } else if (rv.errState == ErrState.connection_timeout) {
                return ConnectionTimeoutWidget(fun: () {
                  bloc.getData(map: widget.map, requestType: widget.requestType, );
                });
              } else if (rv.errState == ErrState.too_many_request) {
                return TooManyRequestWidget(
                  fun: () {
                    bloc.getData(map: widget.map, requestType: widget.requestType, );
                  },
                );
              } else if (rv.errState == ErrState.server_error) {
                return ServerErrWidget(
                  fun: () {
                    bloc.getData(map: widget.map, requestType: widget.requestType, );
                  },
                  widgetSize: widget.widgetSize,
                );
              } else if (rv.errState == ErrState.server_maintain) {
                return ServerMaintenance(widgetSize: widget.widgetSize);
              } else if (rv.errState == ErrState.no_login) {
                if (rv.data is Map<String, dynamic>) {
                  return NoLoginWidget(

                    message: rv.data['hint'].toString(),
                  );
                }
                return NoLoginWidget(

                );
              } else if (rv.errState == ErrState.unknown_err) {
                return UnknownErrWidget(
                  fun: () {
                    bloc.getData(map: widget.map, requestType: widget.requestType, );
                  },
                  widgetSize: widget.widgetSize,
                );
              } else {
                return UnknownErrWidget(
                  fun: () {
                    bloc.getData(map: widget.map, requestType: widget.requestType, );
                  },
                );
              }
            } else {
              return widget.errorWidget!;
            }
          } else if (rv.message == MsgState.more) {


            if (widget.moreWidget == null) {
              return Card(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // if (rv.data['warning_message'] != null && rv.data['show_refresh_btn'] == 1)
                      //  PaymentWaitingWidget<T>(,requestType: widget.requestType,bloc: bloc,map: widget.map,rv: rv,),

                      if (rv.data["target"] == "send-request")
                        Container(
                            height: 200,
                            width: 200,
                            child: Image.asset(
                              'assets/icons/denied_removebg.png',
                              fit: BoxFit.fill,
                            )),
                      if (rv.data['warning_message'] == null)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              rv.data['message'].toString(),
                              style: Theme.of(context).textTheme.subtitle1,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30,),
                            ElevatedButton.icon(onPressed: (){
                              context.back();
                            }, icon: Icon(Icons.arrow_back,color: Colors.white,), label: Text("Back",style: TextStyle(color: Colors.white),))
                          ],
                        ),
                      // send-request
                      if (rv.data["target"] == "send-request")
                        const SizedBox(
                          height: 10,
                        ),
                      if (rv.data["target"] == "send-request")
                        ElevatedButton(
                          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              textStyle: TextStyle(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                          onPressed: () {
                            // context.offAll(StarFishPage());
                          },
                          child: Text("SEND REQUEST",style: TextStyle(color: Colors.white),),
                        ),
                    ],
                  ),
                ),
              );
            } else {
              Map<dynamic, dynamic> moreData = rv.data as Map;
              return widget.moreWidget!(moreData, func);
            }
          } else {
            return UnknownErrWidget(
              fun: () {
                bloc.getData(map: widget.map, requestType: widget.requestType, );
              },
            );
          }
        });
  }

  checkDialog() async {
    // if (widget.isShowDialog) {
    //   isShowingDialog = true;
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Stack(
            // overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                child: LoadingWidget(),
              ),
            ],
          );
        }).then((v) {
      // isShowingDialog = false;
    });
    // }
  }
}
