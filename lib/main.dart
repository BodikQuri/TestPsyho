import 'package:autorization_name/Screens/Autorization.dart';
import 'package:autorization_name/Screens/Landing.dart';
import 'package:autorization_name/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'domain/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error conection');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<UserDom>.value(
              value: AuthServise().currentUser,
              initialData: null,
              child: MaterialApp(
                  title: 'Autorization',
                  theme: ThemeData(
                      primaryColor: Color.fromRGBO(50, 65, 85, 1),
                      textTheme:
                          TextTheme(title: TextStyle(color: Colors.white))),
                  home: LandingPage()));
        }

        return Text('Wrong!');
      },),
    );
  }
}
