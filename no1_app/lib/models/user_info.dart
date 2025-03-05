// lib/models/user_info.dart

class UserInfo {
  int id;
  String userName;
  int age;
  bool activeExp;
  String? ouraPullDate;

  UserInfo({
    this.id = 1,
    required this.userName,
    required this.age,
    required this.activeExp,
    this.ouraPullDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_name': userName,
      'age': age,
      'activeExp': activeExp ? 1 : 0,
      'ouraPullDate': ouraPullDate,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['id'],
      userName: map['user_name'],
      age: map['age'],
      activeExp: map['activeExp'] == 1,
      ouraPullDate: map['ouraPullDate'],
    );
  }
}
