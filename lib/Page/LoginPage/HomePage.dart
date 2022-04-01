import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../client.dart';
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
    bool isSmall = (MediaQuery.of(context).size.width >= 550);

    return Scaffold(
        //backgroundColor: Colors.transparent,
        //resizeToAvoidBottomInset: false,
        body: Stack(
      children: [
        Container(
            constraints: new BoxConstraints.expand(),
            child: FadeInImage.memoryNetwork(
              image: "http://" +
                  Client().ip +
                  ":" +
                  Client().serverPort +
                  "/GetPic",
              placeholder: kTransparentImage,
              fit: BoxFit.cover,
            )),
        Container(
          child: Center(
            //可裁切的矩形
            child: Container(
              child: ClipRRect(
                //背景过滤器
                borderRadius: isSmall?BorderRadius.circular(15):BorderRadius.zero,
                child: BackdropFilter(

                  //语言屎坑
                  filter: ImageFilter.blur(sigmaX: isSmall?30.0:0.1, sigmaY: isSmall?30.0:0.1),
                  child: Container(
                    key: ValueKey("3"),
                    constraints:
                         BoxConstraints(
                            maxHeight: isSmall?540:double.infinity,
                            maxWidth: isSmall?500:double.infinity,
                          ),
                    color: Color.fromARGB(isSmall?200:220, 255, 255, 255),
                    child: _view(),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: (isSmall)
                    ? [
                        BoxShadow(
                          color: Color.fromARGB(100, 0, 0, 0),
                          //offset: Offset(0.0, 25.0), //阴影xy轴偏移量
                          blurRadius: 30.0, //阴影模糊程度
                          spreadRadius: 0.0, //阴影扩散程度
                          blurStyle: BlurStyle.outer,
                        )
                      ]
                    : null,
              ),
            ),
          ),
        )
      ],
    ));
  }

  Widget _view() {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder = (a) => LoginPage(context);
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}
