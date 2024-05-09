import '../../global.dart';
import '../database/share_pref.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  checkTheme() {
    SharedPref.getString(key: SharedPref.theme).then((value) {
      if (value != "null") {
        if (value == "light") {
          themeMode = ThemeMode.light;
          notifyListeners();
        } else if (value == "dark") {
          themeMode = ThemeMode.dark;
          notifyListeners();
        } else {
          themeMode = ThemeMode.system;
          notifyListeners();
        }
      }
    });
  }

  changeToDark() {
    SharedPref.setString(key: SharedPref.theme, value: "dark");

    themeMode = ThemeMode.dark;
    notifyListeners();
  }

  changeToLight() {
    SharedPref.setString(key: SharedPref.theme, value: "light");

    themeMode = ThemeMode.light;

    notifyListeners();
  }

  changeToSystem() {
    SharedPref.setString(key: SharedPref.theme, value: "system");

    themeMode = ThemeMode.system;

    notifyListeners();
  }
}
