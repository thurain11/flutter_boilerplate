import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/network/dio_basenetwork.dart';
import '../../core/ob/response_ob.dart';
import '../../global.dart';
import '../../widgets/err_state_widget/connection_timeout_widget.dart';
import '../../widgets/err_state_widget/no_data_widget.dart';
import '../../widgets/err_state_widget/no_internet_widget.dart';
import '../../widgets/err_state_widget/not_found_widget.dart';
import '../../widgets/err_state_widget/server_err_widget.dart';
import '../../widgets/err_state_widget/too_many_request_widget.dart';
import '../../widgets/err_state_widget/unknown_err_widget.dart';
import '../../widgets/loading_widget.dart';
import '../typedef/type_def.dart';
import 'external_refresh_ui_bloc.dart';

enum ChildWidgetPosition { top, bottom }

class ExternalRefreshUiBuilder<T, D> extends StatefulWidget {
  /// request link ရေးရန်
  String url;

  /// request body ရေးရန်
  Map<String, dynamic>? map;

  /// listview  နဲ့ ဖော်ပြမယ်ဆိုရင် true, gridview နဲ့ ဖော်ပြမယ်ဆိုရင် false
  bool isList;

  /// RequestType က Get ဒါမှမဟုတ် Post
  ReqType requestType;

  /// HeaderType က ယခု apex project အတွက် သီးသန့်ဖြစ်ပြီး customer, normal,agent ; default က normal

  /// ကိုယ်တိုင် loading widget ရေးချင်တဲ့အချိန်မှာ ထည့်ပေးရန် ; default က widget folder အောက်က LoadingWidget
  Widget? loadingWidget;

  /// girdView အသုံးပြုတဲ့အခါ ဖော်ပြမယ့် gridCount
  int gridCount;

  Function? dataClearFunc;
  bool isDataClear;

  /// gridChildRatio က gridview ရဲ့ child တွေ size သတ်မှတ်ဖို့ အသုံးပြုပါတယ်
  double gridChildRatio;

  /// successResponse ကို စစ်ရန်
  SuccessCallback? successCallback;

  /// customMoreResponse
  CustomMoreCallback? customMoreCallback;

  /// errorMoreResponse
  CustomErrorCallback? customErrorCallback;

  ExternalRefreshWidgetbuilder? builder;

  /// စာမျက်အစမှာ data ရယူချင်ရင် true, မယူချင်ရင် false,  default က true
  bool isFirstLoad;

  CommunityChildWidget? childWidget;

  bool enablePullUp = false;
  ScrollController? scrollController;
  ScorllableHeaderWidget? scorllableHeaderWidget;
  String? param;

  ExternalRefreshUiBuilder(
      {required this.url,
      Key? key,
      this.scrollController,
      this.isFirstLoad = true,
      this.map,
      this.builder,
      this.isList = true,
      this.childWidget,
      this.requestType = ReqType.Get,
      this.loadingWidget,
      this.scorllableHeaderWidget,
      this.gridCount = 2,
      this.successCallback,
      this.customMoreCallback,
      this.customErrorCallback,
      this.gridChildRatio = 100 / 130,
      this.enablePullUp = false,
      this.param,
      this.dataClearFunc,
      this.isDataClear = false,
      })
      : super(key: key);

  @override
  ExternalRefreshUiBuilderState createState() => ExternalRefreshUiBuilderState<T, D>(this.map);
}

class ExternalRefreshUiBuilderState<T, D> extends State<ExternalRefreshUiBuilder> {
  late DataRefreshUiBloc<T> bloc;
  List<D>? ois = [];
  late RefreshController _rController;
  Map<String, dynamic>? map;
  ExternalRefreshUiBuilderState(this.map);

  void replace(T data, int index) {
    bloc.replaceData(data, index);
  }

  void deleteData(T data) {
    bloc.deleteData(data);
  }

