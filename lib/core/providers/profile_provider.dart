// import 'dart:convert';
//
// import '../../global.dart';
// import '../constants/app_constants.dart';
// import '../database/share_pref.dart';
// import '../network/dio_basenetwork.dart';
// import '../ob/response_ob.dart';
// import '../utils/app_utils.dart';
//
//
// class LoginProvider extends ChangeNotifier {
//   ResponseOb profileResponse = ResponseOb();
//   MyProfileData? profileData;
//   DioBaseNetwork _network = DioBaseNetwork();
//   bool isBirthday = false;
//   bool isLogin = false;
//   bool isStuff = false;
//   bool isMicrofinance = false;
//
//   LoginProvider.initialize() {
//     SharedPref.getData(key: SharedPref.token).then((data) {
//       if (data != "null" && data != "" && data!=null) {
//         isLogin = true;
//         getUserProfileData(isRefresh: false);
//       } else {
//         profileData = null;
//         isLogin = false;
//       }
//       notifyListeners();
//     });
//   }
//
//   getUserProfileData({bool isRefresh = true, bool cache = false}) async {
//     profileResponse = ResponseOb(message: MsgState.loading, data: null);
//     if (isRefresh) {
//       notifyListeners();
//     }
//
//     if (cache) {
//       SharedPref.getData(key: SharedPref.profile).then((data) {
//         if (data != "null") {
//           MyProfileOb userOb = MyProfileOb.fromJson(json.decode(data));
//           profileResponse.message = MsgState.data;
//           profileResponse.data = userOb.data;
//           profileData = userOb.data;
//           // SharedPref.setData(key: SharedPref.owner_id, value: profileData!.id ?? "");
//           notifyListeners();
//         }
//       });
//     }
//
//     try {
//       _network.getReq(BASE_URL + 'chat/profile', callBack: (rv) {
//         if (rv.message == MsgState.data) {
//           // Map<String, dynamic> map = json.decode(rv.data);
//           if (rv.data['result'] == 1) {
//             // UserProfileOb userOb = UserProfileOb.fromJson(rv.data['data']);
//             MyProfileOb userOb = MyProfileOb.fromJson(rv.data);
//
//             SharedPref.setData(key: SharedPref.profile, value: json.encode(rv.data));
//             // SharedPref.setData(
//             //     key: SharedPref.owner_id,
//             //     value: userOb.data == null ? "" : userOb.data!.id.toString());
//             // save into local to get user for analytic
//             AppUtils.addUser(
//                 {"auth_id": userOb.data!.id, "source_name": userOb.data!.name, "type": "customer"});
//
//             profileResponse.message = MsgState.data;
//             profileResponse.data = userOb.data;
//             profileData = userOb.data;
//
//             // SharedPref.setData(
//             //     key: SharedPref.owner_id, value: profileData!.id.toString() ?? '');
//
//             notifyListeners();
//           } else {
//             profileResponse.message = MsgState.more;
//             profileResponse.data = rv.data;
//             notifyListeners();
//           }
//         } else {
//           if (rv.errState == ErrState.no_login) {
//             // SharedPreferences.getInstance().then((shp) {
//             //   shp.clear();
//             // });
//             isLogin = false;
//             profileData = null;
//             notifyListeners();
//           }
//
//           if (rv.errState == ErrState.no_internet) {
//             SharedPref.getData(key: SharedPref.profile).then((data) {
//               if (data != "null") {
//                 MyProfileOb userOb = MyProfileOb.fromJson(json.decode(data));
//                 profileResponse.message = MsgState.data;
//                 profileResponse.data = userOb.data;
//                 profileData = userOb.data;
//                 notifyListeners();
//               } else {
//                 profileResponse = rv;
//                 notifyListeners();
//               }
//             });
//           } else {
//             profileResponse = rv;
//             notifyListeners();
//           }
//         }
//       });
//     } catch (e) {
//       profileResponse.message = MsgState.error;
//       profileResponse.data = "Unknown Error";
//       profileResponse.errState = ErrState.unknown_err;
//       notifyListeners();
//     }
//   }
//
//   ResponseOb deliRespObj = ResponseOb();
//
//   checkLogin() {
//     SharedPref.getData(key: SharedPref.token).then((value) {
//       if (value != "null") {
//         isLogin = true;
//         notifyListeners();
//       } else {
//         profileData = null;
//         isLogin = false;
//         notifyListeners();
//       }
//     });
//   }
//
//   void showFinishBirthday() {
//     isBirthday = false;
//     notifyListeners();
//   }
//
//   void dispose() {}
// }
//
