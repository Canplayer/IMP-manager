import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

import '../../client.dart';

class FullScreenPhotoView extends StatelessWidget {
  final String id;
  const FullScreenPhotoView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //backgroundColor: Color(0x44000000),
        elevation: 0,
        title: Text("报障平台"),
      ),
      body: Container(
          child: PhotoView(
        imageProvider: NetworkImage("http://" +
            Client().ip +
            ":" +
            Client().serverPort +
            "/ClientOpPic?id=" +
            id),
      )),
    );
  }
}
