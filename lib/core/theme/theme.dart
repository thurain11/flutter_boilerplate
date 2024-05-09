import 'package:hexcolor/hexcolor.dart';

import '../../global.dart';

class BuildThemeData {
  Color lightPrimaryColor = HexColor('#19bc99');
  Color darkPrimaryColor = HexColor('#1f9b71');

  var lightCardColor = Color(0xff1e272e);
  var lightScaffoldColor = Color(0xff485460);

  var cardColor = Color(0xff141d26);
  var scaffoldColor = Color(0xff243447);
  var dividerColor = Color(0xff2d445b);

//4db6ac
  ThemeData firstTD({String str = ''}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light().copyWith(
        primary: Color(0xff19bc99),
        brightness: Brightness.light,
        onPrimary: Color(0xffffffff),
        primaryContainer: Color(0xfff0a4cd),
        onPrimaryContainer: Color(0xff042100),
        secondary: Color(0xff4c5262),
        onSecondary: Color(0xffffffff),
        secondaryContainer: Color(0xffd9e7cb),
        onSecondaryContainer: Color(0xff131f0d),
        tertiary: Color(0xff386667),
        onTertiary: Color(0xffffffff),
        tertiaryContainer: Color(0xffbbebeb),
        onTertiaryContainer: Color(0xff002021),
        error: Color(0xffba1b1b),
        onError: Color(0xffffffff),
        errorContainer: Color(0xffffdad4),
        onErrorContainer: Color(0xff410001),
        outline: Color(0xff74796e),
        background: Color(0xfffdfdf6),
        onBackground: Color(0xff1a1c18),
        surface: Color(0xfffdfdf6),
        onSurface: Color(0xff1a1c18),
        surfaceVariant: Color(0xffdfe4d6),
        onSurfaceVariant: Color(0xff43493e),
        inverseSurface: Color(0xff2f312c),
        onInverseSurface: Color(0xfff1f1ea),
        inversePrimary: Color(0xffd67d9f),
        shadow: Color(0xff000000),
        surfaceTint: Color(0xff386a20),
      ),
      brightness: Brightness.light,
      // colorScheme: ColorScheme(
      //     primary: Color(0xff2754c7),
      //     onPrimary: Color(0xffffffff),
      //     primaryContainer: Color(0xffc0f0a4),
      //     onPrimaryContainer: Color(0xff042100),
      //     secondary: Color(0xff55624c),
      //     onSecondary: Color(0xffffffff),
      //     secondaryContainer: Color(0xffd9e7cb),
      //     onSecondaryContainer: Color(0xff131f0d),
      //     tertiary: Color(0xff386667),
      //     onTertiary: Color(0xffffffff),
      //     tertiaryContainer: Color(0xffbbebeb),
      //     onTertiaryContainer: Color(0xff002021),
      //     error: Color(0xffba1b1b),
      //     onError: Color(0xffffffff),
      //     errorContainer: Color(0xffffdad4),
      //     onErrorContainer: Color(0xff410001),
      //     outline: Color(0xff74796e),
      //     background: Color(0xfffdfdf6),
      //     onBackground: Color(0xff1a1c18),
      //     surface: Color(0xfffdfdf6),
      //     onSurface: Color(0xff1a1c18),
      //     surfaceVariant: Color(0xffdfe4d6),
      //     onSurfaceVariant: Color(0xff43493e),
      //     inverseSurface: Color(0xff2f312c),
      //     onInverseSurface: Color(0xfff1f1ea),
      //     inversePrimary: Color(0xff9cd67d),
      //     shadow: Color(0xff000000),
      //     surfaceTint: Color(0xff386a20),
      //     brightness: Brightness.light),
    );
  }

  ThemeData darkTheme({String str = ''}) {
    return ThemeData(
      useMaterial3: true,
      // colorScheme: const ColorScheme.light().copyWith(primary: BuildThemeData().darkPrimaryColor),
      brightness: Brightness.dark,
    );
  }
}
