import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PList extends StatefulWidget {
  const PList({Key? key}) : super(key: key);

  @override
  _PListState createState() => _PListState();
}

class _PListState extends State<PList> {
  final _PlistItem = <OneMisson>[];

  Widget _buildList() {
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i >= _PlistItem.length) {
          _PlistItem.addAll([new OneMisson()]); /*4*/
        }
        return _buildCard(_PlistItem[i]);
      },
    );
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
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('门诊部'),
                        Text('  1008611'),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '设备',
                          style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),
                        ),
                        Text(
                          ' 打印机故障，麻烦来修一下',
                          style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('电脑HIS无法打开'),
                        Text('已解决'),
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
}

class OneMisson {
  String _name = '123', _phone = '456';

  String get next => _name;
  set next(String value) {
    _name = value;
  }

  get phone => _phone;
  set phone(value) {
    _phone = value;
  }
}
