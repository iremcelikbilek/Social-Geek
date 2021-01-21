import 'package:flutter/material.dart';
import 'package:social_geek/models/blog.dart';
import 'package:social_geek/size_config.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';

class MyBlogDetail extends StatelessWidget {
  final Blog blog;

  MyBlogDetail({this.blog});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(title: Text("MY ARTICLE", textAlign: TextAlign.center,),elevation: 0,),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height * (2/4),
          width: MediaQuery.of(context).size.width -20,
          left: SizeConfig.safeBlockHorizontal*2,
          top: MediaQuery.of(context).size.height * 0.1,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Başlık : " + blog.title, style: TextStyle(fontWeight: FontWeight.bold,color: mainColor,fontSize: 20),),
                SizedBox(height: SizeConfig.safeBlockVertical*3,),
                Text("Makale : " , style: TextStyle(fontWeight: FontWeight.bold,color: mainColor,fontSize: 20),),
                SizedBox(height: SizeConfig.safeBlockVertical*3,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Container(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal*10),
                    child: Text(blog.article , style: TextStyle(fontWeight: FontWeight.bold),))),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: SizeConfig.safeBlockHorizontal*30,
            height: SizeConfig.safeBlockVertical*20,
            child:  Hero(tag: blog.title, child: CircleAvatar(backgroundImage: NetworkImage(blog.writerProfile),)),
          ),
        ),
      ],
    );
  }
}
