import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../client.dart';
import '../../model.dart';

class ITCenterMissionListView extends StatefulWidget {
  final String data;
  ITCenterMissionListView(this.data, {Key? key}) : super(key: key);
  @override
  _ITCenterMissionListViewState createState() =>
      _ITCenterMissionListViewState();
}

class _ITCenterMissionListViewState extends State<ITCenterMissionListView> {
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
    var a = await getITCenterMission(widget.data);
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
            "暂无",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 80, 80, 80)),
          ),
        ],
      );

      //LinearProgressIndicator();
    }
  }

  Future<void> _showMyDialog(MissionModel pair) async {
    var ts = TextStyle(
      fontSize: 13,
          color: Color.fromARGB(255, 100, 100, 100),
    );
    var b = await getOPList();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('详细信息'),
          content: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Image.network(
                        "http://"+Client().ip+":"+Client().serverPort+"/ClientPic?id=" + pair.id!,
                    ),
                    Text("id：" + pair.id!,style: ts,),
                    Text("发起人:" + pair.name!,style: ts,),
                    Text("发起人联系手机:" + pair.phone!,style: ts,),
                    Text("发起日期:" + pair.date!,style: ts,),
                    Text("部门/位置:" + pair.department!,style: ts,),
                    Text("故障类型:" + pair.type!,style: ts,),
                    Text("描述:" + pair.describe!,style: ts,),
                    Text("受理工程师:" + pair.engineer!,style: ts,),
                    Text("解决方案：" + pair.solution!,style: ts,),
                    Text("处理进度：" + pair.progress!,style: ts,),

                  ],
                ),
              ),
              Expanded(
                child: Wrap(
                  children: List<Widget>.generate(b.length, (index) =>
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: ChoiceChip(
                          label: Text(b[index].name! ),
                          selected: pair.engineer==b[index].name!,
                          onSelected: (bool selected) {
                            // setState(() {
                            //   //_value = selected ? index : null;
                            // });
                            Navigator.of(context).pop();
                            setITCenterMissionO2OP(pair.id!,b[index].id!);
                          },
                        ),
                      ),

                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('关闭'),
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
    switch (a) {
      case '未完成':
        {
          b = Icons.access_time;
        }
        break;
      case '已分发':
        {
          b = Icons.assignment_ind;
        }
        break;
      case '已处理':
        {
          b = Icons.done;
        }
        break;
      case '已完成':
        {
          b = Icons.done_all;
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
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(
                        b,
                        size: 30,
                        color: Colors.green,
                      ),
                      Text(pair.engineer!)
                    ],
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
                            if(pair.phone! != "")
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
                                maxLines: 4,
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
                            Text(pair.solution!,
                                maxLines: 4, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        Image.network(
                            "http://"+Client().ip+":"+Client().serverPort+"/ClientPic?id=" + pair.id!,
                        ),
                      ],
                    ),
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
