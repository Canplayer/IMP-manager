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
  List opList = [];
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
    var b = await getOPList();
    setState(() {
      myList = a;
      opList = b;
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
    String state = pair.progress!;
    IconData icon;
    String text = "状态未知";
    Color bgColor = Colors.transparent;
    Widget child = SizedBox();
    String opPhone = "";
    switch (state) {
      case '未处理':
        {
          icon = Icons.access_time;
          text = "正在等待受理...";
          bgColor = Color.fromARGB(255, 177, 198, 211);
          child = Row(
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(text, style: TextStyle(color: Colors.white)),
            ],
          );
        }
        break;
      case '已分发':
        {
          icon = Icons.person;
          text = pair.engineer!;
          bgColor = Color.fromARGB(255, 69, 197, 223);
          for (int i = 0; i < opList.length; i++) {
            if (opList[i].name == pair.engineer) {
              opPhone = opList[i].phone;
            }
          }
          ;

          child = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(text,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                        Text("工程师",
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    opPhone == ""
                        ? SizedBox()
                        : Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                    Text(
                      opPhone,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 18,
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "请保持您的电话畅通",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
        }
        break;
      case '已处理':
        {
          icon = icon = Icons.person;
          text = pair.engineer!;
          bgColor = Color.fromARGB(255, 89, 203, 127);
          for (int i = 0; i < opList.length; i++) {
            if (opList[i].name == pair.engineer) {
              opPhone = opList[i].phone;
            }
          }
          child = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\"" + pair.solution! + "\"",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 15,
                      color: Colors.white,
                    ),
                    Text(text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    opPhone == ""
                        ? SizedBox()
                        : Icon(
                            Icons.phone,
                            size: 15,
                            color: Colors.white,
                          ),
                    Text(
                      opPhone,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // TextButton.icon(
                      //   style: ButtonStyle(
                      //     foregroundColor:
                      //         MaterialStateProperty.all(Colors.white),
                      //   ),
                      //   onPressed: () {},
                      //   icon: Icon(Icons.not_interested_rounded),
                      //   label: Text("未解决"),
                      // ),
                      // SizedBox(
                      //   width: 8,
                      // ),
                      TextButton.icon(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () {
                          setNormalUserMissionDone(pair.id!);
                        },
                        icon: Icon(Icons.done),
                        label: Text("完成订单"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        break;
      case '已完成':
        {
          icon = Icons.done_all;
          text = "订单已完成";
          child = Row(
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10,
              ),
              Text(text, style: TextStyle(color: Colors.grey,)),
            ],
          );
        }
        break;
      default:
        {
          icon = Icons.voice_over_off_sharp;
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
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 150, 150, 150),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      pair.describe!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
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
                color: bgColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: child,
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
