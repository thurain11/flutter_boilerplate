import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../database/share_pref.dart';
import '../ob/response_ob.dart';
import '../utils/app_utils.dart';


class DioBaseNetwork {
  Future<Map<String, String?>> getHeader() async {
    String os = "";

    if (Platform.isIOS) {
      os = "ios";
    } else if (Platform.isAndroid) {
      os = "android";
    }

    String ss = await SharedPref.getData(key: SharedPref.language);
    if (ss == "null") {
      ss = "en";
    } else if (ss == "en") {
      ss = 'en';
    } else if (ss == "mm") {
      ss = 'mm';
    }

    return {
      // "customer-destination-id": await SharedPref.getData(key: SharedPref.shop_city),
      "Authorization": await SharedPref.getData(key: SharedPref.token)??'',
      "Accept": "application/json",
      "language": ss,
      "version-ios": NOW_VERSION_IOS,
      "version-android": NOW_VERSION_ANDROID,
      "operating-system": os,
      "gen-ios": GEN_NUMBER_IOS,
      "gen-android": GEN_NUMBER_ANDROID,
      "X-Socket-ID": "456928633.667692454",
      // "guard-token": await SharedPref.getData(key: SharedPref.gift_token),
      "User-Agent": AppUtils.getUserAgent(),
      // "super-market-guard-token": await SharedPref.getData(key: SharedPref.super_market_token),
      // "supermarket-selected-order-type": await SharedPref.getData(key: SharedPref.order_type_value),
      // "device-id": await SharedPref.getData(key: SharedPref.device_id)
    };
  }


  // Dio _client;

  // Dio get client => _client;

  void getReq(String url,
      {
        Map<String, dynamic>? params,
        required callBackFunction callBack}) async {
    dioReq(ReqType.Get,  url: url, params: params, callBack: callBack);
  }

  // Post
  void postReq(String url,
      {
        Map<String, dynamic>? map,
        FormData? fd,
        required callBackFunction callBack}) async {
    dioReq(ReqType.Post,
        url: url, params: map, fd: fd, callBack: callBack);
  }

  Future<void> dioReq(ReqType? rt,
      {
        required String url,
        Map<String, dynamic>? params,
        FormData? fd,
        required callBackFunction callBack,
        bool? isCached = false}) async {

    BaseOptions options = BaseOptions();


    options.headers = await getHeader();

    Dio dio = new Dio(options);

    dio.interceptors.add(LogInterceptor(
        responseBody: true, requestBody: true, requestHeader: true, responseHeader: true));

    if (isCached == true) {
      // dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: url,)).interceptor);
    }

    try {
      Response response;
      if (rt == ReqType.Get) {
        if (params == null) {
          response =
          await dio.get(url);
        } else {
          response = await dio.get(url,
              queryParameters: params,);
        }
      }else if (rt == ReqType.Put) {
        if (params == null) {
          response = await dio.put(url);
        } else {
          response = await dio.put(url, queryParameters: params);
        }
      } else if (rt == ReqType.Delete) {
        if (params == null) {
          response = await dio.delete(url);
        } else {
          response = await dio.delete(url, queryParameters: params);
        }
      } else {
        if (params != null || fd != null) {
          response = await dio.post(url, data: fd ?? params);

        } else {
          response = await dio.post(url);
        }
      }

      int? statusCode = response.statusCode;
      ResponseOb respOb = ResponseOb(); //data,message,err

      if (statusCode == 200) {

        respOb.message = MsgState.data;
        respOb.data = response.data;
      } else {
        respOb.message = MsgState.error;
        respOb.data = "Unknown error";
        respOb.errState = ErrState.unknown_err;
      }
      callBack(respOb);
    } on DioError catch (e) {
      ResponseOb respOb = new ResponseOb();

      if (e.response != null) {
        if (e.response!.statusCode == 422) {
          respOb.message = MsgState.error;
          respOb.data = e.response.toString();
          respOb.errState = ErrState.validate_err;
        } else if (e.response!.statusCode == 500) {
          respOb.message = MsgState.error;
          respOb.data = "Internal Server Error";
          respOb.errState = ErrState.server_error;
        } else if (e.response!.statusCode == 503) {
          respOb.message = MsgState.error;
          respOb.data = "System Maintenance";
          respOb.errState = ErrState.server_maintain;
        } else if (e.response!.statusCode == 404) {
          respOb.message = MsgState.error;
          respOb.data = "Your requested data not found";
          respOb.errState = ErrState.not_found;
        } else if (e.response!.statusCode == 401) {
          respOb.message = MsgState.error;
          respOb.data = e.response!.data ?? "You need to Login";
          respOb.errState = ErrState.no_login;
        } else if (e.response!.statusCode == 429) {
          respOb.message = MsgState.error;
          respOb.data = "Too many request error";
          respOb.errState = ErrState.too_many_request;
        } else {
          if (e.toString().contains('SocketException')) {
            respOb.message = MsgState.error;
            respOb.data = "No internet connection";
            respOb.errState = ErrState.no_internet;
          } else {
            respOb.message = MsgState.error;
            respOb.data = "Unknown error";
            respOb.errState = ErrState.unknown_err;
          }
        }
      } else {
        if (e.toString().contains('SocketException')) {
          respOb.message = MsgState.error;
          respOb.data = "No internet connection";
          respOb.errState = ErrState.no_internet;
        } else {
          respOb.message = MsgState.error;
          respOb.data = "Unknown error";
          respOb.errState = ErrState.unknown_err;
        }
      }
      callBack(respOb);
    }
  }

