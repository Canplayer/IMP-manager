import 'dart:ui';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hnszlyyimp/Page/LoginPage/WelcomePage.dart';
import 'package:hnszlyyimp/client.dart';
import 'package:lottie/lottie.dart';

import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const String _title = '登录页面';

  // @override
  // void initState() {
  //   super.initState();
  //   this.setWindowEffect();
  // }
  // void setWindowEffect() {
  //   Acrylic.setEffect(effect: AcrylicEffect.acrylic, gradientColor: Platform.isWindows ? Colors.white.withOpacity(0.7) : Colors.white);
  // }

  XFile? _background;

  @override
  void initState() {
    super.initState();
    //getBackground().then((value) => _background = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      body: Container(
        child: Center(
          //可裁切的矩形
          child: Container(
            child: ClipRRect(
              //背景过滤器
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                child: SizedBox(
                  height: 500,
                  width: 500,
                  child: Container(
                    color: Color.fromARGB(180, 255, 255, 255),
                    child: Center(
                      child: Body(),
                    ),
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(20, 0, 0, 0),
                      offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                      blurRadius: 30.0, //阴影模糊程度
                      spreadRadius: 0.0 //阴影扩散程度
                      )
                ]),
          ),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new NetworkImage("http://10.10.142.77:8081/GetPic"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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

    return SizedBox(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 120,
            width: 120,
            child:
//Image.asset('res/logo.png'),
                Lottie.asset('res/logoAnim.json'),
          ),
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
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new NewUserPage()),
                  );
                },
                child: Text(
                  '注册',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
