import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

//登陆数据模型
class LoginResModel {
  LoginResModel(
      {this.result,
      this.authority,
      this.department,
      this.username,
      this.phone,
      this.email,
      this.id});
  factory LoginResModel.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : LoginResModel(
              result: asT<String>(jsonRes['result']),
              authority: asT<String>(jsonRes['authority']),
              department: asT<String>(jsonRes['department']),
              username: asT<String>(jsonRes['username']),
              phone: asT<String>(jsonRes['phone']),
              email: asT<String>(jsonRes['email']),
            );

  String result;
  String authority;
  String department;
  String username;
  String phone;
  String email;
  String id;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'result': result,
        'authority': authority,
        'department': department,
        'username': username,
        'phone': phone,
        'email': email
      };

  ListItemModel clone() => ListItemModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this))));
}

// class ListItemModel {
//   //ListItemModel(this.department,this.phone,this.type,this.describe,this.status);
//   String department;
//   String phone;
//   String type;
//   String describe;
//   int status;
//
//   Map toJson() {
//     Map map = new Map();
//     map["department"] = this.department;
//     map["phone"] = this.phone;
//     map["type"] = this.type;
//     map["describe"] = this.describe;
//     map["status"] = this.status;
//     return map;
//   }
//
//   ListItemModel.ds(Map<String, dynamic> json)
//       : department = json['department'],
//         phone = json['phone'],
//         type = json['type'],
//         describe = json['describe'],
//         status = json['status'];
// }

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

//用于列表加载的模型
class ListItemModel {
  ListItemModel({
    this.id,
    this.department,
    this.name,
    this.phone,
    this.type,
    this.describe,
    this.solution,
  });

  factory ListItemModel.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : ListItemModel(
              id: asT<String>(jsonRes['{original-streams-id']),
              department: asT<String>(jsonRes['department']),
              name: asT<String>(jsonRes['person2contact']),
              phone: asT<String>(jsonRes['phone2contact']),
              type: asT<String>(jsonRes['faulttype']),
              describe: asT<String>(jsonRes['problemdescribe']),
              solution: asT<String>(jsonRes['solution']),
            );
  String id;
  String department;
  String name;
  String phone;
  String type;
  String describe;
  String solution;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'original-streams-id': id,
        'department': department,
        'person2contact': name,
        'phone2contact': phone,
        'type': type,
        'faulttype': type,
        'problemdescribe': describe,
        'solution': solution,
      };

  ListItemModel clone() => ListItemModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this))));
}
