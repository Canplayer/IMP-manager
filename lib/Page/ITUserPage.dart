import 'package:flutter/material.dart';
import 'package:hnszlyyimp/Page/NewMissionPage.dart';

import 'View/PList.dart';

class _TabInfo {
  const _TabInfo(this.title, this.icon, this.color, this.widget);

  final String title;
  final IconData icon;
  final Widget widget;
  final Color color;
}

class ITUserPage extends StatefulWidget {
  const ITUserPage({Key key}) : super(key: key);

  @override
  _ITUserPageState createState() => _ITUserPageState();
}

class _ITUserPageState extends State<ITUserPage> {
  final String _page = '信息人员平台';
  int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_page),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new NewMissionPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
            constraints: BoxConstraints(maxWidth: 500), child: PList()),
      )),
    );
  }

}
