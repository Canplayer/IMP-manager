import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model.dart';

class MyList extends StatefulWidget {
  const MyList({Key key}) : super(key: key);

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  final _qwerty = <ListItemModel>[];

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _qwerty.length) {
            var i = new ListItemModel();
            i.department='门诊';
            i.describe='电脑坏了';
            i.phone='10086';
            i.status=1;
            i.type='弱电';

            var j = new ListItemModel();
            j.department='ICU';
            j.describe='打印机坏了';
            j.phone='119';
            j.status=2;
            j.type='电脑设备';


            _qwerty.addAll([i,j,i,j,i,j,i,j]); /*4*/
          }
          return _buildRow(_qwerty[index]);
        });
  }

  Widget _buildRow(ListItemModel pair) {
    return ListTile(
      title: Text(
        pair.describe
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
}
