import 'package:somegame/services/auth.dart';

class User {
  final String id;
  String name = '';
  String? pushToken;
  DateTime? pushedAt;
  bool isCurrent = false;

  User({required this.id, required this.name});

  User.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        name = json['name'],
        pushedAt = json['pushedAt']?.toDate(),
        isCurrent = id == AuthService().currentUser!.id;

  Map<String, dynamic> toJson() {
    var res = Map<String, dynamic>();
    res['id'] = id;
    res['name'] = name;
    if (null != pushedAt) {
      res['pushedAt'] = pushedAt;
    }
    return res;
  }
}
