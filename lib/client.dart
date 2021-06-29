import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hnszlyyimp/model.dart';
import 'package:http/http.dart' as http;

var url = "http://127.0.0.1:8081/";
LoginResModel isLogin;

Future<int> login(String _id, String _password) async {
  var loginUrl = url + "login";
  Response response;
  var dio = Dio();
  response =
      await dio.post(loginUrl, data: {"username": _id, "passwd": _password});
  //var result = response.data.toString();
  LoginResModel lm = LoginResModel.fromJson(response.data);
  print(response.data);
  if (lm.result == 'OK') {
    isLogin=lm;
    isLogin.id = _id;
    return 1;
  }
  ;
  return 0;
}

//
Future<int> addNewReport() async {
  // HttpClient httpClient = new HttpClient();
  // var requset = await httpClient.getUrl(Uri.parse("http://127.0.0.1:3000/"));
  // var body = {'content':'this is a test', 'email':'john@doe.com', 'number':'441276300056'};
  // var response = await requset.close();
  // String result='123123';
  // if(response.statusCode == HttpStatus.ok){
  //   var json = await response.transform(utf8.decoder).join();
  //   var data = jsonDecode(json);
  //   result = data['title'];
  // }
  // print(result);
  // return 1;
  var url = "http://127.0.0.1:3000/";
  var client = new http.Client();
  var request = new http.Request('GET', Uri.parse(url));

  LoginResModel loginResModel = new LoginResModel();
  var body = {
    'content': '234567uuuijhh',
    'email': 'john@doe.com',
    'number': '441276300056'
  };
  request.headers[HttpHeaders.authorizationHeader] =
      'Basic 021215421fbe4b0d27f:e74b71bbce';
  //request.headers[HttpHeaders.contentTypeHeader] = 'application/json';
  request.bodyFields = body;
  var future = await client
      .send(request)
      .then((response) => response.stream
          .bytesToString()
          .then((value) => print(value.toString())))
      .catchError((error) => print(error.toString()));
  return 1;
}

//获取信息人员平台保障列表
Future<int> ITUserToDoListGet() async {}
//数据录入获取
Future<int> ITUserDateListGet() async {}
//数据录入提交
Future<int> ITUserDateListPost() async {}
//工作计划获取
Future<List<ListItemModel>> ITUserPlanListGet() async {
  var loginUrl = url + "datain";
  Response response;
  var dio = Dio();
  var a = {"userId": isLogin.id};
  response = await dio.get(loginUrl, queryParameters: a);
  //print(response.data.toString());
  List<ListItemModel> patrolList = (response.data)
      .map<ListItemModel>((e) => ListItemModel.fromJson(e))
      .toList();

  return patrolList;
}

//工作计划提交
Future<int> ITUserPlanListPost() async {}
//机房巡检获取
Future<int> ITUserPatrolListGet() async {}
//机房巡检提交
Future<int> ITUserPatrolListPost() async {}

//服务台内容获取
Future<int> ITCenterToDOList() async {}
//服务台处理分发
//..........

//报障平台内容获取
Future<List<ListItemModel>> ITCenterPatrolListGet() async {
  //await getDataFromServer();

  // static int a(){
  //   (testJson).map((e) => ListItemModel.fromJson(e)).toList();
  // }
  //
  // //List<ListItemModel> patrolList = (testJson).map((e) => ListItemModel.fromJson(e)).toList();
  // return patrolList;
}
//保障平台数据提交

//String jsonBody = jsonEncode(loginResModel);

// Future<int> login(String _id, String _password) async {
//   await Future.delayed(Duration(seconds: 1));
//   print('用户名:' + _id + '  密码:' + _password);
//
//   var body = {
//     'id': _id,
//     'password': _password,
//   };
//
//   request.headers[HttpHeaders.authorizationHeader] =
//       'Basic 021215421fbe4b0d27f:e74b71bbce';
//   //request.headers[HttpHeaders.contentTypeHeader] = 'application/json';
//   request.bodyFields = body;
//   var future = await client
//       .send(request)
//       .then((response) => response.stream
//           .bytesToString()
//           .then((value) => print(value.toString())))
//       .catchError((error) => print(error.toString()));
//   return 1;
//
//   //0：服务器未响应 1：登陆成功 2：用户名密码错误 3：其他错误
//   return 1;
// }
