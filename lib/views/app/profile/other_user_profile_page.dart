import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:social_geek/components/responsive/responsive_alert_dialog.dart';
import 'package:social_geek/components/rounded_button.dart';
import 'package:social_geek/constant.dart';
import 'package:social_geek/models/blog.dart';
import 'package:social_geek/models/user_model.dart';
import 'package:social_geek/size_config.dart';
import 'package:social_geek/view_models/user_view_model.dart';
import 'package:social_geek/views/app/profile/follow_page.dart';
import 'package:social_geek/views/app/profile/profile_page.dart';

class OtherUserProfilePage extends StatelessWidget {

  final UserModel otherUser;
  OtherUserProfilePage({@required this.otherUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          CustomSocialHeader(otherUser: otherUser,),
          SocialInfo(otherUser: otherUser),
          SocialFeed(otherUser: otherUser),
        ],
      ),
    );
  }
}

class CustomSocialHeader extends StatefulWidget {
  final UserModel otherUser;
  CustomSocialHeader({@required this.otherUser});
  @override
  _CustomSocialHeaderState createState() => _CustomSocialHeaderState();
}

class _CustomSocialHeaderState extends State<CustomSocialHeader> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context);
    userViewModel.checkFollow(userViewModel.userModel, widget.otherUser).then((isFollow){
      setState(() {
        if(isFollow){
          isPressed = true;
        }else{
          isPressed = false;
        }
      });
    });

    SizeConfig().init(context);
    return Container(
      height: SizeConfig.safeBlockVertical * 45,
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
              Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back_ios), color: mainColor, onPressed: (){
                    Navigator.of(context).pop();
                  },),
                  Text(
                    '${widget.otherUser.userName}',
                    style: TextStyle(fontSize: 30, color: mainColor),
                  ),
                ],
              ),
              (isPressed) ? FlatButton(onPressed: (){
                userViewModel.saveUnfollow(userViewModel.userModel, widget.otherUser);
                setState(() {
                  isPressed = false;
                });
              }, child: Text("Takipten Çık", style: TextStyle(color: mainColor,fontSize: 20),)):FlatButton(onPressed: (){
                userViewModel.saveFollows(userViewModel.userModel, widget.otherUser);
                setState(() {
                  isPressed = true;
                });
              }, child: Text("Takip Et", style: TextStyle(color: mainColor,fontSize: 20),)),
            ],
          ),
          Container(
            width: SizeConfig.safeBlockHorizontal * 25,
            height: SizeConfig.safeBlockVertical * 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(widget.otherUser.profileURL),
              ),
              boxShadow: [
                BoxShadow(
                  color: secondColor,
                  blurRadius: 40,
                  offset: Offset(0, 10),
                ),
              ],
            ),
          ),
          Container(),
          Text(
            widget.otherUser.userName,
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w700, color: mainColor),
          ),
          Text(
            widget.otherUser.eMail,
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

}

class SocialInfo extends StatelessWidget {
  final UserModel otherUser;
  SocialInfo({@required this.otherUser});
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
              Column(
                children: <Widget>[
                  Text(
                    'My Articles',
                    style: TextStyle(color: secondColor, fontSize: 16),
                  ),
                  StreamBuilder(
                    stream: userViewModel.getMyBlog(otherUser),
                      builder: (BuildContext context, AsyncSnapshot<List<Blog>> snapshot){
                      return Text(
                    snapshot.data.length.toString() ?? "0",
                    style: TextStyle(
                        color: mainColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  );})
                ],
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => FollowPage(user: otherUser)));
                },
                child: Column(
                  children: <Widget>[
                    Text(
                      'Followers',
                      style: TextStyle(color: secondColor, fontSize: 16),
                    ),
                    StreamBuilder(
                        stream: userViewModel.getFollowersNumber(otherUser),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                          return Text(
                            snapshot.data.toString() ?? "0",
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 25,
                                fontWeight: FontWeight.w700),
                          );
                        }),
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => FollowPage(user: otherUser)));
                },
                child: Column(
                  children: <Widget>[
                    Text(
                      'Follows',
                      style: TextStyle(color: secondColor, fontSize: 16),
                    ),
                    StreamBuilder(
                        stream: userViewModel.getFollowsNumber(otherUser),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                          return Text(
                            snapshot.data.toString() ?? "0",
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 25,
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

class SocialFeed extends StatelessWidget {
  final UserModel otherUser;
  SocialFeed({@required this.otherUser});

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
          (otherUser.aboutMe == "") ? Container() :
          Container(
            width: MediaQuery.of(context).size.width,
            height: SizeConfig.safeBlockVertical * 12,
            decoration: BoxDecoration(
              color: darkBackgroundColor,
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: Center(child: Text(otherUser.aboutMe??"",style: TextStyle(color: mainColor,fontSize: 17),)),
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
}
