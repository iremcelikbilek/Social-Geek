import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/components/responsive/responsive_alert_dialog.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/models/blog.dart';
import 'package:social_geek/size_config.dart';
import 'package:social_geek/view_models/settings_view_model.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/profile/add_blog_page.dart';
import 'package:social_geek/views/app/profile/follow_page.dart';
import 'package:social_geek/views/app/profile/my_blog_page.dart';
import 'package:social_geek/views/app/profile/settings_page.dart';

Color mainColor = Colors.white;
Color generalBackgroundColor = Colors.white70;
Color backgroundColor2 = Color.fromRGBO(247, 247, 247, 1);



ImageProvider avatar = AssetImage('assets/images/avatar.png');

List<ImageProvider> images = [
  AssetImage('assets/images/signup.png'),
  AssetImage('assets/images/login.png'),
  AssetImage('assets/images/chat.png'),
];

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          CustomSocialHeader(),
          SocialInfo(),
          SocialFeed(),
        ],
      ),
    );
  }
}

class CustomSocialHeader extends StatefulWidget {
  @override
  _CustomSocialHeaderState createState() => _CustomSocialHeaderState();
}

class _CustomSocialHeaderState extends State<CustomSocialHeader> {
  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context);
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.safeBlockVertical * 55,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(75))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'My Profile',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              //Icon(Icons.arrow_back, color: mainColor),
              IconButton(
                icon: Icon(Icons.more_vert),
                color: Colors.white,
                onPressed: () => settingModalBottomSheet(context),
              ),
            ],
          ),
          Container(
            width: SizeConfig.safeBlockHorizontal * 45,
            height: SizeConfig.safeBlockVertical * 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(userViewModel.userModel.profileURL),
              ),
              boxShadow: [
                BoxShadow(
                  color: secondColor,
                  blurRadius: 45,
                  offset: Offset(0, 10),
                ),
              ],
            ),
          ),
          Container(),
          Text(
            userViewModel.userModel.userName,
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          Text(
            userViewModel.userModel.eMail,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: secondColor,
                fontFamily: "HachiMaruPop"),
          ),
        ],
      ),
    );
  }

  Future<bool> _signOut(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userViewModel.signOut();
    return result;
  }

  Future<void> _confirmForSignOut(BuildContext context) async {
    bool result = await ResponsiveAlertDialog(
      title: "Emin Misiniz ?",
      content: "Çıkmak istiyorsanız tamam butonuna basınız",
      mainButton: "Tamam",
      cancelButton: "Vazgeç",
    ).show(context);

    if (result) {
      _signOut(context);
    }
  }

  settingModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Wrap(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                            create: (context) => SettingsViewModel(),
                            child: SettingsPage()),
                      ),
                    )
                        .then((value) {
                      Navigator.of(context).pop();
                      setState(() {

                      });
                    });
                  },
                  leading: Icon(
                    Icons.settings,
                    color: secondColor,
                  ),
                  title: Text(
                    "Ayarlar",
                    style: TextStyle(color: mainColor),
                  ),
                ),
                ListTile(
                  onTap: (){
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context) => AddBlogPage())).then((value){
                      Navigator.of(context).pop();
                    });
                  },
                  leading: Icon(
                    Icons.article,
                    color: secondColor,
                  ),
                  title: Text(
                    "Blog Yazısı Ekle",
                    style: TextStyle(color: mainColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    _confirmForSignOut(context);
                  },
                  leading: Icon(
                    Icons.close,
                    color: secondColor,
                  ),
                  title: Text(
                    "Çıkış Yap",
                    style: TextStyle(color: mainColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    _confirmForSignOut(context);
                  },
                  leading: Icon(
                    Icons.close,
                    color: secondColor,
                  ),
                  title: Text(
                    "Çıkış Yap",
                    style: TextStyle(color: mainColor),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class SocialInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context);
    SizeConfig().init(context);
    return Stack(
      children: <Widget>[
        Container(
            height: SizeConfig.safeBlockVertical * 10, color: Colors.white38),
        Container(
          padding: EdgeInsets.only(top: 20),
          height: SizeConfig.safeBlockVertical * 10,
          decoration: BoxDecoration(
            color: darkBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(75),
              bottomRight: Radius.circular(75),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyBlogPage()));
                },
                child: Column(
                  children: <Widget>[
                    Text(
                      'My Articles',
                      style: TextStyle(color: secondColor, fontSize: 16),
                    ),
                   StreamBuilder(
                     stream: userViewModel.getMyBlog(userViewModel.userModel),
                     builder: (BuildContext context, AsyncSnapshot<List<Blog>> snapshot){
                       return  Text(
                         snapshot.data.length.toString() ?? "0",
                         style: TextStyle(
                             color: mainColor,
                             fontSize: 24,
                             fontWeight: FontWeight.w700),
                       );
                     },
                   ),
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => FollowPage(user: userViewModel.userModel)));
                },
                child: Column(
                  children: <Widget>[
                    Text(
                      'Followers',
                      style: TextStyle(color: secondColor, fontSize: 16),
                    ),
                    StreamBuilder(
                      stream: userViewModel.getFollowersNumber(userViewModel.userModel),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                      return Text(
                        snapshot.data.toString() ?? "0",
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      );
                    }),
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => FollowPage(user: userViewModel.userModel)));
                },
                child: Column(
                  children: <Widget>[
                    Text(
                      'Follows',
                      style: TextStyle(color: secondColor, fontSize: 16),
                    ),
                    StreamBuilder(
                      stream: userViewModel.getFollowsNumber(userViewModel.userModel),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                      return Text(
                        snapshot.data.toString() ?? "0",
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



}

class SocialFeed extends StatefulWidget {

  @override
  _SocialFeedState createState() => _SocialFeedState();
}

class _SocialFeedState extends State<SocialFeed> {

  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context);
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(75),
        ),
      ),
      child: Column(
        children: [
          (userViewModel.userModel.aboutMe == "") ? Container() :
      Container(
        width: MediaQuery.of(context).size.width,
        //padding: EdgeInsets.only(top: 10),
        height: SizeConfig.safeBlockVertical * 12,
        decoration: BoxDecoration(
          //color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(child: Text(userViewModel.userModel.aboutMe??"",style: TextStyle(color: mainColor,fontSize: 17),)),
      ),
          StaggeredGridView.countBuilder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  child: Image(image: images[index], fit: BoxFit.cover),
                ),
              );
            },
            staggeredTileBuilder: (index) {
              return StaggeredTile.count(1, index.isEven ? 2 : 1);
            },
          ),


        ],
      ),
    );
  }

  Widget generateCardList() {
    var userViewModel = Provider.of<UserViewModel>(context);
    var blogList = List<Blog>();
    void removeCards(index) {
      setState(() {
        blogList.removeAt(index);
      });
    }
   return StreamBuilder(
    stream : userViewModel.getMyBlog(userViewModel.userModel),
     builder: (BuildContext context, AsyncSnapshot<List<Blog>> snapshot){
      blogList = snapshot.data;
      return ListView.builder(itemBuilder: (context,index){
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: ((index +1) *10).toDouble(),
              child: Draggable(
                onDragEnd: (drag) {
                  removeCards(index);
                },
                childWhenDragging: Container(),
                feedback: InkWell(
                  onTap: (){},
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        Hero(
                          tag: "imageTag",
                          child: Image.network(
                            blogList[index].writerProfile,
                            width: 320.0,
                            height: 440.0,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(
                            blogList[index].title,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: mainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: (){},
                  child: Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      // color: Color.fromARGB(250, 112, 19, 179),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0)),
                              image: DecorationImage(
                                  image: NetworkImage(blogList[index].writerProfile),
                                  fit: BoxFit.cover),
                            ),
                            height: 480.0,
                            width: 320.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              blogList[index].title,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: mainColor,
                              ),
                            ),
                          )
                        ],
                      )),

                ),
              ),
            ),
          ],
        );
      });
     },
    );

  }
}

/*  StaggeredGridView.countBuilder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  child: Image(image: images[index], fit: BoxFit.cover),
                ),
              );
            },
            staggeredTileBuilder: (index) {
              return StaggeredTile.count(1, index.isEven ? 2 : 1);
            },
          ),*/
