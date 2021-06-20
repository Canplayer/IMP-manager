class LoginResModel {
  String id;
  String password;

  Map toJson() {
    Map map = new Map();
    map["id"] = this.id;
    map["password"] = this.password;
    return map;
  }
}

class ListItemModel {
  String department;
  String phone;
  String type;
  String describe;
//  String Result;
  int status;

  Map toJson() {
    Map map = new Map();
    map["department"] = this.department;
    map["phone"] = this.phone;
    map["type"] = this.type;
    map["describe"] = this.describe;
    // map["Result"] = this.Result;
    map["status"] = this.status;
    return map;
  }
}