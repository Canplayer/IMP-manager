import 'dart:io';
import 'dart:ui';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hnszlyyimp/Page/ClientPage/ClientPage.dart';
import 'package:hnszlyyimp/Widget/PlasticsCard.dart';
import 'package:hnszlyyimp/model.dart';
import 'package:lottie/lottie.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../client.dart';
import '../ITCenterPage/ITCenterPage.dart';
import '../ITUserPage/ITUserPage.dart';
import '../test.dart';
import 'InfoEditPage.dart';

class WelcomePage extends StatelessWidget {
  final fatherContext;
  WelcomePage(this.fatherContext, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Lottie.asset('res/avatarAnim.json', height: 200),
            Hero(
              tag: "avatar",
              child: Container(
                height: 120,
                width: 120,
                child: ClipOval(
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return InfoEditPage(fatherContext);
                            },
                          ),
                        );
                      },
                      child: Image.network(
                        "http://" +
                            Client().ip +
                            ":" +
                            Client().serverPort +
                            "/getAvatar?id=" +
                            isLogin!.id!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Text(
                  isLogin!.username!,
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 30, 30, 30)),
                ),
                SizedBox(
                  height: 2,
                ),
                Text("欢迎回来"),
                if (kDebugMode)
                  OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(StadiumBorder(
                          side: BorderSide(
                        color: Colors.transparent,
                      ))),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new MainPage(context)),
                      );
                    },
                    child: Text(
                      'Debug测试通道',
                    ),
                  ),
              ],
            ),
          ],
        ),
        // Stack(
        //   children: [
        //     SizedBox(
        //       width: 600,
        //       child: SvgPicture.asset(
        //         "res/welcome.svg",
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //     InkWell(
        //       onTap: () {
        //         Navigator.push(
        //           fatherContext,
        //           new MaterialPageRoute(
        //               builder: (context) => new ITCenterPage()),
        //         );
        //       },
        //       child: Container(
        //           height: 80,
        //           width: 80,
        //           child: Image.network(
        //             "http://"+Client().ip+":"+Client().serverPort+"/getAvatar?id=" + isLogin!.id!,
        //           ),
        //       )
        //     ),
        //     Positioned(
        //       top: 55,
        //       left: 40,
        //       child: Text(
        //         '欢迎回来,\n' + isLogin!.username!,
        //         style: TextStyle(
        //             fontSize: 40,
        //             color: Colors.white,
        //             fontWeight: FontWeight.bold),
        //       ),
        //     ),
        //   ],
        // ),

        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Container(
            color: Colors.white.withAlpha(150),
            //height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLogin!.authority!.contains("3"))
                  _item("故障报修", "res/icon_cloud.svg", () {
                    Navigator.push(
                      fatherContext,
                      new MaterialPageRoute(
                          builder: (context) => new ITCenterPage()),
                    );
                  }),
                if (isLogin!.authority!.contains("2"))
                  _item("信息员", "res/icon_doc_done.svg", () {
                    Navigator.push(
                      fatherContext,
                      new MaterialPageRoute(
                          builder: (context) => new ITUserPage()),
                    );
                  }),
                if (isLogin!.authority!.contains("1"))
                  _item("故障报修", "res/icon_msg.svg", () {
                    Navigator.push(
                      fatherContext,
                      new MaterialPageRoute(
                          builder: (context) => new NormalUserPage()),
                    );
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _item(
    String text,
    String svgPath,
    GestureTapCallback function,
  ) {
    return InkWell(
      onTap: function,
      child: SizedBox(
        height: 145,
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 55,
                width: 55,
                child: SvgPicture.asset(
                  svgPath,
                )),
            SizedBox(
              height: 15,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
