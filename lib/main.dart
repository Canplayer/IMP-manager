// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hnszlyyimp/Page/LoginPage.dart';

void main() {
  runApp(LoginPage());
  SystemChrome.setSystemUIOverlayStyle(my);
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
  await DesktopWindow.setWindowSize(Size(480,700));
}
