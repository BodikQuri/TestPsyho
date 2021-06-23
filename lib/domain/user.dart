import 'package:firebase_auth/firebase_auth.dart';

class UserDom {
  String id;
  String name;
  String avatarURL;

  UserDom.test({this.id, this.name}) {}

  UserDom.fromFirebase(User user, {this.name}) {
    id = user.uid;
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "avatarURL": avatarURL};
  }

  UserDom.clone(UserDom sourse) {
    this.id = sourse.id;
    this.name = sourse.name;
    this.avatarURL = sourse.avatarURL;
  }

  UserDom.formList(String uid, Map<String, dynamic> data) {
    id = uid;
    name = data["name"];
    avatarURL = data["avatarURL"];
  }
}
