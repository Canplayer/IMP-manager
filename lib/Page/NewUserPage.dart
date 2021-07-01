import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../client.dart';

class NewUserPage extends StatefulWidget {
  const NewUserPage({Key key,int a}) : super(key: key);

  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {


  Future<void> _showMyDialog() async {
    // Future a = addNewReport();
    // a.then((value) {
    //   Navigator.of(context).pop();
    //   if (value == 1) {
    //     Navigator.pop(context);
    //   }
    //   else{}
    // });

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
      appBar: AppBar(title: Text('新建任务')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                            border: OutlineInputBorder(), labelText: '工号'),
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
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: '手机'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: '邮箱'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: '密码'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: '确认密码'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        child: Icon(Icons.done),
                        onPressed: () {
                          _showMyDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}