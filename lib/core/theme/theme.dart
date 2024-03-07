import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../global.dart';


class BuildThemeData {
  // double fs140 = 140.0;
  // double fs28 = 26.0;
  // double fs24 = 23.0;
  // double fs22 = 22.0;
  // double fs20 = 20.0;
  // double fs18 = 18.0;
  // double fs17 = 17.0;
  // double fs16 = 14.0;
  // double fs15 = 15.0;
  // double fs14 = 13.0;
  // double fs13 = 15.0;
  // double fs12 = 16.0;
  // double fs11 = 15.0;
  // double fs10 = 15.0;
//0xfff1361b4
  var lightCardColor = Color(0xff1e272e);
  var lightScaffoldColor = Color(0xff485460);
//4db6ac
  ThemeData firstTD(String str) {
    return ThemeData(
        splashColor: Colors.transparent,
        useMaterial3: true,
        dialogBackgroundColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
        ),
        popupMenuTheme: PopupMenuThemeData(
            textStyle: TextStyle(color: Colors.black45),

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        appBarTheme: AppBarTheme(

          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Color(0xfff1361b4),
            // Status bar brightness (optional)
            statusBarIconBrightness: Brightness.light, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          color: Color(0xffFAF9F6), //4db6ac
          elevation: 0.0,
          titleTextStyle: TextStyle(fontSize: 17, fontFamily: str, color: Color(0xfff1361b4)),
          iconTheme: IconThemeData(color: Color(0xfff1361b4)),
          actionsIconTheme: const IconThemeData(color: Color(0xff1361b4)),
        ),
        fontFamily: str,
        scaffoldBackgroundColor: Colors.grey.shade100, //F0F5F9
        // 0xfff2f4ff
        // canvasColor: Color(0xFFffffff),
        cardColor: const Color(0xFFFFFFFF),
        // indicatorColor: const Color(0xFFFFFFee),
        dividerColor: Colors.grey.shade300,
        tabBarTheme: TabBarTheme(
          labelColor: Color(0xfff1361b4),
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Color(0xfff1361b4)),
          ),
        ),
        // primaryColor: Color(0xff1361b4),
        colorScheme:  ColorScheme(
          primary: Color(0xff1361b4),
          onSurface: Color(0xff3286DD),
          brightness: Brightness.light,
          onBackground: Color(0xff3286DD),
          onSecondary: Color(0xfffefae0),
          surface: Color(0xff3286DD),
          error: Colors.redAccent,
          background: Color(0xFFFFFFFF),
          onPrimary: Color(0xff1361b4),
          onError: Colors.redAccent,
          secondary: Color(0xfffefae0),
        ),
        brightness: Brightness.light,
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
        textTheme: TextTheme(
          headline2:
          // GoogleFonts.notoSansMyanmar(),
          TextStyle(
            fontFamily: str,
            color: Color(0xfff1361b4),
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
          headline3:
          // GoogleFonts.notoSansMyanmar(),
          TextStyle(
            fontFamily: str,
            color: Colors.black,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
          headline4:
          // GoogleFonts.notoSansMyanmar(),
          TextStyle(
            fontFamily: str,
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
          headline5:
          // GoogleFonts.notoSansMyanmar(),
          TextStyle(
            fontFamily: str,
            color: Color(0xff1361b4),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          headline6:
          // GoogleFonts.notoSansMyanmar(),
          TextStyle(
            fontFamily: str,
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          subtitle1:
          // GoogleFonts.notoSansMyanmar(),
          TextStyle(
            fontFamily: str,
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          caption:
          // GoogleFonts.notoSansMyanmar(),
          TextStyle(
            fontFamily: str,
            color: Colors.grey.shade700,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          subtitle2:
          // GoogleFonts.notoSansMyanmar(),
          TextStyle(
            fontFamily: str,
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          bodyText1:
          // GoogleFonts.notoSansMyanmar(),
          TextStyle(fontFamily: str, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
          bodyText2:
          // GoogleFonts.notoSansMyanmar(),
          TextStyle(fontFamily: str, color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        listTileTheme: ListTileThemeData(iconColor: Color(0xff1361b4)),
        primaryIconTheme: const IconThemeData(color: Color(0xff1361b4)),
        iconTheme: IconThemeData(color: Color(0xfff1361b4)),
        // buttonTheme: ButtonThemeData(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(5),
        //   ),
        //   buttonColor: Color(0xfff1361b4),
        //   textTheme: ButtonTextTheme.normal,
        // ),
        // textButtonTheme: TextButtonThemeData(
        //   style: ButtonStyle(
        //     textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16, fontFamily: str)),
        //   ),
        // ),
        // outlinedButtonTheme: OutlinedButtonThemeData(
        //   style: ButtonStyle(
        //     shape: MaterialStateProperty.all(
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        //     ),
        //     padding: MaterialStateProperty.all(
        //       EdgeInsets.symmetric(vertical: 8),
        //     ),
        //     textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16, fontFamily: str)),
        //   ),
        // ),

        // iconTheme: const IconThemeData(color: Color(0xfffefae0)),
        cupertinoOverrideTheme: CupertinoThemeData(
            primaryColor: Color(0xfff1361b4),
            primaryContrastingColor: Color(0xfff1361b4),
            textTheme: CupertinoTextThemeData(
              actionTextStyle: const TextStyle(
                inherit: false,
                color: Color(0xfff1361b4),
              ),
              navLargeTitleTextStyle: TextStyle(
                inherit: false,
                fontSize: 25,
                color: Color(0xfff1361b4),
                fontWeight: FontWeight.bold,
                fontFamily: str,
              ),
              // primaryColor: Color(0xfff1361b4),
              navTitleTextStyle: TextStyle(
                inherit: false,
                fontSize: 18,
                color: Color(0xfff1361b4),
                fontWeight: FontWeight.bold,
                fontFamily: str,
              ),
            ),
            scaffoldBackgroundColor: Colors.white,
            barBackgroundColor: Colors.white,
            brightness: Brightness.light),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black45),
          // border: UnderlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black45)
          // )
        )
      // inputDecorationTheme: InputDecorationTheme(focusedBorder:
      // OutlineInputBorder(borderSide: BorderSide(color: Color(0xfff1361b4), width: 1.2), borderRadius: BorderRadius.circular(8)),hintStyle: TextStyle(fontWeight: FontWeight.w500),labelStyle: TextStyle(fontWeight: FontWeight.w500))
    );
  }

  var cardColor = Color(0xff141d26);
  var scaffoldColor = Color(0xff243447);
  var dividerColor = Color(0xff2d445b);

  ThemeData darkTheme(String str) {
    return ThemeData(
      cardTheme: CardTheme(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          color: cardColor,
          clipBehavior: Clip.antiAlias),
      popupMenuTheme: PopupMenuThemeData(

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      appBarTheme: AppBarTheme(
        // brightness: Brightness.dark,
        color: cardColor,
        // textTheme: TextTheme(headline6: TextStyle(fontSize: 17, fontFamily: str, color: Colors.white)),
        iconTheme: IconThemeData(color: Color(0xfff1361b4)),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      fontFamily: str,
      scaffoldBackgroundColor: scaffoldColor,
      primarySwatch: Colors.indigo,
      primaryColor: Color(0xFF1B56AF),
      //0xff05A677
      // AppBar and Icon
      // accentColor: Color(0xfff1361b4),
      canvasColor: cardColor,
      cardColor: cardColor,
      // cardColor: Color(0xff2d132c),
      // buttonColor: Color(0xfff1361b4),
      indicatorColor: Color(0xFFFFFFee),
      // dividerColor: Colors.grey.shade300,
      dividerColor: dividerColor,
      //Color(0xFF35343a),
      brightness: Brightness.dark,
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
      textTheme: TextTheme(
        headline2: TextStyle(
          fontFamily: str,
          color: Color(0xfff1361b4),
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
        headline3: TextStyle(
          fontFamily: str,
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
        headline4: TextStyle(
          fontFamily: str,
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        headline5: TextStyle(
          fontFamily: str,
          color: Color(0xfff1361b4),
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        headline6: TextStyle(
          fontFamily: str,
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        subtitle1: TextStyle(
          fontFamily: str,
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        subtitle2: TextStyle(
          fontFamily: str,
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        caption: TextStyle(
          fontFamily: str,
          color: Color(0xffa4b0be),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        bodyText1: TextStyle(
          fontFamily: str,
          color: Colors.white,
          fontSize: 15,
        ),
        bodyText2: TextStyle(
          fontFamily: str,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      unselectedWidgetColor: Colors.white,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.normal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        buttonColor: Color(0xff1361b4),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      primaryIconTheme: IconThemeData(color: Colors.white),
      // hintColor: Color(0xff747d8c),
      inputDecorationTheme: InputDecorationTheme(
        prefixStyle: TextStyle(
          color: Colors.white,
        ),
        labelStyle: TextStyle(
          color: Color(0xfff1361b4),
        ),
        // hintStyle: TextStyle(
        //   color: Color(0xff747d8c),
        // ),
      ),
      dialogBackgroundColor: Color(0xff1e272e),
      cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: Color(0xfff1361b4),
          primaryContrastingColor: Colors.white,
          textTheme: CupertinoTextThemeData(
            actionTextStyle: TextStyle(
              inherit: false,
              color: Colors.white,
            ),
            navLargeTitleTextStyle: TextStyle(
              inherit: false,
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: str,
            ),
            primaryColor: Color(0xfff1361b4),
            navTitleTextStyle: TextStyle(
              inherit: false,
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: str,
            ),
          ),
          scaffoldBackgroundColor: Color(0xffff2f4ff),
          barBackgroundColor: cardColor,
          brightness: Brightness.dark),
      // accentIconTheme: IconThemeData(color: Colors.white)
    );
  }
}
