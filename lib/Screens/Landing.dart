import 'package:autorization_name/Screens/Autorization.dart';
import 'package:autorization_name/Screens/Home.dart';
import 'package:autorization_name/Screens/Home2.dart';
import 'package:autorization_name/services/uploadFile.dart';
import 'package:autorization_name/domain/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LandingPage extends StatelessWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserDom user = Provider.of<UserDom>(context);

    final bool isLoggedId = user!=null;

    return isLoggedId ? HomeUsers2() : AutorizationPage();
  }
}
