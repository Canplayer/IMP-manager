import 'dart:developer';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import '../../client.dart';

class NewSelfMissionPage extends StatefulWidget {
  const NewSelfMissionPage({Key key, int a}) : super(key: key);

  @override
  _NewSelfMissionPageState createState() => _NewSelfMissionPageState();
}

class _NewSelfMissionPageState extends State<NewSelfMissionPage> {
  var _name = new TextEditingController();
  var _phone = new TextEditingController();
  var _depart = new TextEditingController();
  var _problemDescribe = new TextEditingController();
  var _solution = new TextEditingController();

  DateTime selectedDate = DateTime.now();
  List<DropdownMenuItem> typeItems = [];
  var selectItemValue = '其他';

  Future<void> _showMyDialog() async {
    Future a = newITUserSelfMission(_name.text, _phone.text, _depart.text,
        selectedDate, selectItemValue, _problemDescribe.text, _solution.text);
    a.then((value) {
      Navigator.of(context).pop();
      if (value == 1) {
        Navigator.pop(context);
      } else {}
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

  Future<void> _selectDate() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    setState(() {
      selectedDate = date;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTypeList();
  }

  loadTypeList() async {
    List<DropdownMenuItem> items = [];
    var a = await getTypeList();
    a.data.forEach((element) {
      items.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });
    setState(() {
      typeItems = items;
    });
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _name,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '报障人'),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _phone,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '电话号码(可选)'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _depart,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: '科室/地点'),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: _selectDate,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.calendar_today),
                            Text(formatDate(
                                selectedDate, [yyyy, '/', mm, '/', dd])),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButton(
                        value: selectItemValue,
                        isExpanded: true,
                        disabledHint: Text('暂不可用'),
                        items: typeItems,
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            selectItemValue = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _problemDescribe,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: '故障描述'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _solution,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: '解决方法'),
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
