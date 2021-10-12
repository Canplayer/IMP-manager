import 'dart:ui';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hnszlyyimp/Page/LoginPage/WelcomePage.dart';
import 'package:hnszlyyimp/client.dart';
import 'package:lottie/lottie.dart';

import 'LoginPage.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const String _title = '登录页面';

  // @override
  // void initState() {
  //   super.initState();
  //   this.setWindowEffect();
  // }
  // void setWindowEffect() {
  //   Acrylic.setEffect(effect: AcrylicEffect.acrylic, gradientColor: Platform.isWindows ? Colors.white.withOpacity(0.7) : Colors.white);
  // }





  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        //backgroundColor: Colors.transparent,
        body: Container(
          child: Center(
            //可裁切的矩形
            child: Container(
              child: ClipRRect(
                //背景过滤器
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: Container(
                    height: 540,
                    width: 500,
                    color: Color.fromARGB(180, 255, 255, 255),
                    child:Navigator(
                      initialRoute: '/',
                      onGenerateRoute: (RouteSettings settings) {
                        WidgetBuilder builder = (context1) => LoginPage(context);
                        return MaterialPageRoute(builder: builder);
                      },
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(20, 0, 0, 0),
                        offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                        blurRadius: 30.0, //阴影模糊程度
                        spreadRadius: 0.0 //阴影扩散程度
                        )
                  ]),
            ),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new NetworkImage("http://10.10.142.77:8081/GetPic"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
  }
}



