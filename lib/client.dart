import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:hnszlyyimp/model.dart';

var url = "http://10.10.142.77:8081/";
LoginResModel isLogin;
final int version = 1;
Response response;
var dio = Dio();

Future<int> versionCheck() async {
  var loginUrl = url + "versionCheck";
  var a = {"version": isLogin.id};
  response = await dio.get(loginUrl);
  print(response.data.toString());
  VersionCheckModel vcm = VersionCheckModel.fromJson(response.data);
  if(vcm.version != version) return 0;
  return 1;
}

Future<int> login(String _id, String _password) async {
  var loginUrl = url + "login";
  response = await dio.post(loginUrl, data: {"username": _id, "passwd": _password});
  log(response.data.toString());
  LoginResModel lm = LoginResModel.fromJson(response.data);
  print(lm.result);
  if (lm.result == 'OK') {
    isLogin = lm;
    isLogin.id = _id;
    return 1;
  }
  return 0;
}

//工作计划获取
Future<List<SelfMissionModel>> getITUserSelfMission() async {
  var loginUrl = url + "iTUserSelfMission";
  var a = {"userId": isLogin.id};
  response = await dio.get(loginUrl, queryParameters: a);
  print(response.data.toString());
  List<SelfMissionModel> patrolList = (response.data)
      .map<SelfMissionModel>((e) => SelfMissionModel.fromJson(e))
      .toList();
  return patrolList.reversed.toList();
}

Future<int> newITUserSelfMission(String name, String phone, String dep,
    DateTime date, String type, String des, String sol) async {
  var loginUrl = url + "iTUserSelfMission";
  var data = {
    "original-streams-id": "",
    "distribute-streams-id": "",
    "userid": isLogin.id,
    "opuserid": isLogin.id,
    "sduserid": "",
    "department": dep,
    "person2contact": name,
    "phone2contact": phone,
    "faultdate": formatDate(date, [yyyy, '-', mm, '-', dd]),
    "faulttype": type,
    "problemdescribe": des,
    "reportdate": formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
    "reporttime": formatDate(DateTime.now(), [hh, ':', mm, ':', ss]),
    "engineer": isLogin.username,
    "engineerphone": "",
    "faultprogress": "",
    "solution": sol,
    "processingtime":"0",
    "processingtime_unit":""
  };
  response = await dio.post(loginUrl, data: data);
  print(response.data.toString());

  return 1;
}

Future<int> delITUserSelfMission(String msgID) async {
  var loginUrl = url + "iTUserSelfMission";
  response = await dio.delete(loginUrl, data: {"msgID": msgID});
  log(response.data.toString());
  var result = response.data['result'];
  if (result == 'OK') {
    return 1;
  }
  return 0;
}

//工作可用故障类型
Future<TypeListModel> getTypeList() async {
  var loginUrl = url + "getTypeList";
  response = await dio.get(loginUrl);
  TypeListModel list = TypeListModel.fromJson(response.data);
  return list;
}



//客户端内容获取
Future<List<MissionModel>> getClientMission() async {
  var loginUrl = url + "Client";
  var a = {"userId": isLogin.id};
  response = await dio.get(loginUrl, queryParameters: a);
  print(response.data.toString());
  List<MissionModel> patrolList = (response.data)
      .map<MissionModel>((e) => MissionModel.fromJson(e))
      .toList();
  return patrolList.reversed.toList();
}