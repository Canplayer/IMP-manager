// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hnszlyyimp/Page/LoginPage.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

void main() {
  runApp(LoginPage());
  SystemChrome.setSystemUIOverlayStyle(my);
  WidgetsFlutterBinding.ensureInitialized();
  Acrylic.initialize();
  DesktopWindowFunctions();
}
const SystemUiOverlayStyle my = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarDividerColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);
Future DesktopWindowFunctions() async{
  if (Platform.isWindows) {
    doWhenWindowReady(() {
      final win = appWindow;
      final initialSize = Size(600, 900);
      win.minSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = "Custom window with Flutter";
      win.show();
    });
  }
}
