import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../client.dart';
import '../../model.dart';

class SelfMissionListView extends StatefulWidget {
  const SelfMissionListView({Key? key}) : super(key: key);
  @override
  _SelfMissionListViewState createState() => _SelfMissionListViewState();
}

class _SelfMissionListViewState extends State<SelfMissionListView> {
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

  Future<void> loadData() async {
    var a = await getITUserSelfMission();
    setState(() {
      myList = a;
    });
  }

  Widget _buildSuggestions() {
    if (myList.length != 0) {
      return RefreshIndicator(
        onRefresh: loadData,
        child: ListView.builder(
          itemCount: myList.length,
          itemBuilder: (BuildContext context, int position) {
            return _buildRow(myList[position]);
          },
        ),
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
                Text('您即将删除:' + pair.describe! + pair.id!),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('删除'),
              onPressed: () {
                print("删除按钮被点击了" + pair.id!);
                Future a = delITUserSelfMission(pair.id!);
                a.then((value) {
                  if (value == 1) {
                    Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('res/doneAnim.json',
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
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {},
        onLongPress: () {
          _showMyDialog(pair);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Container(
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.done,
                  size: 30,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 15,
                              color: Color.fromARGB(255, 150, 150, 150)),
                          Text(pair.department!,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150))),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.person,
                              size: 15,
                              color: Color.fromARGB(255, 150, 150, 150)),
                          Text(pair.name!,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150))),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.access_time,
                            size: 15,
                            color: Color.fromARGB(255, 150, 150, 150),
                          ),
                          Text(pair.date!,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150))),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.phone,
                            size: 15,
                            color: Color.fromARGB(255, 150, 150, 150),
                          ),
                          Text(pair.phone!,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150))),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            pair.type!,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              pair.describe!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Text(pair.solution!),
                        ],
                      ),
                    ],
                  ),
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
