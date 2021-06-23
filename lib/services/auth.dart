import 'package:autorization_name/domain/user.dart';
import 'package:autorization_name/services/database.dart';
import 'package:autorization_name/services/uploadFile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthServise {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return UserDom.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future<UserDom> registerWithEmailAndPassword(
      String name, String email, String password,
      {FileWork avatar}) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      UserDom curUser = await avatar.uploadFile(UserDom.fromFirebase(user, name: name));
      
      await DatabaseServise()
          .addUserInfo(curUser);
     
      return curUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<UserDom> get currentUser {
    return _fAuth
        .authStateChanges()
        .map((User user) => user != null ? UserDom.fromFirebase(user) : null);
  }
}
