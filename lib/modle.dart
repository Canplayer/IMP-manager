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