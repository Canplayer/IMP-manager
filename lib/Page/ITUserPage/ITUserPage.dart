import 'dart:math';

import 'package:flutter/material.dart';

import 'SelfMissionListView.dart';
import 'NewSelfMissionPage.dart';

class ITUserPage extends StatefulWidget {
  const ITUserPage({Key? key}) : super(key: key);

  @override
  _ITUserPageState createState() => _ITUserPageState();
}

class _ITUserPageState extends State<ITUserPage> {
  final String _page = '信息人员平台';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return (orientation == Orientation.portrait)
            ? page()
            : CustomMultiChildLayout(
                delegate: ResponsivePageDelegate(
                  isMainInRight: false,
                  mainPanelMaxWidth: 400,
                  mainPanelMinWidth: 400,
                  secondaryPanelMaxWidth: double.infinity,
                  secondaryPanelMinWidth: 0,
                ),
                children: [
                  LayoutId(
                    id: 1,
                    child: page(),
                  ),
                  LayoutId(
                    id: 2,
                    child: NewSelfMissionPage(),
                  ),
                ],
              );
      },
    );
  }

  Widget page() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_page),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new NewSelfMissionPage()),
          ).then((value) => {if (value == "refresh") setState(() {})});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: SelfMissionListView(),
          ),
        ),
      ),
    );
  }
}

class ResponsivePageDelegate extends MultiChildLayoutDelegate {
  ResponsivePageDelegate({
    required this.mainPanelMinWidth,
    required this.mainPanelMaxWidth,
    required this.secondaryPanelMinWidth,
    required this.secondaryPanelMaxWidth,
    required this.isMainInRight,
  });

  final double mainPanelMinWidth;
  final double mainPanelMaxWidth;
  final double secondaryPanelMinWidth;
  final double secondaryPanelMaxWidth;

  final bool isMainInRight;

  @override
  void performLayout(Size size) {
    final double mainPanelWidth = min(
        mainPanelMinWidth +
            (size.width - mainPanelMinWidth - secondaryPanelMinWidth) / 2,
        mainPanelMaxWidth);
    final double secondPanelWidth = size.width - mainPanelWidth;

    if (secondPanelWidth <= secondaryPanelMaxWidth) {
      layoutChild(1, BoxConstraints.tight(Size(mainPanelWidth, size.height)));
      layoutChild(2, BoxConstraints.tight(Size(secondPanelWidth, size.height)));
      if (isMainInRight) {
        positionChild(2, const Offset(0, 0));
        positionChild(1, Offset(secondPanelWidth, 0));
      } else {
        positionChild(1, const Offset(0, 0));
        positionChild(2, Offset(mainPanelWidth, 0));
      }
    } else {
      final double reminder =
          size.width - mainPanelWidth - secondaryPanelMaxWidth;

      layoutChild(1, BoxConstraints.tight(Size(mainPanelWidth, size.height)));
      layoutChild(
          2, BoxConstraints.tight(Size(secondaryPanelMaxWidth, size.height)));

      if (isMainInRight) {
        positionChild(2, Offset(reminder / 2, 0));
        positionChild(1, Offset(reminder / 2 + secondaryPanelMaxWidth, 0));
      } else {
        positionChild(1, Offset(reminder / 2, 0));
        positionChild(2, Offset(reminder / 2 + mainPanelWidth, 0));
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
