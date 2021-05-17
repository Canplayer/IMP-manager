import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// class NewMissionPage extends StatelessWidget {
//   const NewMissionPage({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('新建任务')),
//       body: Body(),
//     );
//   }
// }

// class Body extends StatelessWidget {
//   const Body({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         child: SizedBox(
//           width: 300,
//           child: Padding(
//             padding: EdgeInsets.all(15),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(), labelText: '报障人'),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 TextField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(), labelText: '电话号码'),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 TextField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(), labelText: '科室'),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 TextField(
//
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(), labelText: '故障描述'),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 FloatingActionButton(
//                   child: Icon(Icons.done),
//                   onPressed: (){
//                     Navigator.push(
//                       context,
//                       new MaterialPageRoute(
//                           builder: (context) => new NewMissionPage()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           )
//         ),
//       ),
//     );
//   }
// }

class ImagePickerPage extends StatefulWidget {
  ImagePickerPage({Key key}) : super(key: key);

  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  //记录选择的照片
  File _image;

  //拍照
  Future _getImageFromCamera() async {
    var image = await ImagePicker.platform.pickImage(source: ImageSource.camera, maxWidth: 400);

    setState(() {
      _image = image as File;
    });
  }

  //相册选择
  Future _getImageFromGallery() async {
    var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image as File;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("选择图片并上传")),
      body: Container(
        child: ListView(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _getImageFromCamera();
              },
              child: Text("照相机"),
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () {
                _getImageFromGallery();
              },
              child: Text("相册"),
            ),
            SizedBox(height: 10),
            /**
             * 展示选择的图片
             */
            _image == null
                ? Text("no image selected")
                : Image.file(
              _image,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}