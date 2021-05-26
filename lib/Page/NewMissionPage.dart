import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';


import '../client.dart';

class NewMissionPage extends StatefulWidget {
  const NewMissionPage({Key key,int a}) : super(key: key);

  @override
  _NewMissionPageState createState() => _NewMissionPageState();
}

class _NewMissionPageState extends State<NewMissionPage> {
  File _image;
  final PhoneWebPicker = ImagePicker();

  //拍照
  Future _getImageFromCamera() async {
    final pickedFile =
        await PhoneWebPicker.getImage(source: ImageSource.camera, maxHeight: 2048);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }
  //相册
  Future _getImageFromGallery() async {
    final pickedFile = await PhoneWebPicker.getImage(source: ImageSource.gallery, maxHeight: 2048);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future _getImageFromPC() async{
    final pickedFile = await OpenFilePicker()..filterSpecification={
      '支持的图片格式':'*.jpg;*.jpeg;*.png',
    }..defaultFilterIndex=0 ..defaultExtension='jpg' ..title= '选择一张图片';
    final result = pickedFile.getFile();
    setState(() {
      if (result != null) {
        _image = File(result.path);
      }
    });
  }

  Future _openWindowsSSTool() async{
    const url = 'file://%windir%/system32/SnippingTool.exe';
    await canLaunch(url)?launch(url):throw 'Could not launch $url';
  }


  Future<void> _showMyDialog() async {
    Future a = addNewReport();
    a.then((value) {
      Navigator.of(context).pop();
      if (value == 1) {
        Navigator.pop(context);
      }
      else{}
    });

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('正在提交'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                LinearProgressIndicator(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新建任务')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: Card(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: '报障人'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: '电话号码'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: '科室'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: '故障描述'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _image == null
                          ? SizedBox()
                          : SizedBox(
                        height: 200,
                        child: Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          (Platform.isWindows||Platform.isLinux||Platform.isMacOS)?
                          TextButton(
                            onPressed: () {
                              _openWindowsSSTool();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.airplay_outlined),
                                Text('调用截图程序')
                              ],
                            ),
                          ):
                          TextButton(
                            onPressed: () {
                              _getImageFromCamera();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.camera_enhance_outlined),
                                Text('拍照')
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              (Platform.isWindows||Platform.isLinux||Platform.isMacOS)?_getImageFromPC():_getImageFromGallery();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.photo_library_outlined),
                                Text('相册')
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        child: Icon(Icons.done),
                        onPressed: () {
                          _showMyDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}