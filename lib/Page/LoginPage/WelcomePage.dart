import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hnszlyyimp/Page/ClientPage/ClientPage.dart';
import 'package:hnszlyyimp/model.dart';

import '../../client.dart';
import '../ITCenterPage/ITCenterPage.dart';
import '../ITUserPage/ITUserPage.dart';

class WelcomePage extends StatelessWidget {
  var fatherContext;
  WelcomePage(this.fatherContext, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> a = [1, 2, 3];
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 600,
                child: SvgPicture.asset(
                  "res/welcome.svg",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 55,
                left: 40,
                child: Text(
                  '欢迎回来,\n' + isLogin!.username!,
                  style: TextStyle(fontSize: 40,color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                SizedBox(
                  height: 30,
                ),
                //for(var i in isLogin.authority) cardList[i]
                if (isLogin!.authority!.contains("3"))
                  Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.push(
                          fatherContext,
                          new MaterialPageRoute(
                              builder: (context) => new ITCenterPage()),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.work_outline),
                            title: Text('我是IT服务台'),
                            subtitle: Text('面向信息总台的选项'),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isLogin!.authority!.contains("2"))
                  Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.push(
                          fatherContext,
                          new MaterialPageRoute(
                              builder: (context) => new ITUserPage()),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.all_inclusive),
                            title: Text('我是信息部人员'),
                            subtitle: Text('面向信息部人员的派发平台'),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isLogin!.authority!.contains("1"))
                  Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.push(
                          fatherContext,
                          new MaterialPageRoute(
                              builder: (context) => new NormalUserPage()),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.warning_amber_rounded),
                            title: Text('我要报障'),
                            subtitle: Text('面对医院员工的报障选项'),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
