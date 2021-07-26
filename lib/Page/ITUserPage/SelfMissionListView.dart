import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../client.dart';
import '../../model.dart';

class SelfMissionListView extends StatefulWidget {
  const SelfMissionListView({Key key}) : super(key: key);
  @override
  _SelfMissionListViewState createState() => _SelfMissionListViewState();
}

class _SelfMissionListViewState extends State<SelfMissionListView> {
  List myList = [];
  int listLength;
  Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => loadData());
    loadData();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  loadData() async {
    var a = await getITUserSelfMission();
    setState(() {
      myList = a;
    });
  }

  Widget _buildSuggestions() {
    if (myList.length != 0) {
      return ListView.builder(
        itemCount: myList.length,
        itemBuilder: (BuildContext context, int position) {
          return _buildRow(myList[position]);
        },
      );
    } else {
      return LinearProgressIndicator();
    }
  }

  Future<void> _showMyDialog(SelfMissionModel pair) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('长按...'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('您即将删除:' + pair.describe+pair.id),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('删除'),
              onPressed: () {
                print("删除按钮被点击了"+pair.id);
                Future a = delITUserSelfMission(pair.id);
                a.then((value) {
                  if (value == 1) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('res/logoAnim.json',
                            width: 100, height: 100, repeat: false),
                        Text("操作成功~"),
                      ],
                    )));
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('res/logoAnim.json',
                            width: 100, height: 100, repeat: false),
                        Text("操作失败~"),
                      ],
                    )));
                  }
                });
              },
            ),
            TextButton(
              child: Text('不要啊!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRow(SelfMissionModel pair) {
    return Container(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          onLongPress: () {
            _showMyDialog(pair);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(pair.department),
                        SizedBox(
                          width: 10,
                        ),
                        Text(pair.name),
                        SizedBox(
                          width: 10,
                        ),
                        Text(pair.date),
                        SizedBox(
                          width: 10,
                        ),
                        Text(pair.phone),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          pair.type,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          pair.describe,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(pair.solution),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.done,
                  size: 40,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
}
