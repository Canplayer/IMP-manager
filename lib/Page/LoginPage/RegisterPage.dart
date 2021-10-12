import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../client.dart';

class RegisterPage extends StatefulWidget {
  var fatherContext;
  RegisterPage(this.fatherContext, {Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _titleID = new TextEditingController();
  var _titleName = new TextEditingController();
  var _titleDep = new TextEditingController();
  var _titlePhone = new TextEditingController();
  var _titleEmail = new TextEditingController();
  var _titlePass = new TextEditingController();
  var _titlePass2 = new TextEditingController();

  Future<void> _showMyDialog() async {
    Future a = register(_titleID.text, _titleName.text, _titleDep.text,
        _titlePhone.text, _titleEmail.text, _titlePass.text);
    a.then((value) {
      Navigator.of(widget.fatherContext).pop();
      if (value == 1) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('res/doneAnim.json',
                width: 100, height: 100, repeat: false),
            Text("操作成功~"),
          ],
        )));
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
          title: Text('正在提交'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('新用户注册')),
        body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    size: 100,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _titleID,
                          inputFormatters: <TextInputFormatter>[
                            //FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: '工号'),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _titleName,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: '名字'),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _titleDep,
                          decoration: InputDecoration(
                              //errorText: "123123123",
                              border: OutlineInputBorder(),
                              labelText: '科室'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _titlePhone,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: '手机'),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _titleEmail,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: '邮箱'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _titlePass,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '密码'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _titlePass2,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '确认密码'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.done),
                    onPressed: () {
                      if ((_titleID.text.isNotEmpty &&
                              _titleDep.text.isNotEmpty &&
                              _titleEmail.text.isNotEmpty &&
                              _titlePhone.text.isNotEmpty &&
                              _titlePass.text.isNotEmpty) &&
                          (_titlePass.text == _titlePass2.text))
                        _showMyDialog();
                      else
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.indigo,
                            content: Text("检查一下！压根没填好好不好？")));
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
