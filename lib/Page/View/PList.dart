import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PList extends StatefulWidget {
  const PList({Key key}) : super(key: key);

  @override
  _PListState createState() => _PListState();
}

class _PListState extends State<PList> {

  final _PlistItem = <OneMisson>[];

  Widget _buildList(){
    return ListView.builder(itemBuilder: (context,i){


      if (i >= _PlistItem.length) {
        _PlistItem.addAll([new OneMisson()]); /*4*/
      }
      return _buildCard(_PlistItem[i]);
    },);
  }



  @override
  Widget build(BuildContext context) {
    return _buildList();
  }

  Widget _buildCard(OneMisson plistItem) {
    return Container(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('陈马也'),
                    Text('1008611'),
                    Text('20210509'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('电脑HIS无法打开'),
                    Text('已解决'),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OneMisson {
  String _name= '123',_phone='456';

  String get next => _name;
  set next(String value) {
    _name = value;
  }

  get phone => _phone;
  set phone(value) {
    _phone = value;
  }
}
