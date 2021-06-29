// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:hnszlyyimp/Page/View/PList.dart';

import '../NewMissionPage.dart';

class _TabInfo {
  const _TabInfo(this.title, this.icon, this.color, this.widget);

  final String title;
  final IconData icon;
  final Widget widget;
  final Color color;
}

class ITCenterPage extends StatefulWidget {
  const ITCenterPage({Key key}) : super(key: key);

  @override
  _ITCenterPageState createState() => _ITCenterPageState();
}

class _ITCenterPageState extends State<ITCenterPage> {
  final String _page = 'IT服务台';
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final _tabInfo = [
      _TabInfo(
        '未处理',
        Icons.list,
        Colors.blue,
        Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Container(
                  constraints: BoxConstraints(maxWidth: 500), child: PList()),
            )),
      ),
      _TabInfo(
        '已处理',
        Icons.done,
        Colors.blue,
        Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Container(
                  constraints: BoxConstraints(maxWidth: 500), child: PList()),
            )),
      ),
      _TabInfo(
        '已分发',
        Icons.account_tree_outlined,
        Colors.blue,
        Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Container(
                  constraints: BoxConstraints(maxWidth: 500), child: PList()),
            )),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_page),
      ),
      body: _tabInfo[currentIndex].widget,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (final tabInfo in _tabInfo)
            BottomNavigationBarItem(
                icon: Icon(tabInfo.icon),
                label: tabInfo.title,
                backgroundColor: tabInfo.color)
        ],
        //type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (index) {
          _changePage(index);
        },
      ),
    );
  }

  void _changePage(int index) {
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    }
  }
}

// class ITCenterPage extends StatelessWidget {
//   const ITCenterPage({Key key}) : super(key: key);
//   final String _Page = 'IT服务台';
//
//   @override
//   Widget build(BuildContext context) {
//
//     final _tabInfo = [
//       _TabInfo(
//         '列表',
//         Icons.list,
//         SizedBox(),
//       ),
//       _TabInfo(
//         '个人资料',
//         Icons.person,
//         SizedBox(),
//       ),
//     ];
//
//
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(_Page),
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.add),
//           onPressed: (){
//             Navigator.push(
//               context,
//               new MaterialPageRoute(
//                   builder: (context) => new NewMissionPage()),
//             );
//           },
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         //body: PList(),
//         bottomNavigationBar: BottomNavigationBar(
//           items: [
//             for (final tabInfo in _tabInfo)
//             BottomNavigationBarItem(icon: Icon(tabInfo.icon),label: tabInfo.title  )
//           ],
//           onTap: (index){
//             _changePage(index);
//           },
//         ),
//       );
//   }
//
//   void _changePage(int index) {}
// }
