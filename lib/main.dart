// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_setup/pages/home/home.dart';
import 'package:flutter_setup/layers/data/respositories/post_repo.dart';

import 'core/network/http_overwrite.dart';
import 'core/routes/routes.dart';

GlobalKey<ScaffoldMessengerState> rootScaffoldKey = GlobalKey<ScaffoldMessengerState>();
final navigatorKey = new GlobalKey<NavigatorState>();


void main() async {

  PostRepo repo = PostRepo();
  repo.getPosts();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  runApp(
    EasyLocalization(child: MyApp(),
      supportedLocales: [
      Locale('en', 'US'),
      Locale('my', 'MM'),
    ],
      path: "languages",
      fallbackLocale: Locale('en', 'US'),
      saveLocale: true,)
  );
}


/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      scaffoldMessengerKey: rootScaffoldKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Setup',
      home: HomePage(),
      // routerConfig: router,
    );
  }
}




