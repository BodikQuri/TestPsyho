import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:autorization_name/Screens/InfoUser.dart';
import 'package:autorization_name/domain/user.dart';
import 'package:autorization_name/services/auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:autorization_name/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeUsers2 extends StatefulWidget {
  HomeUsers2({Key key}) : super(key: key);

  @override
  _HomeUsersState2 createState() => _HomeUsersState2();
}

class _HomeUsersState2 extends State<HomeUsers2> {
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
        backgroundColor: Theme.of(context).primaryColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              
              flexibleSpace: Stack(
                children: [
                  Positioned(
                   child: Container(
                    height: 320.sp,
                    width: MediaQuery.of(context).size.width,
                    //margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/userBack.jpg'),
                            fit: BoxFit.fitWidth))),
                  ),
                  Positioned(
                    right: 10.sp,
                    top: 30.sp,
                   child: TextButton.icon(
                          onPressed: () {
                            AuthServise().logOut();
                          },
                          icon: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ),
                          label: SizedBox.shrink()),
                  ),
                  Positioned(
                    top: 50.sp,
                    left: 10.sp,
                    child: Container(
                      height: 50.sp,
                      //width: MediaQuery.of(context).size.width,
                      //margin: EdgeInsets.only(top:100.sp),
                      child: Center(
                              child: Text(
                            'List Of Users:',
                            style: TextStyle(
                                color: Colors.white, fontSize: 25.sp),
                      )),
                    ),
                  ),
              ]
                  ),
                  
                  
          expandedHeight: 320.sp,
            ),
          
          SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(
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
                          child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => InfoUser(usersList[index])),
                            );
                          },
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
                        ),
                      
                      Switch(
                            value: usersAvatSaw[index],
                            onChanged: (bool value) {
                              setState(() {
                                usersAvatSaw[index] = value;
                              });
                            }),
                    ],
                  ),
                ),
              ])
              ),
              childCount: usersList != null ? usersList.length : 0,
              ),
            ),
          ],

        )
        
        );
  }
}
