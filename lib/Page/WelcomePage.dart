import 'package:flutter/material.dart';
import 'package:hnszlyyimp/Page/NormalUserPage.dart';

import '../client.dart';
import 'ITCenterPage.dart';
import 'ITUserPage/ITUserPage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key key}) : super(key: key);

  static const String _title = '身份选择页面';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '欢迎回来,'+isLogin.username,
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(
              height: 30,
            ),
            Card(
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ITCenterPage()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.work_outline),
                      title: Text('【还没做！】我是IT服务台'),
                      subtitle: Text('【还没做！】面向信息总台的选项'),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ITUserPage()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.all_inclusive),
                      title: Text('我是信息部人员'),
                      subtitle: Text('面向信息部人员的派发平台'),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new NormalUserPage()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.warning_amber_rounded),
                      title: Text('【还没做！】我要报障'),
                      subtitle: Text('【还没做！】面对医院员工的报障选项'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
