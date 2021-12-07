import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    int thisWeekAccount = 0;
    if (myList.length != 0) {
      for (int i = 0; myList[i].isThisWeek; i++) {
        thisWeekAccount++;
      }
      return RefreshIndicator(
        onRefresh: loadData,
        child: ListView.builder(
          itemCount: myList.length + 2,
          itemBuilder: (BuildContext context, int position) {
            if (position == 0) return Container(
                color: Color.fromARGB(255, 0, 176, 159),
                height: 120,
                padding: EdgeInsets.fromLTRB(20, 10, 00, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "本周已录 ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          thisWeekAccount.toString(),
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          " 条数据",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(width: 30,),
                        SvgPicture.asset(
                          "res/img_working.svg",
                          fit: BoxFit.fill,
                          height: 110,
                        )
                      ],
                    ),

                  ],
                ),
              );
            if (position == myList.length + 1) return Container(
              height: 50,
              alignment: Alignment.center,
              child: Text("此处最多展示一个月的数据: "+myList.length.toString(),style: TextStyle(fontSize: 12,color: Colors.black54),),
            );
            return _buildRow(myList[position - 1]);
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),

      child: Container(
        constraints: BoxConstraints(maxWidth: 200),
        child: Card(
          color: pair.isThisWeek! ? Colors.white : Colors.white70,
          child: InkWell(
            splashColor: Colors.redAccent.withAlpha(255),
            onTap: () {},
            onLongPress: () {
              _showMyDialog(pair);
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                size: 12,
                                color: Color.fromARGB(255, 150, 150, 150)),
                            Text(pair.department!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 150, 150, 150))),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.person,
                                size: 12,
                                color: Color.fromARGB(255, 150, 150, 150)),
                            Text(pair.name!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 150, 150, 150))),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: Color.fromARGB(255, 150, 150, 150),
                            ),
                            Text(pair.date!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 150, 150, 150))),
                            SizedBox(
                              width: 10,
                            ),
                            if (pair.phone!.length != 0)
                              Icon(
                                Icons.phone,
                                size: 15,
                                color: Color.fromARGB(255, 150, 150, 150),
                              ),
                            Text(pair.phone!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 150, 150, 150))),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              pair.type!,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
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
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              pair.solution!,
                              style: TextStyle(fontSize: 12),
                            ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
}
