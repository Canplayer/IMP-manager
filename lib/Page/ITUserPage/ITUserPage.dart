import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hnszlyyimp/Page/View/EmptyPage.dart';

import 'SelfMissionListView.dart';
import 'NewSelfMissionPage.dart';

class _TabInfo {
  const _TabInfo(this.title, this.icon, this.color, this.widget);

  final String title;
  final IconData icon;
  final Widget widget;
  final Color color;
}

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
    final _tabInfo = [
      _TabInfo(
        '任务',
        Icons.list,
        Colors.blue,
        Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.do_not_disturb_on,
              color: Colors.red,
              size: 80,
            ),
            Text(
              "这个界面正在施工\n要录数据请点击“自录数据”选项卡\nこのインターフェースは工事中です。\nThis interface is under construction",
              textAlign: TextAlign.center,
            ),
          ],
        )),
      ),
      _TabInfo(
        '自录数据',
        Icons.addchart_outlined,
        Colors.blue,
        Scaffold(
          body: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return (orientation == Orientation.portrait)
                  ? page(false)
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
                          child: page(true),
                        ),
                        LayoutId(
                          id: 2,
                          child: Navigator(
                            initialRoute: '/',
                            onGenerateRoute: (RouteSettings settings) {
                              WidgetBuilder builder =
                                  (context1) => NewSelfMissionPage(true);
                              return MaterialPageRoute(builder: builder);
                            },
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_page),
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            child: child,
            animation: animation,
            transitionType: SharedAxisTransitionType.vertical,
            secondaryAnimation: secondaryAnimation,
          );
        },
        child: _tabInfo[currentIndex!].widget,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (final tabInfo in _tabInfo)
            BottomNavigationBarItem(
                icon: Icon(tabInfo.icon),
                label: tabInfo.title,
                backgroundColor: tabInfo.color)
        ],
        //type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (index) {
          _changePage(index);
        },
      ),
    );
  }

  void _changePage(int index) {
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  Widget page(bool hasChild) {
    return Scaffold(
      floatingActionButton: hasChild
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new NewSelfMissionPage(false)),
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
