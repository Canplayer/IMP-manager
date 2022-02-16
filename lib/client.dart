import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:date_format/date_format.dart';
import 'package:hnszlyyimp/model.dart';
import 'package:cross_file/cross_file.dart';

class Client{
  get ip => "10.10.142.77";
  get serverPort => "8081";
  get url => "http://"+ip+":"+serverPort+"/";
  get screenClipUrl => "http://"+ip+"/tools/screenclip.html";
}

LoginResModel? isLogin;
final int version = 1;
Response? response;
var dio = Dio();

//获取服务器版本号
Future<int> versionCheck() async {
  var loginUrl = Client().url + "versionCheck";
  var a = {"version": isLogin!.id};
  response = await dio.get(loginUrl);
  print(response!.data.toString());
  VersionCheckModel vcm = VersionCheckModel.fromJson(response!.data);
  if (vcm.version != version) return 0;
  return 1;
}

//登录
Future<int> login(String _id, String _password) async {
  var loginUrl = Client().url + "login";
  response =
      await dio.post(loginUrl, data: {"username": _id, "passwd": _password});
  log(response!.data.toString());
  LoginResModel lm = LoginResModel.fromJson(response!.data);
  print(lm.result);
  if (lm.result == 'OK') {
    isLogin = lm;
    isLogin!.id = _id;
    return 1;
  }
  return 0;
}

//注册
Future<int> register(String id,String username,String department,String phone,String email,String passwd) async {
  var loginUrl = Client().url + "register";
  response =
  await dio.post(loginUrl, data: {"id": id,"username":username,"department":department,"phone":phone,"email":email,"passwd":passwd});
  log(response!.data.toString());
  SimpleModel sm = SimpleModel.fromJson(response!.data);
  print(sm.result);
  if (sm.result != 'FAILED') {
    return int.parse(sm.result!);
  }
  return 0;
}

//上传用户头像
Future<int> uploadAvatar(XFile? image) async {
  var loginUrl = Client().url + "uploadAvatar";
  var file;
  if (image != null) {
    Uint8List? _bytesData = await image.readAsBytes();
    file = MultipartFile.fromBytes(_bytesData, filename: "content.txt");
  }
  var data = {
    "userid": isLogin!.id,
  };

  Map<String, dynamic> map = Map();
  map["info"] = data;
  map["file"] = file;
  FormData formData = FormData.fromMap(map);

  response = await dio.post(loginUrl, data: formData);
  print(response!.data.toString());
  var result = response!.data['result'];
  if (result == 'OK') {
    return 1;
  }
  return 0;
}
//获取用户头像
Future<XFile?> getAvatar() async {
  var loginUrl = Client().url + "getAvatar";
  response = await dio.get(loginUrl, queryParameters: {"userid": isLogin!.id});
  print(response!.data.toString());
  var result = response!.data['result'];
  if (result == 'OK') {
    var data = response!.data['data'];
    var file = XFile.fromData(data);
    return file;
  }
  return null;
}

//服务台内容获取
Future<List<MissionModel>> getITCenterMission(String type) async {
  var loginUrl = Client().url + "ITClient";
  var a = {"type": type};
  response = await dio.get(loginUrl, queryParameters: a);
  //print(response!.data.toString());
  List<MissionModel> patrolList = (response!.data)
      .map<MissionModel>((e) => MissionModel.fromJson(e))
      .toList();
  return patrolList.reversed.toList();
}

//服务台分发工程师数据
Future<int> setITCenterMissionO2OP(String ID, String opID) async {
  var loginUrl = Client().url + "ITClient_O2OP";

  var data = {
    "id": ID,
    "opid": opID,
  };
  response = await dio.post(loginUrl, data: data);
  print(response!.data.toString());

  return 1;
}


//工程师自定列表
Future<List<SelfMissionModel>> getITUserSelfMission() async {
  var loginUrl = Client().url + "iTUserSelfMission";
  var a = {"userId": isLogin!.id};
  response = await dio.get(loginUrl, queryParameters: a);
  print(response!.data.toString());
  List<SelfMissionModel> patrolList = (response!.data)
      .map<SelfMissionModel>((e) => SelfMissionModel.fromJson(e))
      .toList();
  return patrolList.reversed.toList();
}

