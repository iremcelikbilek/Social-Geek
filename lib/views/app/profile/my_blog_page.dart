import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/models/blog.dart';
import 'package:social_geek/size_config.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/profile/my_blog_detail.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';
import 'package:social_geek/views/app/profile/settings_page.dart';

class MyBlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("MY BLOG PAGE"),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context);
    return StreamBuilder(
      stream: userViewModel.getMyBlog(userViewModel.userModel),
      builder: (BuildContext context, AsyncSnapshot<List<Blog>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data.length == null) {
          return Center(
              child: Text(
            "HENÜZ MAKALENİZ YOK",
            style: TextStyle(color: mainColor),
          ));
        } else {
          List<Blog> blogList = snapshot.data;
          return  GridView.builder(
            itemCount: blogList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyBlogDetail(blog: blogList[index]),
                  ));
                },
                child: Hero(tag: blogList[index].title, child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: darkBackgroundColor,
                  elevation: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        child: FadeInImage.assetNetwork(placeholder: "assets/loading.gif", image: blogList[index].writerProfile),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical*2,),
                      Text(blogList[index].title, style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                )),
              );
            },
          );
        }
      },
    );
  }
}
