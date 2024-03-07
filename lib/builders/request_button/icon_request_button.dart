import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/network/dio_basenetwork.dart';
import '../../core/ob/response_ob.dart';
import '../../core/utils/app_utils.dart';
import '../../core/utils/logger.dart';
import '../../global.dart';
import '../../widgets/loading_widget.dart';
import 'request_button_bloc.dart';



typedef dynamic OnPressed();
typedef Future<Map<String, dynamic>> onAsyncPressed();

typedef void SuccessFuncMethod(ResponseOb ob);
typedef void ValidFuncMethod(ResponseOb ob);
typedef void MoreFuncMethod(ResponseOb ob);

class IconRequestButton extends StatefulWidget {
  String url; //request url
  String? text; //
  ScaffoldState? scaffoldState;
  bool changeFormData; //dio request -> true/false
  bool isShowDialog; //true
  Color textColor;
  Color color;
  EdgeInsetsGeometry padding;
  TextStyle? textStyle;
  SuccessFuncMethod successFunc;
  OnPressed? onPress; //Map
  onAsyncPressed? onAsyncPress; //Map<>
  Function? errorFunc; //
  ValidFuncMethod? validFunc;
  ReqType requestType;
  bool isDisable;
  double borderRadius;
  bool showErrSnack;
  Widget icon;
  Widget? loadingWidget;
  bool showLoading;

  bool isAlreadyFormData;
  MoreFuncMethod? moreFunc;

  IconRequestButton(
      {Key? key,
        required this.url,
        this.scaffoldState,
        required this.successFunc,
        this.errorFunc,
        this.isAlreadyFormData = false,
        this.showLoading = true,
        this.onPress,
        this.onAsyncPress,
        this.changeFormData = false,
        this.textColor = Colors.white,
        this.color = Colors.teal,
        this.padding = const EdgeInsets.all(10),
        this.isShowDialog = false,
        this.textStyle,
        this.validFunc,
        this.requestType = ReqType.Post,
        this.isDisable = false,
        this.borderRadius = 5,
        this.showErrSnack = true,
        required this.icon,
        this.loadingWidget,
        this.moreFunc})
      : super(key: key);

  @override
  IconRequestButtonState createState() => IconRequestButtonState();
}

class IconRequestButtonState extends State<IconRequestButton> {
  final _bloc = RequestButtonBloc();

  bool isShowingDialog = false;

  @override
  void initState() {
    super.initState();

    _bloc.getRequestStream().listen((ResponseOb resp) {
      if (resp.message == MsgState.data) {
        if (widget.isShowDialog) {
          if (isShowingDialog) {
            Navigator.of(context).pop();
          }
        }
        widget.successFunc(resp);
      }

      if (resp.message == MsgState.more) {
        if (widget.isShowDialog) {
          if (isShowingDialog) {
            Navigator.of(context).pop();
          }
        }

        if (widget.errorFunc == null) {
          AppUtils.moreResponse(resp, context);
          if (widget.moreFunc != null) {
            widget.moreFunc!(resp);
          }
        } else {
          widget.errorFunc!();
        }
      }

      if (resp.message == MsgState.error) {
        if (resp.errState == ErrState.no_login) {
          //&& widget.errorFunc == null
           iLog("No Login ------->");
        }

        if (widget.isShowDialog) {
          if (isShowingDialog) {
            Navigator.of(context).pop();
          }
        }

        if (widget.errorFunc == null) {
          if (widget.scaffoldState != null) {
            AppUtils.checkError(
              resp,
            );
          } else {
            if (widget.showErrSnack) {
              AppUtils.checkError(
                resp,
              );
            }
          }
        } else {
          widget.errorFunc!();
          if (widget.showErrSnack) {
            if (widget.scaffoldState != null) {
              AppUtils.checkError(
                resp,
              );
            } else {
              AppUtils.checkError(
                resp,
              );
            }
          }
        }

        if (resp.errState == ErrState.validate_err) {
          if (widget.validFunc != null) {
            resp.data = json.decode(resp.data);
            widget.validFunc!(resp);
          }
        }
      }
    });
  }

  func({String? url, Map<String, dynamic>? map, ReqType requestType = ReqType.Get, bool refreshShowLoading = true}) {
    _bloc.postData(url, map: map, requestType: requestType, requestShowLoading: refreshShowLoading);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ResponseOb>(
      builder: (context, snapshot) {
        ResponseOb? resp = snapshot.data;
        if (widget.showLoading) {
          if (resp!.message == MsgState.loading && widget.isShowDialog == false) {
            return FittedBox(
              child: Center(
                child: widget.loadingWidget ?? LoadingWidget(),
              ),
            );
          } else {
            return mainWidget();
          }
        } else {
          return mainWidget();
        }
      },
      initialData: ResponseOb(),
      stream: _bloc.getRequestStream(),
    );
  }

  Widget mainWidget() {
    return InkWell(
      onTap: widget.isDisable
          ? null
          : () async {
        if (widget.onPress != null) {
          if (widget.onPress!() != null) {
            checkDialog();
            if (widget.isAlreadyFormData) {
              _bloc.postData(widget.url, fd: widget.onPress!(), requestType: widget.requestType);
            } else {
              if (!widget.changeFormData) {
                _bloc.postData(widget.url, map: widget.onPress!(), requestType: widget.requestType);
              } else {
                FormData fd = FormData.fromMap(widget.onPress!());
                _bloc.postData(widget.url, fd: fd, requestType: widget.requestType);
              }
            }
          }
        } else {
          await widget.onAsyncPress!().then((a) {
            checkDialog();
            if (widget.requestType == ReqType.Get) {
              _bloc.postData(widget.url, map: a, requestType: widget.requestType);
            } else {
              FormData fd = FormData.fromMap(a);
              _bloc.postData(widget.url, fd: fd, requestType: widget.requestType);
            }
          });
        }
      },
      child: widget.icon,
    );
  }

  checkDialog() async {
    if (widget.isShowDialog) {
      isShowingDialog = true;
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
        isShowingDialog = false;
      });
    }
  }

  @override
  void dispose() {
    _bloc.disponse();
    super.dispose();
  }
}
