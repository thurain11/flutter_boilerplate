
import 'package:dio/dio.dart';
import 'package:flutter_setup/layers/data/api/api.dart';
import 'package:get_it/get_it.dart';

import '../../layers/data/respositories/post_repo.dart';

var getIt = GetIt.instance;

void locator(){

  getIt.registerLazySingleton<Api>(() => Api());
  getIt.registerLazySingleton<PostRepo>(() => PostRepo());


}