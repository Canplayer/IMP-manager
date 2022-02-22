import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../client.dart';

class InfoEditPage extends StatefulWidget {
  final BuildContext fatherContext;
  InfoEditPage(this.fatherContext, {Key? key}) : super(key: key);
  @override
  _InfoEditPageState createState() => _InfoEditPageState();
}

class _InfoEditPageState extends State<InfoEditPage> {
  XFile? _image;
  @override
  Widget build(BuildContext context) {


    //从相机获取图片
    Future _getImageFromCamera() async {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.camera,maxHeight: 2048,imageQuality: 20);
      //     await PhoneWebPicker.getImage(source: ImageSource.camera, maxHeight: 2048);
      setState(() {
        if (image != null) {
          _image = image;
        }
      });
    }

    //从相册获取图片
    Future _getImageFromGallery() async {
      //final pickedFile = await PhoneWebPicker.getImage(source: ImageSource.gallery, maxHeight: 2048);
      //final XFile? image = await PhoneWebPicker.pickImage(source: ImageSource.gallery, maxHeight: 2048);

      if(kIsWeb==false) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        setState(() {
          if (result != null) {
            if (kIsWeb == true) {
              var file = result.files.single;
              if (file.bytes != null) {
                _image = XFile.fromData(file.bytes!);
              }
            } else
              _image = XFile(result.files.single.path!);
          }
        });
      }
      else{
        final ImagePicker _picker = ImagePicker();
        XFile? image = await _picker.pickImage(source: ImageSource.gallery,maxHeight: 2048,imageQuality: 20);
        //     await PhoneWebPicker.getImage(source: ImageSource.camera, maxHeight: 2048);
        setState(() {
          if (image != null) {
            _image = image;
          }
        });
      }

    }

    //调用系统截图程序
    Future _openWindowsSSTool() async {
      // const url = 'file://C:/Windows/system32/SnippingTool.exe';
      // await canLaunch(url) ? launch(url) : throw 'Could not launch $url';
      var url = Client().screenClipUrl;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Container(
      alignment: Alignment.center,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: InkWell(
              child: SvgPicture.asset("res/back_btn.svg",color: Colors.teal),
              onTap: (){
                Navigator.of(context).pop();
              },
            ),
          ),
          SizedBox(height: 20,),
          Container(
            height: 250,
            width: 250,
            child: ClipOval(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 250,
                      width: 250,
                      child: Image.network(
                        "http://" +
                            Client().ip +
                            ":" +
                            Client().serverPort +
                            "/getAvatar?id=" +
                            isLogin!.id!,
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    SizedBox(

                      height: 250,
                      width: 250,
                      child: (_image == null)?
                      SizedBox():
                      (kIsWeb == true)
                          ? Image.network(
                        _image!.path,
                        fit: BoxFit.cover,
                      )
                          : Image.file(
                        File(_image!.path),
                        fit: BoxFit.cover,
                      ),
                    )

                  ],
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Platform.isWindows||Platform.isLinux||Platform.isMacOS
              // (1==1)?
              if(Theme.of(context).platform.name == "windows")TextButton(
                onPressed: () {
                  _openWindowsSSTool();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.airplay_outlined),
                    Text('截图')
                  ],
                ),
              ),
              // :
              if(Theme.of(context).platform.name != "windows")TextButton(
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
                  _getImageFromGallery();
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
              if (_image!=null)
                _showMyDialog();
            },
          ),
        ],
      )
    );
  }

  Future<void> _showMyDialog() async {
    Future a = uploadAvatar(_image);
    a.then((value) {
      Navigator.of(widget.fatherContext).pop();
      if (value == 1) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('res/doneAnim.json',
                    width: 100, height: 100, repeat: false),
                Text("操作成功~"),
              ],
            )));
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("操作失败")));
      }
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

}
