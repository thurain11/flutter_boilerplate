import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_setup/builders/request_button/request_button_bloc.dart';

import '../../core/network/dio_basenetwork.dart';
import '../../core/ob/response_ob.dart';
import '../../core/utils/app_utils.dart';
import '../../global.dart';
import '../../widgets/loading_widget.dart';

typedef dynamic OnPressed();
typedef Future<Map<String, dynamic>?>? onAsyncPressed();

typedef void SuccessFuncMethod(ResponseOb ob);
typedef void ValidFuncMethod(ResponseOb ob);
typedef void MoreFuncMethod(ResponseOb ob);
typedef void StateFuncMethod(ResponseOb ob);

class RequestButton extends StatefulWidget {
  String? url; //request url
  String? text; //
  ScaffoldState? scaffoldState;
  bool changeFormData; //dio request -> true/false
  bool isShowDialog; //true
  Color textColor;
  Color? color;
  EdgeInsetsGeometry padding;
  TextStyle? textStyle;
  SuccessFuncMethod successFunc;
  StateFuncMethod? stateFunc;
  MoreFuncMethod? moreFunc;
  OnPressed? onPress; //Map
  onAsyncPressed? onAsyncPress; //Map<>
  Function? errorFunc; //
  ValidFuncMethod? validFunc;
  ReqType requestType;
  bool isDisable;
  double borderRadius;
  BorderRadius? bRadius;
  bool showErrSnack;
  Widget? icon;
  Widget? loadingWidget;
  bool showLoading;
  Color borderColor;
  double borderWidth;
  bool isAlreadyFormData;
  TextAlign? align;
  String? tempId;

  RequestButton(
      {required this.url,
      required this.text,
      this.scaffoldState,
      required this.successFunc,
      this.stateFunc,
      this.moreFunc,
      this.errorFunc,
      this.isAlreadyFormData = false,
      this.showLoading = true,
      this.onPress,
      this.onAsyncPress,
      this.changeFormData = false,
      this.textColor = Colors.white,
      this.color = Colors.blueAccent,
      this.padding = const EdgeInsets.all(10),
      this.isShowDialog = false,
      this.textStyle,
      this.align,
      this.validFunc,
      this.requestType = ReqType.Post,
      this.isDisable = false,
      this.borderRadius = 5,
      this.bRadius,
      this.showErrSnack = true,
      this.icon,
      this.loadingWidget,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0.0,
      this.tempId = ''});

  @override
  _RequestButtonState createState() => _RequestButtonState();
}

class _RequestButtonState extends State<RequestButton> {
  final _bloc = RequestButtonBloc();

  bool isShowingDialog = false;

  @override
  void initState() {
    super.initState();

    _bloc.getRequestStream().listen((ResponseOb resp) {
      if (widget.stateFunc != null) {
        widget.stateFunc!(resp);
      }

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
          if (widget.showErrSnack) {
            AppUtils.moreResponse(resp, context);
          }
          if (widget.moreFunc != null) {
            Map<String, dynamic> moreMap = resp.data;
            widget.moreFunc!(resp);
          } else if (widget.moreFunc == null) {
            Map<String, dynamic> moreMap = resp.data;
          }
        } else {
          widget.errorFunc!();
        }
      }

      if (resp.message == MsgState.error) {
        if (resp.errState == ErrState.no_login) {
          //&& widget.errorFunc == null
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
            } else {
              if (resp.errState == ErrState.server_error) {
                AppUtils.showSnackBar("Internal Server Error", color: Colors.redAccent);
              }

              if (resp.errState == ErrState.no_internet) {
                AppUtils.showSnackBar("No Internet connection!", color: Colors.redAccent);
              }

              if (resp.errState == ErrState.not_found) {
                AppUtils.showSnackBar("Your requested data not found!", color: Colors.redAccent);
              }

              if (resp.errState == ErrState.connection_timeout) {
                AppUtils.showSnackBar("Connection Timeout! Try Again", color: Colors.redAccent);
              }
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ResponseOb>(
      initialData: ResponseOb(),
      stream: _bloc.getRequestStream(),
      builder: (context, snapshot) {
        ResponseOb? resp = snapshot.data;
        // if (widget.showLoading) {
        //   if (resp!.message == MsgState.loading && widget.isShowDialog == false) {
        //     return Center(
        //       child: widget.loadingWidget ?? LoadingWidget(),
        //     );
        //   } else {
        //     return mainWidget();
        //   }
        // } else {
        return mainWidget();
        // }
      },
    );
  }

  Widget mainWidget() {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius:
                widget.bRadius == null ? BorderRadius.circular(widget.borderRadius) : widget.bRadius!,
            side: BorderSide(color: widget.borderColor, width: widget.borderWidth)),
        padding: widget.padding,
        backgroundColor: widget.color,

        // disabledColor: Colors.grey,
      ),
      onPressed: widget.isDisable
          ? null
          : () async {
              if (widget.onPress != null) {
                // if (widget.onPress!() != null) {

                checkDialog();
                if (widget.isAlreadyFormData) {
                  _bloc.postData(widget.url,
                      fd: widget.onPress!(), requestType: widget.requestType, tempId: widget.tempId);
                } else {
                  if (!widget.changeFormData) {
                    _bloc.postData(widget.url,
                        map: await widget.onPress!(), requestType: widget.requestType, tempId: widget.tempId);
                  } else {
                    FormData fd = FormData.fromMap(widget.onPress!());
                    _bloc.postData(widget.url,
                        fd: fd, requestType: widget.requestType, tempId: widget.tempId);
                  }
                }
                // }
              } else {
                await widget.onAsyncPress!()!.then((a) {
                  if (a != null) {
                    checkDialog();
                    if (widget.requestType == ReqType.Get) {
                      _bloc.postData(widget.url,
                          map: a, requestType: widget.requestType, tempId: widget.tempId);
                    } else {
                      FormData fd = FormData.fromMap(a);
                      _bloc.postData(widget.url,
                          fd: fd, requestType: widget.requestType, tempId: widget.tempId);
                    }
                  }
                });
              }
            },
      child: widget.icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.icon!,
                SizedBox(
                  width: 6,
                ),
                Flexible(
                    child: Text(
                  widget.text!,
                  style: widget.textStyle,
                  textAlign: TextAlign.center,
                )),
              ],
            )
          : Center(
              child: Text(widget.text!, style: widget.textStyle),
            ),
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
