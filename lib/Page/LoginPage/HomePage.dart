import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'LoginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
    return Scaffold(
      //backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(constraints: new BoxConstraints.expand(),child: FadeInImage.memoryNetwork(image:"http://10.10.142.77:8081/GetPic", placeholder: kTransparentImage,  fit: BoxFit.cover,)),
          Container(
            child: Center(
              //可裁切的矩形
              child: Container(
                child: ClipRRect(
                  //背景过滤器
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                    child: Container(
                      height: 540,
                      width: 500,
                      color: Color.fromARGB(200, 255, 255, 255),
                      child: Navigator(
                        initialRoute: '/',
                        onGenerateRoute: (RouteSettings settings) {
                          WidgetBuilder builder =
                              (context1) => LoginPage(context);
                          return MaterialPageRoute(builder: builder);
                        },
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(30, 0, 0, 0),
                          offset: Offset(0.0, 25.0), //阴影xy轴偏移量
                          blurRadius: 30.0, //阴影模糊程度
                          spreadRadius: 0.0 //阴影扩散程度
                          )
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
