import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../Widget/PlasticsCard.dart';
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Icon(Icons.layers_clear,size: 150,color: Colors.black12,),
          SvgPicture.asset(
            "res/img_engineer.svg",
            fit: BoxFit.fill,
            height: 200,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "这里乜都冇",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 80, 80, 80)),
          ),
          Text(
            "点击下方 ↓ 的锤子报修",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Color.fromARGB(255, 100, 100, 100)),
          ),
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
      child: PlasticsCard(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            _showMyDialog(pair);
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pair.type!,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 150, 150, 150)),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      pair.describe!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    //详细小标识
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 15,
                            color: Color.fromARGB(255, 150, 150, 150)),
                        Text(pair.department!,
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 150, 150, 150))),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.person,
                            size: 15,
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
                          size: 15,
                          color: Color.fromARGB(255, 150, 150, 150),
                        ),
                        Text(pair.date!,
                            style: TextStyle(
                                fontSize: 12,
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
                                fontSize: 12,
                                color: Color.fromARGB(255, 150, 150, 150))),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
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
                  ],
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
              Container(
                color: Colors.grey,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        b,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(c,
                          style: TextStyle(
                              color: Colors.white)),
                    ],
                  ),
                ),
                //               if (pair.solution! != "")
                //     Column(
                //     children: [
                //     SizedBox(
                //     height: 4,
                //   ),
                //   Text(pair.solution!),
                //   ],
                // ),
              ),
            ],
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
