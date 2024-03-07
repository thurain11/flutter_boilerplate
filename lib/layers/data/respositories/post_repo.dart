
import 'package:dio/dio.dart';
import 'package:flutter_setup/core/utils/logger.dart';
import 'package:flutter_setup/layers/data/api/api.dart';
import 'package:flutter_setup/layers/data/models/posts.dart';

class PostRepo {
   Api api = Api();

   Future<List<PostOb>> getPosts() async {
     try{
     Response response =  await api.sendReq.get('/posts');
        wLog(response.realUri);
        vLog(response.headers);
        iLog(response.data);

        List<dynamic> postMap = response.data;
        return postMap.map(( e) => PostOb.fromJson(e)).toList();
     }catch( ex){
       eLog(ex.toString());
       throw Exception(ex.toString());
     }

   }


}