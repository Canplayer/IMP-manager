// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hnszlyyimp/Page/ClientPage/MissionListView.dart';
import 'package:hnszlyyimp/Widget/AeroBottomNavigationBar.dart';

import '../../client.dart';
import 'NewMissionPage.dart';

class _TabInfo {
  const _TabInfo(this.title, this.icon, this.color, this.widget);

  final String title;
  final IconData icon;
  final Widget widget;
  final Color color;
}

class NormalUserPage extends StatefulWidget {
  const NormalUserPage({Key? key}) : super(key: key);

  @override
  _NormalUserPageState createState() => _NormalUserPageState();
}

class _NormalUserPageState extends State<NormalUserPage> {
  final String _page = '信息处理平台';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final _tabInfo = [
      _TabInfo(
        '报障',
        Icons.announcement,
        Colors.blue,
        Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: MissionListView()),
        )),
      ),
      _TabInfo(
        '个人资料',
        Icons.person,
        Colors.blue,
        MyInfoPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,

        actions: <Widget>[
          IconButton(
            icon: new Container(
              child: ClipOval(
                  child: Image.network(
                    "http://" +
                        Client().ip +
                        ":" +
                        Client().serverPort +
                        "/getAvatar?id=" +
                        isLogin!.id!,
                    fit: BoxFit.cover,
                  )),
            ),
            onPressed: (){
            },
          ),
        ],



        //backgroundColor: Color(0x44000000),
        elevation: 0,
        title: Text("报障平台"),
        foregroundColor: Color.fromARGB(255, 150, 150, 150),
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: "555tt",
        child: Icon(Icons.handyman),
        //Text("报",style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold) ,),
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new NewMissionPage(isLogin!)),
          ).then((value) => {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PageTransitionSwitcher(
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _tabInfo[currentIndex].widget,
      ),

      extendBody: true,
      //extendBodyBehindAppBar: true,
      bottomNavigationBar: AeroBottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                  Container(
                    height: 120,
                    width: 120,
                    child: ClipOval(
                        child: Image.network(
                          "http://" +
                              Client().ip +
                              ":" +
                              Client().serverPort +
                              "/getAvatar?id=" +
                              isLogin!.id!,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Text(isLogin!.username!),
                  SizedBox(
                    height: 20,
                  ),
                  Text(isLogin!.phone!),
                  SizedBox(
                    height: 20,
                  ),
                  Text(isLogin!.department!),
                  SizedBox(
                    height: 20,
                  ),
                  Text(isLogin!.id!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
