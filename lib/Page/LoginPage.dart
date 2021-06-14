import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hnszlyyimp/Page/NewUserPage.dart';
import 'package:hnszlyyimp/Page/WelcomePage.dart';
import 'package:hnszlyyimp/client.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  static const String _title = '登录页面';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: const Body(),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      Future a = login('123', '123');
      a.then((value) {
        Navigator.of(context).pop();
        if (value == 1) {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new WelcomePage()),
          );
        }
        else{}
      });

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('正在登陆'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  LinearProgressIndicator(),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 150,
                width: 150,
                child: Image.asset('res/logo.png'),),
            SizedBox(
              height: 30,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'No.'),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: '密码'),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _showMyDialog();
                    // Navigator.push(
                    //   context,
                    //   new MaterialPageRoute(
                    //       builder: (context) => new WelcomePage()),
                    // );
                  },
                  child: Text(
                    '登陆',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new NewUserPage()),
                    );
                  },
                  child: Text(
                    '注册',
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
    );
  }
}

