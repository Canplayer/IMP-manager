// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hnszlyyimp/Page/ITCenterPage/ITCenterMissionListView.dart';
import 'package:hnszlyyimp/Page/View/PList.dart';

import '../../client.dart';
import '../ClientPage/NewMissionPage.dart';

class _TabInfo {
  const _TabInfo(this.title, this.icon, this.color, this.widget);

  final String title;
  final IconData icon;
  final Widget widget;
  final Color color;
}

class ITCenterPage extends StatefulWidget {
  const ITCenterPage({Key? key}) : super(key: key);

  @override
  _ITCenterPageState createState() => _ITCenterPageState();
}

class _ITCenterPageState extends State<ITCenterPage> {
  final String _page = 'IT服务台';
  int? currentIndex;

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
        Icons.access_time,
        Colors.blueGrey,
        Center(
            key: ValueKey('1'),
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Container(
                  constraints: BoxConstraints(maxWidth: 500), child: ITCenterMissionListView("SDFAULTORDER")),
            )),
      ),
      _TabInfo(
        '已分发',
        Icons.assignment_ind,
        Colors.blue,
        Center(
            key: ValueKey('2'),
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Container(
                  constraints: BoxConstraints(maxWidth: 500), child: ITCenterMissionListView("OPFAULTORDER")),
            )),
      ),
      _TabInfo(
        '已处理',
        Icons.done,
        Colors.teal,
        Center(
          key: ValueKey('3'),
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Container(
                  constraints: BoxConstraints(maxWidth: 500), child: ITCenterMissionListView("SDFAULTORDERHANDLED")),
            )),
      ),
      _TabInfo(
        '已完成',
        Icons.done_all,
        Colors.greenAccent,
        Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Container(
                  constraints: BoxConstraints(maxWidth: 500), child: ITCenterMissionListView("SDFAULTORDERDONE")),
            )),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_page),
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _tabInfo[currentIndex!].widget,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (final tabInfo in _tabInfo)
            BottomNavigationBarItem(
                icon: Icon(tabInfo.icon),
                label: tabInfo.title,
                backgroundColor: tabInfo.color)
        ],
        //type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex!,
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


class MyInfoPage extends StatelessWidget {
  const MyInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        child: Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    size: 100,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '报障人'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '电话号码'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '科室'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('123'),
                              action: SnackBarAction(
                                label: '897ad8',
                                onPressed: (){},
                              ),
                            ),
                          );
                        },
                        child: Text(
                          '提交',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