  @override
  void initState() {
    super.initState();
    bloc = DataRefreshUiBloc<T>();
    _rController = RefreshController();
    if (widget.isFirstLoad) {
      bloc.getData(widget.url, map: widget.map, requestType: widget.requestType,);
    }
    bloc.shopStream().listen((rv) {
      if (rv.pgState != null) {
        if (rv.pgState == PageState.first) {
          _rController.refreshCompleted();
          _rController.resetNoData();
          _rController.loadComplete();
        } else {
          if (rv.message == MsgState.data) {
            if (rv.pgState == PageState.no_more) {
              _rController.loadNoData();
            } else {
              _rController.loadComplete();
            }
          }
        }
      }
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

  final pullUpSty = TextStyle(fontSize: 15, color: Colors.grey.shade400);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return shopWidget(size);
  }

  func({Map<String, dynamic>? map, ReqType? requestType = ReqType.Get, bool? refreshShowLoading = true}) {
    this.map = map;
    setState(() {
      widget.isFirstLoad = true;
    });
    bloc.getData(widget.url,
        map: map, requestType: requestType, requestShowLoading: refreshShowLoading!);
  }

  Widget shopWidget(Size size) {
    return StreamBuilder<ResponseOb>(
        stream: bloc.shopStream(),
        initialData: ResponseOb(data: null, message: MsgState.loading),
        builder: (context, AsyncSnapshot<ResponseOb> snap) {
          ResponseOb rv = snap.data!;
          if (rv.message == MsgState.loading) {
            return widget.loadingWidget != null
                ? widget.loadingWidget!
                : Center(
                    child: LoadingWidget(),
                  );
          } else if (rv.message == MsgState.data) {
            T? ob;
            if (rv.pgState == PageState.first) {
              ob = rv.data;
              ois = rv.data.data;
            } else {
              ob = rv.data;
              ois!.addAll(rv.data.data);
            }
            return widget.builder!(
                SmartRefresher(
                    physics: BouncingScrollPhysics(),
                    scrollController: widget.scrollController,
                    primary: widget.scrollController == null ? true : false,
                    controller: _rController,
                    enablePullUp: widget.enablePullUp ? widget.enablePullUp : ois!.length > 9,
                    // enablePullUp: true,
                    footer: CustomFooter(
                      builder: (context, loadStatus) {
                        if (loadStatus == LoadStatus.loading) {
                          return LoadingWidget(size: 30);
                        } else if (loadStatus == LoadStatus.failed) {
                          return Center(child: Text("Load fail!", style: pullUpSty));
                        } else if (loadStatus == LoadStatus.canLoading) {
                          return Center(child: Text('Release to load more', style: pullUpSty));
                        } else if (loadStatus == LoadStatus.idle) {
                          return Center(child: Text('Pull up to load', style: pullUpSty));
                        } else {
                          return Container();
                        }
                      },
                    ),
                    onRefresh: () {
                      if (widget.isDataClear) {
                        widget.dataClearFunc!();
                      } else {
                        bloc.getData(widget.url, map: map, requestType: widget.requestType,);
                      }
                    },
                    onLoading: () {
                      bloc.getLoad(widget.url, map: map, requestType: widget.requestType,);
                    },
                    child: ois!.length == 0
                        ? ListView(
                            children: <Widget>[
                              SizedBox(
                                height: size.height * 0.20,
                              ),
                              Container(
                                child: Image.asset('assets/images/empty_message.png'),
                                width: 150,
                                height: 150,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'NO DATA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : widget.scorllableHeaderWidget == null
                            ? mainList(
                                ois,
                              )
                            : ListView(
                                children: [
                                  widget.scorllableHeaderWidget!(ob),
                                  mainList(ois),
                                ],
                              )),
                ob);
          } else if (rv.message == MsgState.error) {
            if (rv.errState == ErrState.no_internet) {
              return NoInternetWidget(fun: () {
                bloc.getData(widget.url, map: widget.map, requestType: widget.requestType,);
              });
            } else if (rv.errState == ErrState.not_found) {
              return NotFoundWidget();
            } else if (rv.errState == ErrState.connection_timeout) {
              return ConnectionTimeoutWidget(fun: () {
                bloc.getData(widget.url, map: widget.map, requestType: widget.requestType,);
              });
            } else if (rv.errState == ErrState.too_many_request) {
              return TooManyRequestWidget(
                fun: () {
                  bloc.getData(widget.url, map: widget.map, requestType: widget.requestType,);
                },
              );
            } else if (rv.errState == ErrState.server_error) {
              return ServerErrWidget(fun: () {
                bloc.getData(widget.url, map: widget.map, requestType: widget.requestType,);
              });
            } else if (rv.errState == ErrState.unknown_err) {
              return UnknownErrWidget(
                fun: () {
                  bloc.getData(widget.url, map: widget.map, requestType: widget.requestType,);
                },
              );
            } else {
              return UnknownErrWidget(
                fun: () {
                  bloc.getData(widget.url, map: widget.map, requestType: widget.requestType,);
                },
              );
            }
          } else if (rv.message == MsgState.more) {
            return NoDataWidget();
          } else {
            return UnknownErrWidget(
              fun: () {
                bloc.getData(widget.url, map: widget.map, requestType: widget.requestType,);
              },
            );
          }
        });
  }

  Widget mainList(List<D>? ois) {
    return widget.isList
        ? ListView.builder(
            shrinkWrap: widget.scorllableHeaderWidget == null ? false : true,
            physics: widget.scorllableHeaderWidget == null ? null : ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              D data = ois![index];
              return widget.childWidget!(data, func, widget.isList, index, deleteData, replace);
              // return widgetFactories[D](ois[index], () {
              //   return bloc.getData(widget.url, map: widget.map, requestType: widget.requestType,);
              // }, widget.onChildPress, widget.isList, delete: deleteData, index: index, replace: replace,param:widget.param);
            },
            itemCount: ois!.length,
          )
        : GridView.builder(
            shrinkWrap: widget.scorllableHeaderWidget == null ? false : true,
            physics: widget.scorllableHeaderWidget == null ? null : ClampingScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: widget.gridCount, childAspectRatio: widget.gridChildRatio),
            itemBuilder: (context, index) {
              D data = ois![index];
              return widget.childWidget!(data, func, widget.isList, index, deleteData, replace);
            },
            itemCount: ois!.length,
          );
  }
}
