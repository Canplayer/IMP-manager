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
  List myList = [];
  int listLength;
  @override
  void initState() {
    super.initState();
    loadData();
  }
  loadData() async {
    var a = await ITUserPlanListGet();
    setState(() {
      myList=a;
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
      return CupertinoActivityIndicator();
    }
  }

  Widget _buildRow(ListItemModel pair) {
    return Container(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(pair.department),
                        Text(pair.name),
                        Text(pair.phone),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          pair.type,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          pair.describe,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(pair.solution),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.done,
                  size: 40,
                  color: Colors.green,
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
