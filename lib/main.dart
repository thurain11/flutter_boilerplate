// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_setup/test_flutter_bloc/counter_cubit.dart';
import 'package:provider/provider.dart';

import 'core/network/http_overwrite.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/theme.dart';
import 'pages/home/home.dart';

GlobalKey<ScaffoldMessengerState> rootScaffoldKey = GlobalKey<ScaffoldMessengerState>();
final navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: [
      Locale('en', 'US'),
      Locale('my', 'MM'),
    ],
    path: "languages",
    fallbackLocale: Locale('en', 'US'),
    saveLocale: true,
  ));
}

/// The main app.
class MyApp extends StatelessWidget {
  final _buildTheme = BuildThemeData();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, ThemeProvider tm, Widget? child) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            themeMode: tm.themeMode,
            scaffoldMessengerKey: rootScaffoldKey,
            debugShowCheckedModeBanner: false,
            theme: FlexThemeData.light(scheme: FlexScheme.brandBlue),
            darkTheme: FlexThemeData.dark(scheme: FlexScheme.brandBlue),
            title: 'Flutter Setup',
            home: MultiProvider(
              providers: [
                BlocProvider<CounterCubit>(
                  create: (BuildContext context) {
                    return CounterCubit();
                  },
                )
              ],
              child: HomePage(),
            ),
          );
        },
      ),
    );
  }
}
