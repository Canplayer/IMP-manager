import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../client.dart';
import '../../model.dart';

class MyList extends StatefulWidget {
  const MyList({Key key}) : super(key: key);

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  final _viewList = <ListItemModel>[];
  List myList;
  int listLength;
  @override
  void initState() {
    super.initState();
    Future a = ITUserPlanListGet();
    a.then((value) => {myList = value, print(myList.length)});
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/
          final index = i ~/ 2; /*3*/
          if (index >= _viewList.length) {
            if (index < myList.length) _viewList.add(myList.elementAt(index));
          }
          return _buildRow(myList[index]);
        });
  }

  Widget _buildRow(ListItemModel pair) {
    return ListTile(
      title: Text(pair.describe),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
}
