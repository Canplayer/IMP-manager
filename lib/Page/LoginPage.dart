import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hnszlyyimp/Page/WelcomePage.dart';
import 'package:hnszlyyimp/client.dart';
import 'package:lottie/lottie.dart';

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

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var _titleID = new TextEditingController();
  var _titlePass = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> _login() async {
      if (_titleID.text != '' && _titlePass.text != '') {
        Future a = login(_titleID.text, _titlePass.text);
        a.then((value) {
          Navigator.of(context).pop();
          if (value == 1) {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new WelcomePage()),
            );
          } else {
            return showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('登陆失败'),
                  content: SingleChildScrollView(
                    child: Text('错误代码:反正就是失败了'),
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
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('res/logoAnim.json',
                    width: 100, height: 100, repeat: false),
                Text("用户名和密码千万不能为空 :<"),
              ],
            )));
      }
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
              child:
                  //Image.asset('res/logo.png'),
                  Lottie.asset('res/logoAnim.json'),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _titleID,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'No.'),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _titlePass,
              obscureText: true,
              onSubmitted: (value){
                _login();
              },
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
                    _login();
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
            // Container(
            //   child: SizedBox(
            //     width: 300,
            //     height: 50,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           new MaterialPageRoute(
            //               builder: (context) => new NewUserPage()),
            //         );
            //       },
            //       child: Text(
            //         '注册',
            //         style: TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
