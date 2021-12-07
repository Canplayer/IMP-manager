//import 'package:filepicker_windows/filepicker_windows.dart';

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hnszlyyimp/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cross_file/cross_file.dart';

import '../../client.dart';

class NewMissionPage extends StatefulWidget {
  LoginResModel loginContext;
  NewMissionPage(this.loginContext, {Key? key}) : super(key: key);

  @override
  _NewMissionPageState createState() => _NewMissionPageState();
}

class _NewMissionPageState extends State<NewMissionPage> {
  XFile? _image;
  var _name = new TextEditingController();
  var _phone = new TextEditingController();
  var _depart = new TextEditingController();
  var _problemDescribe = new TextEditingController();
  List<DropdownMenuItem<String>> typeItems = [];
  var selectItemValue = '其他';

  @override
  void initState() {
    _name.text=widget.loginContext.username!;
    _phone.text=widget.loginContext.phone!;
    _depart.text=widget.loginContext.department!;
    super.initState();
    loadTypeList();
  }

  loadTypeList() async {
    List<DropdownMenuItem<String>> items = [];
    var a = await getTypeList();
    a.data!.forEach((element) {
      items.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });
    setState(() {
      typeItems = items;
    });
  }

  //拍照
  Future _getImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    //     await PhoneWebPicker.getImage(source: ImageSource.camera, maxHeight: 2048);
    setState(() {
      if (image != null) {
        _image = image;
      }
    });
  }

  //相册
  Future _getImageFromGallery() async {
    //final pickedFile = await PhoneWebPicker.getImage(source: ImageSource.gallery, maxHeight: 2048);
    log("尝试读取图片");
    //final XFile? image = await PhoneWebPicker.pickImage(source: ImageSource.gallery, maxHeight: 2048);
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

  // Future _getImageFromPC() async{
  //   final pickedFile = await OpenFilePicker()..filterSpecification={
  //     '支持的图片格式':'*.jpg;*.jpeg;*.png',
  //   }..defaultFilterIndex=0 ..defaultExtension='jpg' ..title= '选择一张图片';
  //   final result = pickedFile.getFile();
  //   setState(() {
  //     if (result != null) {
  //       _image = File(result.path);
  //     }
  //   });
  // }

  Future _openWindowsSSTool() async {
    const url = 'file://C:/Windows/system32/SnippingTool.exe';
    await canLaunch(url) ? launch(url) : throw 'Could not launch $url';
  }

  Future<void> _showMyDialog() async {
    Future a = newNormalUserMission(_name.text, _phone.text, _depart.text,
        selectItemValue, _problemDescribe.text, _image);
    a.then((value) {
      Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('上报故障')),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          child: Card(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _name,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(), labelText: '报障人'),
                          ),
                        ),

                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _phone,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(), labelText: '电话号码'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _depart,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: '科室/位置'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton<String>(
                      value: selectItemValue,
                      isExpanded: true,
                      disabledHint: Text('暂不可用'),
                      items: typeItems,
                      onChanged: (String? value) {
                        print(value);
                        setState(() {
                          selectItemValue = value!;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _problemDescribe,
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
                            child: (kIsWeb == true)
                                ? Image.network(
                                    _image!.path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(_image!.path),
                                    fit: BoxFit.cover,
                                  )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Platform.isWindows||Platform.isLinux||Platform.isMacOS
                        // (1==1)?
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
                        ),
                        // :
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
                            //(Platform.isWindows||Platform.isLinux||Platform.isMacOS)?_getImageFromPC():_getImageFromGallery();
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
                      heroTag: "555tt",
                      onPressed: () {
                        if (_name.text.isNotEmpty &&
                            _phone.text.isNotEmpty &&
                            _depart.text.isNotEmpty &&
                            _problemDescribe.text.isNotEmpty)
                          _showMyDialog();
                        else
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.indigo,
                              content: Text("检查一下！好像没有填全")));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
