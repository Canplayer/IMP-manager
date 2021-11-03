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

  Future<void> loadData() async {
    var a = await getNormalUserMission();
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
          title: Text('详细信息'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.network(
                  'http://10.10.142.77:8081/ClientPic?id=' + pair.id!,
                ),
                Text("id：" + pair.id!),
                Text("发起人:" + pair.name!),
                Text("发起人联系手机:" + pair.phone!),
                Text("发起日期:" + pair.date!),
                Text("部门/位置:" + pair.department!),
                Text("故障类型:" + pair.type!),
                Text("描述:" + pair.describe!),
                Text("受理工程师:" + pair.engineer!),
                Text("解决方案：" + pair.solution!),
                Text("处理进度：" + pair.progress!),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('好'),
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
    String a = pair.progress!;
    IconData b;
    String c = "状态未知";
    switch (a) {
      case '未处理':
        {
          b = Icons.access_time;
          c = "正在等待受理...";
        }
        break;
      case '已分发':
        {
          b = Icons.assignment_ind;
          c = "工程师 " + pair.engineer! + " 正在为您处理";
        }
        break;
      case '已处理':
        {
          b = Icons.done;
          c = "工程师给出处理意见，请您确认";
        }
        break;
      case '已完成':
        {
          b = Icons.done_all;
          c = "订单已完成";
        }
        break;
      default:
        {
          b = Icons.voice_over_off_sharp;
        }
    }
    return Container(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            _showMyDialog(pair);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
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
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 150,
                    ),
                    child: Image.network(
                      'http://10.10.142.77:8081/ClientPic?id=' + pair.id!,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        b,
                        size: 30,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(c,
                          style: TextStyle(
                              color: Color.fromARGB(255, 150, 150, 150))),
                    ],
                  ),
                  if (pair.solution! != "")
                    Column(
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        Text(pair.solution!),
                      ],
                    ),
                ],
              ),
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(pair.date!),
            //         Row(
            //           children: [
            //             Text(
            //               pair.type!,
            //               style: TextStyle(
            //                   fontSize: 17, fontWeight: FontWeight.w700),
            //             ),
            //             SizedBox(
            //               width: 10,
            //             ),
            //             Text(
            //               pair.describe!,
            //               style: TextStyle(
            //                   fontSize: 17, fontWeight: FontWeight.w700),
            //             ),
            //           ],
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: [
            //             Text(pair.solution!),
            //           ],
            //         ),
            //       ],
            //     ),
            //     Icon(
            //       b,
            //       size: 40,
            //       color: Colors.black12,
            //     ),
            //   ],
            // ),
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
