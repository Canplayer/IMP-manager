import 'dart:convert';

class VersionCheckModel {
  VersionCheckModel({
    this.version,
  });
  factory VersionCheckModel.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : VersionCheckModel(
              version: asT<int>(jsonRes['version']),
            );

  int version;

  @override
  String toString() {
    return jsonEncode(this);
  }

  VersionCheckModel clone() => VersionCheckModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this))));
}

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
  factory LoginResModel.fromJson(Map<String, dynamic> jsonRes){
    if (jsonRes == null) {
      return null;
    }

    final List<String> _authority = jsonRes['authority'] is List ? <String>[] : null;
    if (_authority != null) {
      for (final dynamic item in jsonRes['authority']) {
        if (item != null) {
          _authority.add(asT<String>(item));
        }
      }
    }
    return LoginResModel(
                  result: asT<String>(jsonRes['result']),
                  authority: _authority,
                  department: asT<String>(jsonRes['department']),
                  username: asT<String>(jsonRes['username']),
                  phone: asT<String>(jsonRes['phone']),
                  email: asT<String>(jsonRes['email']),
    );
  }
  // =>
  //     jsonRes == null
  //         ? null
  //         : LoginResModel(
  //             result: asT<String>(jsonRes['result']),
  //             authority: List<String>.from(jsonRes['authority']),
  //             department: asT<String>(jsonRes['department']),
  //             username: asT<String>(jsonRes['username']),
  //             phone: asT<String>(jsonRes['phone']),
  //             email: asT<String>(jsonRes['email']),
  //           );

  String result;
  List<String> authority;
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

  LoginResModel clone() => LoginResModel.fromJson(
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

//用于列表工程师自定义数据上报模型
class SelfMissionModel {
  SelfMissionModel({
    this.id,
    this.department,
    this.date,
    this.name,
    this.phone,
    this.type,
    this.describe,
    this.solution,
  });

  factory SelfMissionModel.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : SelfMissionModel(
              id: asT<String>(jsonRes['original-streams-id']),
              department: asT<String>(jsonRes['department']),
              date: asT<String>(jsonRes['faultdate']),
              name: asT<String>(jsonRes['person2contact']),
              phone: asT<String>(jsonRes['phone2contact']),
              type: asT<String>(jsonRes['faulttype']),
              describe: asT<String>(jsonRes['problemdescribe']),
              solution: asT<String>(jsonRes['solution']),
            );
  String id;
  String department;
  String date;
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
        'faultdate': date,
        'person2contact': name,
        'phone2contact': phone,
        'type': type,
        'faulttype': type,
        'problemdescribe': describe,
        'solution': solution,
      };

  SelfMissionModel clone() => SelfMissionModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this))));
}

class MissionModel {
  MissionModel({
    this.id,
    this.department,
    this.date,
    this.time,
    this.engineer,
    this.progress,
    this.name,
    this.phone,
    this.type,
    this.describe,
    this.solution,
  });

  factory MissionModel.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : MissionModel(
        id: asT<String>(jsonRes['original-streams-id']),
        department: asT<String>(jsonRes['department']),
        date: asT<String>(jsonRes['faultdate']),
        time: asT<String>(jsonRes['time']),
        engineer: asT<String>(jsonRes['engineer']),
        progress: asT<String>(jsonRes['faultprogress']),
        name: asT<String>(jsonRes['person2contact']),
        phone: asT<String>(jsonRes['phone2contact']),
        type: asT<String>(jsonRes['faulttype']),
        describe: asT<String>(jsonRes['problemdescribe']),
        solution: asT<String>(jsonRes['solution']),
      );
  String id;
  String department;
  String date;
  String time;
  String engineer;
  String progress;
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
    'faultdate': date,
    'person2contact': name,
    'phone2contact': phone,
    'type': type,
    'faulttype': type,
    'problemdescribe': describe,
    'solution': solution,
  };

  MissionModel clone() => MissionModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this))));
}

class TypeListModel {
  TypeListModel({
    this.data,
  });

  factory TypeListModel.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : TypeListModel(
              data: List<String>.from(jsonRes['Data']),
            );
  List<String> data;

  @override
  String toString() {
    return jsonEncode(this);
  }

  TypeListModel clone() => TypeListModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this))));
}
