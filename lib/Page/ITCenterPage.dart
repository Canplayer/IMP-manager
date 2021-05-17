// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:hnszlyyimp/Page/View/PList.dart';

import 'NewMissionPage.dart';

class _TabInfo {
  const _TabInfo(this.title, this.icon, this.widget);

  final String title;
  final IconData icon;
  final Widget widget;
}

class ITCenterPage extends StatelessWidget {
  const ITCenterPage({Key key}) : super(key: key);
  final String _Page = 'IT服务台';

  @override
  Widget build(BuildContext context) {

    final _tabInfo = [
      _TabInfo(
        '列表',
        Icons.list,
        SizedBox(),
      ),
      _TabInfo(
        '个人资料',
        Icons.person,
        SizedBox(),
      ),
    ];


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(_Page),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new ImagePickerPage()),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: PList(),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            for (final tabInfo in _tabInfo)
            BottomNavigationBarItem(icon: Icon(tabInfo.icon),label: tabInfo.title  )
          ],
        ),
      ),
    );
  }
}
