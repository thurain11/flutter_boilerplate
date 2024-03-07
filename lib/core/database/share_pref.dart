import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const isNightMode = "isNightMode";
  static const phone = "phone";
  static const version = "version";
  static const language = "language";
  static const token = "token";
  static const loan_officer_token = "loan_officer_token";
  static const profile = "profile";
  static const theme = "theme";
  static const session_key = "session_key";
  static const recent = "recent";
  static const player_id = "player_id";
  static const analytic_users = "analytic_users";
  static const device_id = "device_id";
  static const is_noti_subscribe = "is_noti_subscribe";
  static const loan_repay_web_url = "loan_repay_web_url";
  static const owner_id = "owner_id";
  static const chat_list_data = "chat_list_data";

//  static Future<bool> setData({String key, String value}) async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
//    pref.setString(key, value);
//    pref.commit();
//    return true;
//  }
//
//  static Future<String> getData({String key}) async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
//    return pref.getString(key);
//  }

  static Future<bool> setData({required String key, required String value}) async {
    // KeyUtils ku = KeyUtils();
    SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setString(KeyUtils.doEncrypt(key), KeyUtils.doEncrypt(value)); // do
    pref.setString(key, value);
    pref.commit();
    return true;
  }

  static Future<String> getData({required String key}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? str = pref.getString(key); // do encrypt
    if (str == "null" || str == null) {
      return "null";
    }
    // return KeyUtils.doDecrypt(str);
    return str;
  }

  static Future<bool> setString({required String key, required String value}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
    pref.commit();
    return true;
  }

  static Future<String> getString({required String key}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? str = pref.getString(key);
    if (str == "null" || str == null) {
      return "null";
    }
    return str;
  }

  static Future<bool> setStringList({required String key, required List<String> value}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setStringList(key, value);
  }

  static Future<List<String>?> getStringList({required String key}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList(key);
  }

  static Future<bool> setBool({required String key, required bool value}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(key, value);
  }

  static Future<bool?> getBool({required String key}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key);
  }

  static Future<bool> clearRecent({required String key}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }
}
