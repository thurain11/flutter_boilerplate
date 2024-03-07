import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../global.dart';
import '../constants/app_constants.dart';
import '../network/dio_basenetwork.dart';
import '../ob/response_ob.dart';
import '../utils/app_utils.dart';

class DataUploadProvider extends ChangeNotifier {
  ResponseOb uploadingResp = ResponseOb();
  DioBaseNetwork _network = DioBaseNetwork();

  double progress = 0;
  Map<String, dynamic>? validateMap = {};
  Map<String, dynamic>? progMap = {};
  // Vimeo vimeo = Vimeo(VIMEO_ACCESS_TOKEN);
  CancelToken? cancelToken;

  PublishSubject<ResponseOb> postController = PublishSubject();

  Stream<ResponseOb> postStream() => postController.stream;

  int indexStart = 0;
  List<Map<String,dynamic>> mediaDataList=[];
  double compressProgress=0;
  bool isVideoCamera = false;

  postData({String? url,
    FormData? fd,
    required List<String?> dataList,
    Map<String, dynamic>? map,
    ReqType requestType = ReqType.Get,
    String? uuid,
    // String? id = '',
    Map<String,dynamic>? progressMap,
    String? tempId = ''
  }) async {
    uploadingResp = ResponseOb(message: MsgState.loading);
    progress = 0;
    progMap = progressMap;
    notifyListeners();
    postController.sink.add(uploadingResp);

    cancelToken = CancelToken();
    if (dataList.length == 0) {
      if(!mediaDataList.any((element) => element['id'] == tempId)){
        mediaDataList.add({
          'id': tempId,
          'progress': 0.0,
          'cancelToken': cancelToken
        });
      }
      notifyListeners();

      _network.dioProgressReq(
          url: "$BASE_URL" + url!,
          fd: fd,
          cancelToken: cancelToken,
          params: map,
          callBack: (ResponseOb rv) {
            if (rv.message == MsgState.data) {

              if (rv.data["result"].toString() == "1") {
                uploadingResp.message = MsgState.data;
                uploadingResp.data = rv.data;
                uploadingResp.tempId = tempId;
                // AppUtils.showSnackChek(rv.data['message'].toString(),
                //     color: Colors.green, textColor: Colors.white, sec: 3);
                indexStart = 1;
                notifyListeners();
                if(tempId!=''){
                  uploadingResp.mode = RefreshUIMode.replaceLocalStorage;
                  // postController.sink.
                }
                postController.sink.add(uploadingResp);

              } else if (rv.data['result'].toString() == "0") {
                uploadingResp.message = MsgState.more;
                uploadingResp.data = rv.data;

                AppUtils.showSnackBar(
                  rv.data['message'].toString(),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                );

                // Fluttertoast.showToast(
                //     msg: '${rv.data['message']}', toastLength: Toast.LENGTH_LONG);
                notifyListeners();
                postController.sink.add(uploadingResp);
              } else {
                uploadingResp = rv;
                notifyListeners();
                postController.sink.add(uploadingResp);
              }
            }else if(rv.message == MsgState.loading){

              uploadingResp.message = MsgState.loading;


            } else {

              if (rv.errState == ErrState.validate_err) {
                uploadingResp.errState = ErrState.validate_err;
                validateMap = json.decode(rv.data)['errors'];
                // AppUtils.showToast(validateMap.toString(), color: Colors.red, textColor: Colors.white, sec: 4);
                if (validateMap!['audio'] != null) {
                  AppUtils.showSnackChek(validateMap!['audio'][0].toString(),
                      color: Colors.red, textColor: Colors.white, sec: 7);
                }

                notifyListeners();
                postController.sink.add(uploadingResp);
              } else {

                uploadingResp = rv;
                notifyListeners();
                postController.sink.add(uploadingResp);
                AppUtils.showSnackChek(rv.data.toString());
              }
            }
          },
          progressCallback: (i) {
            if (i == 1) {
              // AppUtils.showToast("Successfully Uploaded", color: Colors.green, textColor: Colors.white);
            }
            // progress = i;

            int indexToUpdate = mediaDataList.indexWhere((element) => element['id'] == tempId);
            if (indexToUpdate != -1) {
              mediaDataList[indexToUpdate]['progress'] = i;
            }
            notifyListeners();
          });
    } else {
      // await vimeo.uploadVideo(
      //     dataList,
      //         (list) {
      //       List<MapEntry<String, String>> mapList = [];
      //       list.forEach((data) {
      //         mapList.add(MapEntry("videos[]", data));
      //       });
      //
      //       fd!.fields.addAll(mapList);
      //       _network.dioProgressReq(
      //           url: "${BASE_URL}" + url! + id!,
      //           //community-post/store
      //           headerType: headerType,
      //           fd: fd,
      //           cancelToken: cancelToken,
      //           callBack: (ResponseOb rv) {
      //             if (rv.message == MsgState.data) {
      //               if (rv.data["result"].toString() == "1") {
      //                 uploadingResp.message = MsgState.data;
      //                 uploadingResp.data = rv.data;
      //                 notifyListeners();
      //                 postController.sink.add(uploadingResp);
      //
      //                 AppUtils.showSnackChek(rv.data['message'].toString(),
      //                     color: Colors.green, textColor: Colors.white, sec: 7);
      //               } else if (rv.data['result'].toString() == "0") {
      //                 // resp.message = MsgState.more;
      //                 // resp.data = rv.data; //map['message'].toString();
      //                 // controller.sink.add(resp);
      //                 uploadingResp.message = MsgState.more;
      //                 uploadingResp.data = rv.data; //map['message'].toString();
      //                 notifyListeners();
      //                 postController.sink.add(uploadingResp);
      //               } else {
      //                 uploadingResp = rv;
      //                 notifyListeners();
      //               }
      //             } else {
      //               if (rv.errState == ErrState.validate_err) {
      //                 uploadingResp.errState = ErrState.validate_err;
      //                 validateMap = json.decode(rv.data)['errors'];
      //                 notifyListeners();
      //               } else {
      //                 uploadingResp = rv;
      //                 notifyListeners();
      //               }
      //             }
      //           },
      //           progressCallback: (i) {
      //             if (i == 1) {
      //               // AppUtils.showToast("Successfully Uploaded", color: Colors.green, textColor: Colors.white);
      //
      //             }
      //             progress = 0.8 + (i * 0.2);
      //             notifyListeners();
      //           });
      //     },
      //     uuid,
      //     progressCallBack: (i) {
      //       progress = i * 0.8;
      //       notifyListeners();
      //     },
      //     cancelToken: cancelToken);
    }
  }

