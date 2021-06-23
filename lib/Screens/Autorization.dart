import 'dart:io';

import 'package:autorization_name/services/uploadFile.dart';
import 'package:autorization_name/domain/user.dart';
import 'package:autorization_name/services/auth.dart';
import 'package:autorization_name/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class AutorizationPage extends StatefulWidget {
  AutorizationPage({Key key}) : super(key: key);

  @override
  _AutorizationPageState createState() => _AutorizationPageState();
}

class _AutorizationPageState extends State<AutorizationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordRepiedController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  FileWork fileWork = FileWork();

  String _email;
  String _password;
  String _name;
  bool showLogin = true;
  bool noAvatar = true;
  bool avatarCamera;

  AuthServise _authServise = AuthServise();

  Widget _input(
      Icon icon, String hint, TextEditingController controller, bool obsecure) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        controller: controller,
        obscureText: obsecure,
        style: TextStyle(fontSize: 20, color: Colors.white),
        decoration: InputDecoration(
            hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white30),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54, width: 1),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: IconThemeData(color: Colors.white),
                child: icon,
              ),
            )),
      ),
    );
  }

  Widget _button(String text, void func()) {
    return RaisedButton(
        splashColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).primaryColor,
        color: Colors.white,
        child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 20)),
        onPressed: func);
  }

  Widget _formLogin(String label, void func()) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 100),
            child: _input(Icon(Icons.email), "Email", _emailController, false),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: _input(
                Icon(Icons.security), "Password", _passwordController, true),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _button(label, func),
            ),
          )
        ],
      ),
    );
  }

  showMyAlertDialog(BuildContext context) {
    // Create SimpleDialog
    SimpleDialog dialog = SimpleDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text('Camera or Galery?'),
      children: <Widget>[
        SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Icon(Icons.camera)),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Icon(Icons.upload_file),
        ),
      ],
    );

    // Call showDialog function to show dialog.
    Future<bool> futureValue = showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });

    futureValue.then((answer) => {
          this.setState(() {
            this.avatarCamera = answer;
          })
        });
  }

  Widget _formRegister(String label, void func()) {
    return Expanded(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20, top: 20),
                child: GestureDetector(
                  child: Container(
                    height: 320,
                    width: 320,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: noAvatar
                                ? AssetImage('assets/avatar.jpg')
                                : MemoryImage(fileWork.file.readAsBytesSync()),
                            fit: BoxFit.cover)),
                  ),
                  onTap: () async {
                    showMyAlertDialog(context);
                    await new Future.delayed(const Duration(seconds: 2));
                    if (avatarCamera != null) {
                      if (avatarCamera) {
                        fileWork.getImageCamera();
                      } else {
                        fileWork.selectFile();
                      }
                    }
                    avatarCamera = null;

                    await new Future.delayed(const Duration(seconds: 4));
                    setState(() {
                      // ignore: unnecessary_statements
                      if (fileWork.file != null) noAvatar = false;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child:
                    _input(Icon(Icons.people), "Name", _nameController, false),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child:
                    _input(Icon(Icons.email), "Email", _emailController, false),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: _input(Icon(Icons.security), "Password",
                    _passwordController, true),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: _input(Icon(Icons.security_sharp), "Repied Password",
                    _passwordRepiedController, true),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: _button(label, func),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loginUser() async {
    _email = _emailController.text;
    _password = _passwordController.text;

    if (_email.isEmpty || _password.isEmpty) return;

    UserDom user =
        await _authServise.signInWithEmailandPassword(_email, _password);

    if (user == null) {
      Fluttertoast.showToast(
          msg: "Can't SignIn you! Please check your email/password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      _emailController.clear();
      _passwordController.clear();
    }
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  void _registerUser() async {
    _email = _emailController.text;
    _password = _passwordController.text;
    _name = _nameController.text;

    if (_email.isEmpty || _password.isEmpty || _name.isEmpty) return;
    if (_password != _passwordRepiedController.text) {
      Fluttertoast.showToast(
          msg: "Password and Repied Password not same",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    dynamic user = await _authServise.registerWithEmailAndPassword(
        _name.trim(), _email.trim(), _password.trim(),
        avatar: noAvatar
            ? FileWork.setFile(await getImageFileFromAssets('avatar.jpg'))
            : fileWork);

    if (user == null)
      Fluttertoast.showToast(
          msg: "Can't Register you! Please check your email/password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    else {
      try {} catch (e) {
        print(e);
        return;
      }

      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _passwordRepiedController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
     ScreenUtil.init(BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            Expanded(
              child: (showLogin
                  ? Column(
                      children: [
                        _formLogin('LOGIN', _loginUser),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            child: Text(
                              'Not Register? Do this!',
                              style:
                                  TextStyle(fontSize: 20.sp, color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                showLogin = false;
                              });
                            },
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        _formRegister('Register', _registerUser),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            child: Text(
                              'Registered? Login!',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                showLogin = true;
                              });
                            },
                          ),
                        )
                      ],
                    )),
            ),
          ],
        ));
  }
}