  Future<void> dioProgressReq(
      {
        required String url,
        Map<String, dynamic>? params,
        FormData? fd,
        required callBackFunction callBack,
        ProgressCallbackFunction? progressCallback,
        CancelToken? cancelToken}) async {
    BaseOptions options = BaseOptions();


    options.headers = await getHeader();

    Dio dio = new Dio(options);

    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    //   client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };

    try {
      Response response;
      response = await dio.post(url, data: fd ?? params, onSendProgress: (int nowData, int totalData) {

        progressCallback!(nowData / totalData);
      }, cancelToken: cancelToken);

      int? statusCode = response.statusCode;

      ResponseOb respOb = ResponseOb(); //data,message,err

      if (statusCode == 200) {
        respOb.message = MsgState.data;
        respOb.data = response.data;
      } else {
        respOb.message = MsgState.error;
        respOb.data = "Unknown error";
        respOb.errState = ErrState.unknown_err;
      }
      callBack(respOb);
    } on DioError catch (e) {
      ResponseOb respOb = new ResponseOb();

      if (e.response != null) {
        if (e.response!.statusCode == 422) {
          respOb.message = MsgState.error;
          respOb.data = e.response.toString();
          respOb.errState = ErrState.validate_err;
        } else if (e.response!.statusCode == 500) {
          respOb.message = MsgState.error;
          respOb.data = "Internal Server Error";
          respOb.errState = ErrState.server_error;
        } else if (e.response!.statusCode == 404) {
          respOb.message = MsgState.error;
          respOb.data = "Your requested data not found";
          respOb.errState = ErrState.not_found;
        } else if (e.response!.statusCode == 401) {
          respOb.message = MsgState.error;
          respOb.data = "You need to login";
          respOb.errState = ErrState.no_login;
        } else if (e.response!.statusCode == 429) {
          respOb.message = MsgState.error;
          respOb.data = "Too many request error";
          respOb.errState = ErrState.too_many_request;
        } else {
          if (e.toString().contains('SocketException')) {
            respOb.message = MsgState.error;
            respOb.data = "No internet connection";
            respOb.errState = ErrState.no_internet;
          } else {
            respOb.message = MsgState.error;
            respOb.data = "Unknown error";
            respOb.errState = ErrState.unknown_err;
          }
        }
      } else {
        if (e.toString().contains('SocketException')) {
          respOb.message = MsgState.error;
          respOb.data = "No internet connection";
          respOb.errState = ErrState.no_internet;
        } else {
          respOb.message = MsgState.error;
          respOb.data = "Unknown error";
          respOb.errState = ErrState.unknown_err;
        }
      }
      callBack(respOb);
    }
  }
}

enum ReqType { Get, Post, Delete ,Put}

typedef callBackFunction(ResponseOb ob);
typedef ProgressCallbackFunction(double i);

// enum HeaderType { Normal, VerifyToken }
