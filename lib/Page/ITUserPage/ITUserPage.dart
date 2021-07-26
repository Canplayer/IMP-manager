import 'package:flutter/material.dart';

import 'SelfMissionListView.dart';
import 'NewSelfMissionPage.dart';

class ITUserPage extends StatefulWidget {
  const ITUserPage({Key key}) : super(key: key);

  @override
  _ITUserPageState createState() => _ITUserPageState();
}

class _ITUserPageState extends State<ITUserPage> {
  final String _page = '信息人员平台';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
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
            new MaterialPageRoute(
                builder: (context) => new NewSelfMissionPage()),
          ).then((value) => {
                if (value == "refresh")
                  setState(() {

                  })
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
            constraints: BoxConstraints(maxWidth: 500), child: SelfMissionListView()),
      )),
    );
  }
}
