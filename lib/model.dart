import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

//版本检查（未实现）
class VersionCheckModel {
  VersionCheckModel({
    this.version,
  });
  factory VersionCheckModel.fromJson(Map<String, dynamic> jsonRes) =>
      VersionCheckModel(
        version: asT<int?>(jsonRes['version']),
      );

  int? version;

  @override
  String toString() {
    return jsonEncode(this);
  }

  VersionCheckModel clone() => VersionCheckModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

//登陆数据模型
class SimpleModel {
  SimpleModel({this.result});
  factory SimpleModel.fromJson(Map<String, dynamic> jsonRes) {
    return SimpleModel(
      result: asT<String?>(jsonRes['result']),
    );
  }

  String? result;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'result': result,
      };

  LoginResModel clone() => LoginResModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
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
  factory LoginResModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<String>? _authority =
        jsonRes['authority'] is List ? <String>[] : null;
    if (_authority != null) {
      for (final dynamic item in jsonRes['authority']!) {
        if (item != null) {
          _authority.add(asT<String>(item)!);
        }
      }
    }
    return LoginResModel(
      result: asT<String?>(jsonRes['result']),
      authority: _authority,
      department: asT<String?>(jsonRes['department']),
      username: asT<String?>(jsonRes['username']),
      phone: asT<String?>(jsonRes['phone']),
      email: asT<String?>(jsonRes['email']),
    );
  }

  String? result;
  List<String>? authority;
  String? department;
  String? username;
  String? phone;
  String? email;
  String? id;

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
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

//工程师手动上报模型
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
    this.isThisWeek,
  });

  factory SelfMissionModel.fromJson(Map<String, dynamic> jsonRes) =>
      SelfMissionModel(
        id: asT<String?>(jsonRes['original-streams-id']),
        department: asT<String?>(jsonRes['department']),
        date: asT<String?>(jsonRes['faultdate']),
        name: asT<String?>(jsonRes['person2contact']),
        phone: asT<String?>(jsonRes['phone2contact']),
        type: asT<String?>(jsonRes['faulttype']),
        describe: asT<String?>(jsonRes['problemdescribe']),
        solution: asT<String?>(jsonRes['solution']),
        // isThisWeek: DateTime.now()
        //         .subtract(Duration(
        //             days: (DateTime.friday)))
        //         .microsecondsSinceEpoch <
        //     DateTime.parse(asT<String?>(jsonRes['faultdate'])!)
        //         .microsecondsSinceEpoch,

        isThisWeek: ((DateTime.now().weekday <= 5)
                ? DateTime.now()
                    .subtract(Duration(days: DateTime.now().weekday + 2))
                    .microsecondsSinceEpoch
                : DateTime.now()
                    .subtract(Duration(days: DateTime.now().weekday - 5))
                    .microsecondsSinceEpoch) <=
            DateTime.parse(asT<String?>(jsonRes['faultdate'])!)
                .microsecondsSinceEpoch,
      );
  String? id;
  String? department;
  String? date;
  String? name;
  String? phone;
  String? type;
  String? describe;
  String? solution;
  bool? isThisWeek;

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
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

//IT服务台数据模型
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

  factory MissionModel.fromJson(Map<String, dynamic> jsonRes) => MissionModel(
        id: asT<String?>(jsonRes['original-streams-id']),
        department: asT<String?>(jsonRes['department']),
        date: asT<String?>(jsonRes['faultdate']),
        time: asT<String?>(jsonRes['time']),
        engineer: asT<String?>(jsonRes['engineer']),
        progress: asT<String?>(jsonRes['faultprogress']),
        name: asT<String?>(jsonRes['person2contact']),
        phone: asT<String?>(jsonRes['phone2contact']),
        type: asT<String?>(jsonRes['faulttype']),
        describe: asT<String?>(jsonRes['problemdescribe']),
        solution: asT<String?>(jsonRes['solution']),
      );
  String? id;
  String? department;
  String? date;
  String? time;
  String? engineer;
  String? progress;
  String? name;
  String? phone;
  String? type;
  String? describe;
  String? solution;

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
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

//受支持故障类型列表模型
class SimpleListModel {
  SimpleListModel({
    this.data,
  });

  factory SimpleListModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<String>? _data = jsonRes['Data'] is List ? <String>[] : null;
    if (_data != null) {
      for (final dynamic item in jsonRes['Data']!) {
        if (item != null) {
          _data.add(asT<String>(item)!);
        }
      }
    }
    return SimpleListModel(
      data: _data,
    );
  }

  List<String>? data;

  @override
  String toString() {
    return jsonEncode(this);
  }

  SimpleListModel clone() => SimpleListModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

//工程师列表模型
class OpUserListModel {
  OpUserListModel({
    this.id,
    this.name,
    this.phone,
    this.email,
  });

  factory OpUserListModel.fromJson(Map<String, dynamic> jsonRes) =>
      OpUserListModel(
        id: asT<String?>(jsonRes['id']),
        name: asT<String?>(jsonRes['name']),
        phone: asT<String?>(jsonRes['phone']),
        email: asT<String?>(jsonRes['email']),
      );
  String? id;
  String? name;
  String? phone;
  String? email;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
      };

  OpUserListModel clone() => OpUserListModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