//工程师上传新自定数据
Future<int> newITUserSelfMission(String name, String phone, String dep,
    DateTime date, String type, String des, String sol,String time,String timeUnit) async {
  var loginUrl = Client().url + "iTUserSelfMission";

  var data = {
    "original-streams-id": "",
    "distribute-streams-id": "",
    "userid": isLogin!.id,
    "opuserid": isLogin!.id,
    "sduserid": "",
    "department": dep,
    "person2contact": name,
    "phone2contact": phone,
    "faultdate": formatDate(date, [yyyy, '-', mm, '-', dd]),
    "faulttype": type,
    "problemdescribe": des,
    "reportdate": formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
    "reporttime": formatDate(DateTime.now(), [hh, ':', mm, ':', ss]),
    "engineer": isLogin!.username,
    "engineerphone": "",
    "faultprogress": "",
    "solution": sol,
    "processingtime": time,
    "processingtime_unit": timeUnit
  };
  response = await dio.post(loginUrl, data: data);
  print(response!.data.toString());

  return 1;
}

//工程师删除自定数据
Future<int> delITUserSelfMission(String msgID) async {
  var loginUrl = Client().url + "iTUserSelfMission";
  response = await dio.delete(loginUrl, data: {"msgID": msgID});
  log(response!.data.toString());
  var result = response!.data['result'];
  if (result == 'OK') {
    return 1;
  }
  return 0;
}

//工作可用故障类型
Future<TypeListModel> getEngineerList() async {
  var loginUrl = Client().url + "getEngineerInfo";
  response = await dio.get(loginUrl);
  TypeListModel list = TypeListModel.fromJson(response!.data);
  return list;
}

//工作可用故障类型
Future<TypeListModel> getTypeList() async {
  var _url = Client().url + "getTypeList";
  response = await dio.get(_url);
  TypeListModel list = TypeListModel.fromJson(response!.data);
  return list;
}

//客户端内容获取
Future<List<MissionModel>> getNormalUserMission() async {
  var loginUrl = Client().url + "Client";
  var a = {"userId": isLogin!.id};
  response = await dio.get(loginUrl, queryParameters: a);
  print(response!.data.toString());
  List<MissionModel> patrolList = (response!.data)
      .map<MissionModel>((e) => MissionModel.fromJson(e))
      .toList();
  return patrolList.reversed.toList();
}

//客户端数据上报
Future<int> newNormalUserMission(String name, String phone, String dep, String type, String des, XFile? image) async {
  var loginUrl = Client().url + "Client";
  var file;
  if (image != null) {
    Uint8List? _bytesData = await image.readAsBytes();
    file = MultipartFile.fromBytes(_bytesData, filename: "content.txt");
  }
  var data = {
    "original-streams-id": "",
    "distribute-streams-id": "",
    "userid": isLogin!.id,
    "opuserid": "",
    "sduserid": "",
    "department": dep,
    "person2contact": name,
    "phone2contact": phone,
    "faultdate": formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
    "faulttype": type,
    "problemdescribe": des,
    "reportdate": formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
    "reporttime": formatDate(DateTime.now(), [hh, ':', mm, ':', ss]),
    "engineer": "",
    "engineerphone": "",
    "faultprogress": "未处理",
    "processingtime": "",
    "processingtime_unit": "",
    "solution": ""
  };

  Map<String, dynamic> map = Map();
  map["info"] = data;
  map["file"] = file;
  FormData formData = FormData.fromMap(map);

  response = await dio.post(loginUrl, data: formData);
  print(response!.data.toString());
  var result = response!.data['result'];
  if (result == 'OK') {
    return 1;
  }
  return 0;
}

//客户端任务完成
Future<int> setNormalUserMissionDone(String ID) async {
  var loginUrl = Client().url + "ITClient_done";

  var data = {
    "id": ID,
  };
  response = await dio.post(loginUrl, data: data);
  print(response!.data.toString());

  return 1;
}

//获取背景图片
Future<XFile> getBackground() async {
  var loginUrl = Client().url + "GetPic";
  response = await dio.get(loginUrl);
  ResponseBody result = response!.data;
  var a = await result.stream.first;
  return XFile.fromData(a);
}

//工程师列表
Future<List<OpUserListModel>> getOPList() async {
  var _url = Client().url + "getEngineerInfo";
  response = await dio.get(_url);
  print(response!.data.toString());
  List<OpUserListModel> patrolList = (response!.data)
      .map<OpUserListModel>((e) => OpUserListModel.fromJson(e))
      .toList();
  return patrolList.reversed.toList();
}