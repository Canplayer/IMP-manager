import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hnszlyyimp/model.dart';
import 'package:http/http.dart' as http;

var url = "http://127.0.0.1:3000/";

Future<int> login(String _id, String _password) async {
  Response response;
  var dio = Dio();
  response = await dio.get(url, queryParameters: {'id': 12, 'name': 'wendu'});
  print(response.data.toString());
  return 1;
}



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

Future<int> getBingWallpaper() async {}
