import 'package:flutter/material.dart';
import 'package:hnszlyyimp/Page/LoginPage/RegisterPage.dart';
import 'package:lottie/lottie.dart';

import '../../client.dart';
import 'WelcomePage.dart';

class LoginPage extends StatefulWidget {
  final BuildContext fatherContext;
  LoginPage(this.fatherContext, {Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _titleID = new TextEditingController();
  var _titlePass = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<void> _login() async {
      if (_titleID.text != '' && _titlePass.text != '') {
        Future a = login(_titleID.text, _titlePass.text);
        a.then((value) {
          Navigator.of(widget.fatherContext).pop();
          if (value == 1) {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new WelcomePage(widget.fatherContext)),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('res/doneAnim.json',
                    width: 100, height: 100, repeat: false),
                Text("用户名和密码千万不能为空 :<"),
              ],
            )));
      }
    }

    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 120,
              width: 360,
              child:
//Image.asset('res/logo.png'),
              Lottie.asset('res/logoAnim.json'),
            ),
            Text("BETA",
              style: TextStyle(
                color: Colors.black26,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: _titleID,
              decoration:
              InputDecoration(border: OutlineInputBorder(), labelText: 'No.'),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: _titlePass,
              obscureText: true,
              onSubmitted: (value) {
                _login();
              },
              decoration:
              InputDecoration(border: OutlineInputBorder(), labelText: '密码'),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(StadiumBorder(
                      side: BorderSide(color: Colors.transparent),
                    )),
                  ),
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
              height: 30,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("尚未拥有账号？那请"),
                SizedBox(width: 10,),
                OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(StadiumBorder(
                        side: BorderSide(
                          color: Colors.transparent,
                        ))),
                  ),
                  onPressed: () {

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return RegisterPage(widget.fatherContext);
                    },
                    fullscreenDialog: false));
                  },
                  child: Text(
                    '注册',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