  postMessageData({
    String? url,
    FormData? fd,
    Map<String, dynamic>? map,
    ReqType requestType = ReqType.Get,
    String? tempId = ''
  }) async {
    uploadingResp = ResponseOb(message: MsgState.loading);
    notifyListeners();
    postController.sink.add(uploadingResp);
    cancelToken = CancelToken();
    _network.dioProgressReq(
        url: BASE_URL + url!,
        fd: fd,
        cancelToken: cancelToken,
        params: map,
        callBack: (ResponseOb rv) {
          if (rv.message == MsgState.data) {
            if (rv.data["result"].toString() == "1") {

              uploadingResp.message = MsgState.data;
              uploadingResp.data = rv.data;
              uploadingResp.tempId = tempId;
              notifyListeners();
              if(tempId!=''){
                uploadingResp.mode = RefreshUIMode.replaceLocalStorage;
              }
              postController.sink.add(uploadingResp);

            } else if (rv.data['result'].toString() == "0") {
              uploadingResp.message = MsgState.more;
              uploadingResp.data = rv.data;
              AppUtils.showSnackBar(
                rv.data['message'].toString(),
                color: Colors.redAccent,
                textColor: Colors.white,
              );
              notifyListeners();
              postController.sink.add(uploadingResp);
            } else {
              uploadingResp = rv;
              notifyListeners();
              postController.sink.add(uploadingResp);
            }
          }else if(rv.message == MsgState.loading){
            uploadingResp.message = MsgState.loading;
          } else {
            if (rv.errState == ErrState.validate_err) {
              uploadingResp.errState = ErrState.validate_err;
              validateMap = json.decode(rv.data)['errors'];
              // AppUtils.showToast(validateMap.toString(), color: Colors.red, textColor: Colors.white, sec: 4);
              if (validateMap!['audio'] != null) {
                AppUtils.showSnackChek(validateMap!['audio'][0].toString(),
                    color: Colors.red, textColor: Colors.white, sec: 7);
              }
              if (validateMap!['description'] != null) {
                AppUtils.showSnackChek(validateMap!['description'][0].toString(),
                    color: Colors.red, textColor: Colors.white, sec: 7);
              }
              if (validateMap!['videos'] != null) {
                AppUtils.showSnackChek(validateMap!['videos'][0].toString(),
                    color: Colors.red, textColor: Colors.white, sec: 7);
              }
              if (validateMap!['photos'] != null) {
                AppUtils.showSnackChek(validateMap!['photos'][0].toString(),
                    color: Colors.red, textColor: Colors.white, sec: 7);
              }
              if (validateMap!['pdf_files'] != null) {
                AppUtils.showSnackChek(validateMap!['pdf_files'][0].toString(),
                    color: Colors.red, textColor: Colors.white, sec: 7);
              }
              if (validateMap!['pdf_files.0'] != null) {
                AppUtils.showSnackChek(validateMap!['pdf_files.0'][0].toString(),
                    color: Colors.red, textColor: Colors.white, sec: 7);
              }
              if (validateMap!['pdf_files.1'] != null) {
                AppUtils.showSnackChek(validateMap!['pdf_files.1'][0].toString(),
                    color: Colors.red, textColor: Colors.white, sec: 7);
              }
              if (validateMap!['pdf_files.2'] != null) {
                AppUtils.showSnackChek(validateMap!['pdf_files.2'][0].toString(),
                    color: Colors.red, textColor: Colors.white, sec: 7);
              }
              if (validateMap!['pdf_files.3'] != null) {
                AppUtils.showSnackChek(validateMap!['pdf_files.3'][0].toString(),
                    color: Colors.red, textColor: Colors.white, sec: 7);
              }
              if (validateMap!['pdf_files.4'] != null) {
                AppUtils.showSnackChek(validateMap!['pdf_files.4'][0].toString(),
                    color: Colors.red, textColor: Colors.white, sec: 7);
              }
              notifyListeners();
              postController.sink.add(uploadingResp);
            } else {
              uploadingResp = rv;
              notifyListeners();
              postController.sink.add(uploadingResp);
              AppUtils.showSnackChek(rv.data.toString());
            }
          }
        },
        progressCallback: (i) {}
    );
  }

  cancelUpload(CancelToken? cancelT) {

    if(cancelT!=null){
      cancelT.cancel();
      notifyListeners();
    }
    // cancelT.cancel();
    // progress = 0;
    // uploadingResp = ResponseOb();
    // notifyListeners();
    // if (cancelToken != null) {
    //   cancelToken!.cancel();
    //   progress = 0;
    //   uploadingResp = ResponseOb();
    //   notifyListeners();
    // }
  }

  doneUploadValidate() {
    if (cancelToken != null) {
      progress = 0;
      uploadingResp = ResponseOb();
      notifyListeners();
    }
  }

  setCompressProgress(double progress){
    compressProgress=progress;
    notifyListeners();
  }

  setIsVideoCamera(bool isVCamera){
    isVideoCamera=isVCamera;
    notifyListeners();
  }
}
