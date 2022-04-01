import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../Widget/AeroBottomNavigationBar.dart';
import '../../client.dart';

class RegisterPage extends StatefulWidget {
  final fatherContext;
  RegisterPage(this.fatherContext, {Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<DropdownMenuItem<String>> DepartmentItems = [];
  var _titleDep = '其他';

//读取部门列表
  loadDepartmentList() async {
    List<DropdownMenuItem<String>> items = [];
    var a = await getDepartmentList();
    a.data!.forEach((element) {
      print(element);
      items.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });
    setState(() {
      _titleDep = a.data![0];
      DepartmentItems = items;
    });
  }

  @override
  void initState() {
    super.initState();
    loadDepartmentList();
  }

  var _titleID = new TextEditingController();
  var _titleName = new TextEditingController();
  var _titlePhone = new TextEditingController();
  var _titleEmail = new TextEditingController();
  var _titlePass = new TextEditingController();
  var _titlePass2 = new TextEditingController();

  Future<void> _showMyDialog() async {
    Future a = register(_titleID.text, _titleName.text, _titleDep,
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

  int page = 0;
  @override
  Widget build(BuildContext context) {
    final _tabInfo = [
      _registerTab(
          "1",
          "我们需要知道\n你是谁?",
          "res/img_IDCard.svg",
          Column(
            children: [
              TextField(
                controller: _titleID,
                inputFormatters: <TextInputFormatter>[
                  //FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: '工号'),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
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
                    child: DropdownButton<String>(
                      value: _titleDep,
                      isExpanded: true,
                      disabledHint: Text('暂不可用'),
                      items: DepartmentItems,
                      onChanged: (String? value) {
                        print(value);
                        setState(() {
                          _titleDep = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                  isExtended: false,
                  child: Icon(Icons.chevron_right),
                  onPressed: () {
                    if ((_titleID.text.isNotEmpty &&
                        _titleDep.isNotEmpty &&
                        _titleName.text.isNotEmpty))
                      setState(() {
                        page++;
                      });
                    else
                      ScaffoldMessenger.of(widget.fatherContext).showSnackBar(
                          SnackBar(
                              backgroundColor: Colors.indigo,
                              content: Text("您填写有疏漏")));
                  }),
            ],
          )),
      _registerTab(
          "2",
          "如何联系到您?",
          "res/img_userInfo.svg",
          Column(
            children: [
              TextField(
                controller: _titlePhone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: '手机'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _titleEmail,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: '邮箱'),
              ),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                  isExtended: false,
                  child: Icon(Icons.chevron_right),
                  onPressed: () {
                    if ((_titlePhone.text.isNotEmpty &&
                        _titleEmail.text.isNotEmpty))
                      setState(() {
                        page++;
                      });
                    else
                      ScaffoldMessenger.of(widget.fatherContext).showSnackBar(
                          SnackBar(
                              backgroundColor: Colors.indigo,
                              content: Text("您填写有疏漏")));
                  }),
            ],
          )),
      _registerTab(
          "3",
          "设定密码",
          "res/img_password.svg",
          Column(
            children: [
              TextField(
                controller: _titlePass,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: '密码'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _titlePass2,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: '确认密码'),
              ),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                  isExtended: false,
                  child: Icon(Icons.done),
                  onPressed: () {
                    if ((_titlePass.text.isNotEmpty &&
                            _titlePass2.text.isNotEmpty) &&
                        (_titlePass.text == _titlePass2.text))
                      setState(() {
                        _showMyDialog();
                      });
                    else
                      ScaffoldMessenger.of(widget.fatherContext).showSnackBar(
                          SnackBar(
                              backgroundColor: Colors.indigo,
                              content: Text("您填写有疏漏")));
                  }),
            ],
          )),
    ];

    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Container(
          color: Theme.of(context).colorScheme.primary,
          height: 200,
        ),
        PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
              fillColor: Colors.transparent,
            );
          },
          child: _tabInfo[page],
        ),
        Align(
          alignment: FractionalOffset(-0.04,-0.04),

          child: SizedBox(
            width: 100,
            height: 100,
            child: InkWell(
              child: SvgPicture.asset("res/back_btn.svg", color: Colors.white54),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    );
    ;
  }

  Widget _registerTab(String key, String text, String img, Widget widget) {
    double height = 220;
    return Column(
      key: ValueKey(key),
      children: [
        Container(
          height: height,
          child: Stack(
            children: [
              // Column(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         color: Theme.of(context).colorScheme.primary,
              //       ),
              //     ),
              //     SizedBox(
              //       height: 20,
              //     )
              //   ],
              // ),
              Align(
                alignment: FractionalOffset.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SvgPicture.asset(
                    img, //"res/img_IDCard.svg",
                    height: height - 30,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              Align(
                alignment: FractionalOffset.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35, left: 20),
                  child: Text(
                    text,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.all(50), child: widget),
      ],
    );

    // Column(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     Row(
    //       children: [
    //         SizedBox(
    //           width: 50,
    //           height: 50,
    //           child: InkWell(
    //             child: SvgPicture.asset("res/back_btn.svg",
    //                 color: Colors.teal),
    //             onTap: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ),
    //         SizedBox(
    //           width: 10,
    //         ),
    //         Text(
    //           "注册",
    //           style: TextStyle(
    //               fontSize: 50, color: Color.fromARGB(255, 60, 60, 60)),
    //         )
    //       ],
    //     ),
    //     SizedBox(
    //       height: 40,
    //     ),
    //     Row(
    //       children: <Widget>[
    //         Expanded(
    //           child: TextField(
    //             controller: _titleID,
    //             inputFormatters: <TextInputFormatter>[
    //               //FilteringTextInputFormatter.digitsOnly,
    //               LengthLimitingTextInputFormatter(5),
    //             ],
    //             decoration: InputDecoration(
    //                 border: OutlineInputBorder(), labelText: '工号'),
    //           ),
    //         ),
    //         SizedBox(
    //           width: 20,
    //         ),
    //         Expanded(
    //           child: TextField(
    //             controller: _titleName,
    //             decoration: InputDecoration(
    //                 border: OutlineInputBorder(), labelText: '名字'),
    //           ),
    //         ),
    //         SizedBox(
    //           width: 20,
    //         ),
    //         Expanded(
    //           child: DropdownButton<String>(
    //             value: _titleDep,
    //             isExpanded: true,
    //             disabledHint: Text('暂不可用'),
    //             items: DepartmentItems,
    //             onChanged: (String? value) {
    //               print(value);
    //               setState(() {
    //                 _titleDep = value!;
    //               });
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //     SizedBox(
    //       height: 10,
    //     ),
    //     Row(
    //       children: <Widget>[
    //         Expanded(
    //           child: TextField(
    //             controller: _titlePhone,
    //             inputFormatters: <TextInputFormatter>[
    //               FilteringTextInputFormatter.digitsOnly,
    //             ],
    //             decoration: InputDecoration(
    //                 border: OutlineInputBorder(), labelText: '手机'),
    //           ),
    //         ),
    //         SizedBox(
    //           width: 20,
    //         ),
    //         Expanded(
    //           child: TextField(
    //             controller: _titleEmail,
    //             decoration: InputDecoration(
    //                 border: OutlineInputBorder(), labelText: '邮箱'),
    //           ),
    //         ),
    //       ],
    //     ),
    //     SizedBox(
    //       height: 10,
    //     ),
    //     TextField(
    //       controller: _titlePass,
    //       obscureText: true,
    //       decoration: InputDecoration(
    //           border: OutlineInputBorder(), labelText: '密码'),
    //     ),
    //     SizedBox(
    //       height: 10,
    //     ),
    //     TextField(
    //       controller: _titlePass2,
    //       obscureText: true,
    //       decoration: InputDecoration(
    //           border: OutlineInputBorder(), labelText: '确认密码'),
    //     ),
    //     SizedBox(
    //       height: 30,
    //     ),
    //     FloatingActionButton(
    //       child: Icon(Icons.done),
    //       onPressed: () {
    //         if ((_titleID.text.isNotEmpty &&
    //             _titleDep.isNotEmpty &&
    //             _titleEmail.text.isNotEmpty &&
    //             _titlePhone.text.isNotEmpty &&
    //             _titlePass.text.isNotEmpty) &&
    //             (_titlePass.text == _titlePass2.text))
    //           _showMyDialog();
    //         else
    //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //               backgroundColor: Colors.indigo,
    //               content: Text("检查一下！压根没填好好不好？")));
    //       },
    //     ),
    //   ],
    // ),
  }
}
