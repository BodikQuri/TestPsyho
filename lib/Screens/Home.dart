import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:autorization_name/domain/user.dart';
import 'package:autorization_name/services/auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:autorization_name/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeUsers extends StatefulWidget {
  HomeUsers({Key key}) : super(key: key);

  @override
  _HomeUsersState createState() => _HomeUsersState();
}

class _HomeUsersState extends State<HomeUsers> {
  DatabaseServise db = DatabaseServise();

  UserDom userDom = UserDom.test(id: '0', name: "name");
  List<UserDom> usersList;
  List<bool> usersAvatSaw;
  _loadData() async {
    var stream = db.getUsers();

    stream.listen((List<UserDom> data) {
      setState(() {
        usersList = data;
      });
    });
    if (usersAvatSaw == null) {
      usersAvatSaw = new List<bool>.filled(usersList.length, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadData();

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: 50.sp,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Text(
              'List Of Users:',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 20.sp),
            )),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.sp)),
          ),
          actions: [
            FlatButton.icon(
                onPressed: () {
                  AuthServise().logOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                label: SizedBox.shrink()),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(alignment: Alignment.topCenter, children: [
          Container(
              height: 320.sp,
              width: 320.sp,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/userBack.jpg'),
                      fit: BoxFit.cover))),
          ListView.builder(
            itemCount: usersList != null ? usersList.length : 0,
            padding: EdgeInsets.only(top: 200.sp),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Stack(children: [
                Container(
                  height: 100.sp,
                  margin: EdgeInsets.only(bottom: 40.sp, left: 10.sp),
                  padding: EdgeInsets.only(left: 40.sp),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.sp)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.sp),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CachedNetworkImage(
                        imageUrl: usersList[index].avatarURL,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 80.sp,
                          width: 80.sp,
                          padding: EdgeInsets.only(left: 0.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.sp),
                            image: DecorationImage(
                              image: usersAvatSaw[index]
                                  ? imageProvider
                                  : AssetImage('assets/avatar.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(10.sp),
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            '${usersList[index].name}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 50.sp),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile(
                            value: usersAvatSaw[index],
                            onChanged: (bool value) {
                              setState(() {
                                usersAvatSaw[index] = value;
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ])
              );
            },
          ),
        ]));
  }
}
