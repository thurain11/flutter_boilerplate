import 'package:flutter/material.dart';
// import 'package:star_fish/localization/app_translation.dart';

extension ContextExt on BuildContext {
  Future<T?> to<T extends Object>(Widget widget, {bool fullscreenDialog = false}) async {
    return await Navigator.of(this).push<T>(MaterialPageRoute(
        builder: (BuildContext context) {
          return widget;
        },
        fullscreenDialog: fullscreenDialog));
  }

  void back<T extends Object>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  Future<T?> offAll<T extends Object>(Widget widget) async {
    return await Navigator.of(this).pushAndRemoveUntil<T>(MaterialPageRoute(builder: (BuildContext context) {
      return widget;
    }), (route) => false);
  }

  Future<T?> off<T extends Object, TO extends Object>(Widget widget) async {
    // return await Navigator.of(this).pushAndRemoveUntil<T(MaterialPageRoute(builder: (BuildContext context) {
    //   return widget;
    // }), (route) => false);

    return await Navigator.of(this).pushReplacement<T, TO>(MaterialPageRoute(builder: (BuildContext context) {
      return widget;
    }));
  }

  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  Size get size => MediaQuery.of(this).size;

  // String toTrans(String txt) => AppTranslations.of(this)!.trans(txt);
}
