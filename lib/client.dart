
import 'dart:convert';
import 'dart:io';
import 'package:hnszlyyimp/modle.dart';
import 'package:http/http.dart' as http;


Future<int> login(String _id, String _password) async {
  await Future.delayed(Duration(seconds: 1));
  return 1;
}

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


  var request = new http.Request('POST', Uri.parse(url));

  LoginResModel loginResModel = new LoginResModel();
  loginResModel.id="123";
  loginResModel.password="7777";
  String jsonBody = jsonEncode(loginResModel);


  var body = {'content':'234567uuuijhh', 'email':'john@doe.com', 'number':'441276300056'};
  request.headers[HttpHeaders.authorizationHeader] = 'Basic 021215421fbe4b0d27f:e74b71bbce';
  request.headers[HttpHeaders.contentTypeHeader] = 'application/json';
  request.bodyFields = body;
  var future = await client.send(request).then((response)
  => response.stream.bytesToString().then((value)
  => print(value.toString()))).catchError((error) => print(error.toString()));
  return 1;
}

Future<int> getBingWallpaper() async {
}