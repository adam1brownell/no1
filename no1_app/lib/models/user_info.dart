// lib/models/user_info.dart

class UserInfo {
  int? id;
  String? userName;
  bool? activeExp;

  UserInfo({this.id = 1, this.userName, this.activeExp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_name': userName,
      'activeExp': activeExp == true ? 1 : 0,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['id'],
      userName: map['user_name'],
      activeExp: map['activeExp'] == 1,
    );
  }
}
