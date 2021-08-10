import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../client.dart';
import '../../model.dart';

class MissionListView extends StatefulWidget {
  const MissionListView({Key? key}) : super(key: key);
  @override
  _MissionListViewState createState() => _MissionListViewState();
}

class _MissionListViewState extends State<MissionListView> {
  List myList = [];
  int? listLength;
  Timer? timer;
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
    var a = await getNormalUserMission();
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
      return Row(
        children: [
          Text("这里乜都冇啊~"),
          CircularProgressIndicator(),
        ],
      );
    }
  }

  Future<void> _showMyDialog(MissionModel pair) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('长按...'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('您即将删除:'+ pair.describe!+pair.id!),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('删除'),
              onPressed: () {
                print("删除按钮被点击了"+pair.id!);
                Future a = delITUserSelfMission(pair.id!);
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

  Widget _buildRow(MissionModel pair) {
    String a =pair!.progress!;
    IconData b;
    switch(a){
      case '未完成': {b=Icons.access_time;}break;
      case '已分发': {b=Icons.assignment_ind;}break;
      case '已处理': {b=Icons.done;}break;
      case '已完成': {b=Icons.done_all;}break;
      default:{b=Icons.voice_over_off_sharp;}
    }
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
                    Text(pair!.date!),
                    Row(
                      children: [
                        Text(
                          pair!.type!,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          pair!.describe!,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(pair!.solution!),
                      ],
                    ),
                  ],
                ),
                Icon(
                  b,
                  size: 40,
                  color: Colors.black12,
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
