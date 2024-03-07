
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
class Api {

  Dio _dio = Dio();

  Api(){
    _dio.options.baseUrl = "https://jsonplaceholder.typicode.com";
    _dio.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

  }

  Dio get sendReq => _dio;

}