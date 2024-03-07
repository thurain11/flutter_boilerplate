import 'dart:convert';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../global.dart';
import '../../main.dart';
import '../../widgets/loading_widget.dart';
import '../database/share_pref.dart';
import '../ob/response_ob.dart';

enum SnackColor { Warning, Success, Error }

class AppUtils {
  static PreferredSize statusBar({Color color = Colors.teal}) {
    return PreferredSize(
        child: Container(
          color: color,
        ),
        preferredSize: Size(double.infinity, 0));
  }

  // Sizebox အစားထိုး သုံးရန်
  static Widget lengthWidth(double width) {
    return SizedBox(width: width);
  }

  // Sizebox အစားထိုး သုံးရန်
  static Widget lengthHeight(double height) {
    return SizedBox(height: height);
  }

  // it's from notification or not
  static bool isOpenByNotification = false;

  static PreferredSize MyAppBar(
      {Widget? leading,
        List<Widget>? actions,
        required String? title,
        bool centerTitle = true,
        bool autoImplement = true,
        bool hasBottomBar = false,
        PreferredSizeWidget? bottom,
        Color? color,
        String fontFamily = 'notosan_mm',
        double fontSize = 16,
        FontWeight fontWeight = FontWeight.w500,
        Color textColor = Colors.black54,
        Color? iconColor = Colors.indigoAccent,
        Widget? widget}) {
    return PreferredSize(
      preferredSize: Size(double.infinity, (bottom == null ? 50 : 100)),
      child: AppBar(
        surfaceTintColor: Colors.transparent,

        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark
        ),
        // elevation: 2,
        // shadowColor: Colors.indigo.shade50,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(15),
        //   bottomRight: Radius.circular(15),
        // )),
        // backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: iconColor),
        automaticallyImplyLeading: autoImplement,
        title: widget ??
            Text(
              title!,
              style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight,fontFamily: fontFamily),
            ),
        centerTitle: centerTitle,
        actions: actions,
        leading: leading,
        bottom: bottom,
      ),
    );
  }

  static void showSnackBar(String str, {color = Colors.green, textColor = Colors.white}) {
    rootScaffoldKey.currentState!.showSnackBar(SnackBar(
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      content:
      Container(
        padding: EdgeInsets.all(5),
        child: Text(
          str,
        ),
      ),
      backgroundColor: color,
    ));
  }



  static void showSnackChek(String str, {color = Colors.green, textColor = Colors.white, int sec = 7}) {
    rootScaffoldKey.currentState!.showSnackBar(SnackBar(
      duration: Duration(seconds: sec),
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      content:
      Container(
        padding: EdgeInsets.all(5),
        child: Text(
          str,
        ),
      ),
      backgroundColor: color,
    ));

    // rootScaffoldKey.currentState!.showSnackBar(SnackBar(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //   padding: EdgeInsets.all(4),
    //   duration: Duration(seconds: sec),
    //   content: Text(
    //     str,
    //     style: TextStyle(color: textColor, fontFamily: MyAppState.fontFamily, fontSize: 16),
    //     textAlign: TextAlign.center,
    //   ),
    //   backgroundColor: color,
    // ));
  }

  //////////////

  static void showToaster(String str, {color = Colors.redAccent, textColor = Colors.black, graviti = ToastGravity.BOTTOM}) {
    Fluttertoast.showToast(msg: str, backgroundColor: color, gravity: graviti, textColor: textColor, timeInSecForIosWeb: 4);
  }


  static void showActionSnackBar(String str, {color = Colors.black, textColor = Colors.white}) {
    rootScaffoldKey.currentState!.showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: "Login",
          textColor: Colors.blue,
          onPressed: () async {
            await SharedPref.setData(key: SharedPref.token, value: "null");
          },
        ),
        duration: Duration(seconds: 15),
        content: Text(
          str,
          style: TextStyle(color: textColor, fontSize: 17),
        ),
        backgroundColor: color,
      ),
    );
  }

  static void showNormal(String str, {color = Colors.redAccent, textColor = Colors.white}) {
    rootScaffoldKey.currentState!.showSnackBar(SnackBar(
      duration: Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      content:
      Container(
        padding: EdgeInsets.all(5),
        child: Text(
          str,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ),
      backgroundColor: color,
    ));
  }

  static showLoginDialog(String title, String? str, BuildContext context, {String? detailId}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'SUCCESS',
                  //"Success",
                  style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.indigo,
                  size: 45,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'LOGIN SUCCESS',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        onPressed: () {},
                        child: Text(
                          'OK',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        )),
                    const SizedBox(
                      width: 4,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        barrierDismissible: false);
  }

  static expireLoginDialog(BuildContext context, {String? message,}) async {
    SharedPref.setData(key: SharedPref.token, value: "null");

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            content: Container(
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Warning!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                  ),
                  SizedBox(height: 20),
                  Icon(Icons.info, color: Colors.orangeAccent),
                  SizedBox(height: 20),
                  message == null || message == "" || message == "null"
                      ? Text("Please Login Again")
                      : Text(
                    message!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).then((d) {});
  }

  static Widget SingleChildLoadingWidget(Stream stream, Widget widget, {Widget? loadingWidget}) {
    return StreamBuilder<ResponseOb>(
      stream: stream as Stream<ResponseOb>?,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          if (snapshot.data.chatMessage == MsgState.loading) {
            return loadingWidget == null
                ? Center(
              child: LoadingWidget(),
            )
                : loadingWidget;
          } else {
            return widget;
          }
        }
        return widget;
      },
    );
  }

  static checkError(ResponseOb resp) {
    String error = "Unknown Error";

    if (resp.errState == ErrState.no_internet) {
      error = "No Internet connection! ";
    } else if (resp.errState == ErrState.not_found) {
      error = "Your requested data not found!";
    } else if (resp.errState == ErrState.connection_timeout) {
      error = "Connection Timeout! Try Again";
    } else if (resp.errState == ErrState.too_many_request) {
      error = "Too Many Request! Try Again Later";
    } else if (resp.errState == ErrState.validate_err) {
      var v = json.decode(resp.data);
      error = v['message'].toString();
    } else if (resp.errState == ErrState.server_error) {
      error = "Internal Server Error! Try Again";
    } else if (resp.errState == ErrState.unknown_err) {
      error = "Unknown Error";
    } else {
      error = "Unknown Error";
    }

    AppUtils.showSnackBar(error, color: Colors.red, textColor: Colors.white);
  }

  static String getUserAgent() {
    String? userAgent, webViewUserAgent;
    try {
      if (FkUserAgent.userAgent != null) {
        userAgent = FkUserAgent.userAgent;
      }

      return userAgent!;
      // return await FlutterUserAgent.getPropertyAsync('userAgent');
    } on PlatformException {
      return webViewUserAgent = '<error>';
    }
  }

  //moreState
  static moreResponse(ResponseOb rv, BuildContext context) {
    Map<String, dynamic> myMap = rv.data;

    if (myMap['target'].toString() == "agent_login") {
      AppUtils.expireLoginDialog(context, message: myMap['message'].toString());
    } else if (myMap['target'].toString() == "customer_login") {
      // AppUtils.userDeactivateLogin(context, message: myMap['message'].toString());
      AppUtils.expireLoginDialog(context, message: myMap['message'].toString());
    } else {
      AppUtils.showSnackBar(myMap['message'].toString(), textColor: Colors.white, color: Colors.redAccent);
    }
  }


  static double getSize(BuildContext context, bool isHeight, double value) {
    double size;
    if (isHeight) {
      size = MediaQuery.of(context).size.height * value;
    } else {
      size = MediaQuery.of(context).size.width * value;
    }
    return size;
  }

  // Analytics User Login List
  static List analyticsList = [];

  static addUser(Map<String, dynamic> data) {
    // analyticsList.removeWhere((type) => type['type'] == data['type']);
    if (analyticsList.every((type) => type['type'] != data['type'])) {
      analyticsList.add(data);
    }
    SharedPref.setData(key: SharedPref.analytic_users, value: json.encode(analyticsList));
  }

  static removeUser(Map<String, dynamic> data) {
    analyticsList.removeWhere((type) => type['type'] == data['type']);
    SharedPref.setData(key: SharedPref.analytic_users, value: json.encode(analyticsList));
  }


}

//0975688555
