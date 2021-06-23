import 'package:auto_size_text/auto_size_text.dart';
import 'package:autorization_name/domain/user.dart';
import 'package:autorization_name/services/auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoUser extends StatelessWidget {
  final UserDom userDom;
  InfoUser(this.userDom, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Stack(children: [
                Positioned(
                  child: CachedNetworkImage(
                    imageUrl: userDom.avatarURL,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 320.sp,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 0.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.sp),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Positioned(
                  left: 10.sp,
                  top: 20.sp,
                  child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.pink,
                      ),
                      label: SizedBox.shrink()),
                ),
                Positioned(
                  bottom: 5.sp,
                  left: 10.sp,
                  child: Container(
                    height: 30.sp,
                    //width: MediaQuery.of(context).size.width,
                    //margin: EdgeInsets.only(top:100.sp),
                    child: Center(
                        child: Text(
                      'Info bout user:',
                      style: TextStyle(color: Colors.pink, fontSize: 25.sp),
                    )),
                  ),
                ),
              ]),
              Container(
                  margin: EdgeInsets.all(10.sp),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.verified_user),
                      SizedBox(width: 10.sp,),
                      Container(child: 
                        Text(
                          'Name:', 
                          style: TextStyle(color: Colors.white, fontSize: 25.sp),
                        ),
                      ),
                      Expanded(
                        
                        child: 
                        Container(
                          alignment: Alignment.center,  
                          child: 
                          AutoSizeText(
                            '${userDom.name}', 
                            style: TextStyle(color: Colors.white, fontSize: 25.sp), 
                            maxLines: 1,
                          ),
                        ),
                      )
                    ],
                  )
                ),
                Container(
                  margin: EdgeInsets.all(10.sp),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.verified_user),
                      SizedBox(width: 10.sp,),
                      Container(child: 
                        Text(
                          'id:', 
                          style: TextStyle(color: Colors.white, fontSize: 25.sp),
                        ),
                      ),
                      Expanded(
                        
                        child: 
                        Container(
                          alignment: Alignment.center,  
                          child: 
                          AutoSizeText(
                            '${userDom.id}', 
                            style: TextStyle(color: Colors.white, fontSize: 25.sp), 
                            maxLines: 1,
                          ),
                        ),
                      )
                    ],
                  )
                ),
                Container(
                  margin: EdgeInsets.all(10.sp),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.verified_user),
                      SizedBox(width: 10.sp,),
                      Container(child: 
                        Text(
                          'avatarURL:', 
                          style: TextStyle(color: Colors.white, fontSize: 25.sp),
                        ),
                      ),
                      Expanded(
                        
                        child: 
                        Container(
                          alignment: Alignment.center,  
                          child: 
                          AutoSizeText(
                            '${userDom.avatarURL}', 
                            style: TextStyle(color: Colors.white, fontSize: 25.sp), 
                            maxLines: 4,
                          ),
                        ),
                      )
                    ],
                  )
                ),
        ],)
        
        );
  }
}
