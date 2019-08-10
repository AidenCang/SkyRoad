/**
 *
 * Project Name: SkyRoad
 * Package Name: common.model
 * File Name: user_model
 * USER: Aige
 * Create Time: 2019-08-05-14:21
 *
 */

class UserInfo {
  String _username;
  String _birthday;
  String _gender;
  String _mobile;
  String _email;

  UserInfo(
      {String username,
      Null birthday,
      String gender,
      String mobile,
      Null email}) {
    this._username = username;
    this._birthday = birthday;
    this._gender = gender;
    this._mobile = mobile;
    this._email = email;
  }

  String get username => _username;

  set username(String username) => _username = username;

  Null get birthday => _birthday;

  set birthday(Null birthday) => _birthday = birthday;

  String get gender => _gender;

  set gender(String gender) => _gender = gender;

  String get mobile => _mobile;

  set mobile(String mobile) => _mobile = mobile;

  Null get email => _email;

  set email(Null email) => _email = email;

  UserInfo.fromJson(Map<String, dynamic> json) {
    _username = json['username'];
    _birthday = json['birthday'] ?? "";
    _gender = json['gender'] ?? "";
    _mobile = json['mobile'] ?? "";
    _email = json['email'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this._username;
    data['birthday'] = this._birthday;
    data['gender'] = this._gender;
    data['mobile'] = this._mobile;
    data['email'] = this._email;
    return data;
  }
}
