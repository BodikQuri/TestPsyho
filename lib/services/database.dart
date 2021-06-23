import 'dart:io';
import 'dart:typed_data';

import 'package:autorization_name/domain/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseServise {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('usersInfo');

  Future addUserInfo(UserDom user) async {
    return await _users.doc(user.id).set(user.toMap());
  }

  Stream<List<UserDom>> getUsers() {
    return _users.snapshots().map((QuerySnapshot data) => data.docs
        .map((DocumentSnapshot doc) => UserDom.formList(doc.id, doc.data()))
        .toList());
  }

  static UploadTask uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  Future loadAvatar(UserDom userDom) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('${userDom.id}_avatar');
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
